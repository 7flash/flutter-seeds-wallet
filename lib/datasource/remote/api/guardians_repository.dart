import 'package:async/async.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:dart_esr/dart_esr.dart' as esr;

// ignore: import_of_legacy_library_into_null_safe
import 'package:eosdart/eosdart.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/mock/mock_repository.dart';
import 'package:seeds/datasource/remote/api/eos_repository.dart';
import 'package:seeds/datasource/remote/api/network_repository.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/datasource/remote/model/account_guardians_model.dart';
import 'package:seeds/datasource/remote/model/user_recover_model.dart';
import 'package:seeds/domain-shared/app_constants.dart';

class GuardiansRepository extends EosRepository with NetworkRepository {
  /// Step 1 in the guardian set up - call this to allow the guard.seeds contract to
  /// change the key.
  ///
  /// Before the guardian contract can act on a recovery request, the users account needs to
  /// allow the guardian contract to change the keys.
  ///
  Future<Result> setGuardianPermission() async {
    print('[eos] setGuardianPermission');

    final Result currentPermissions = await _getAccountPermissions();
    // Error Fetching permissions.
    if (currentPermissions.isError) {
      print('[eos] currentPermissions.isError Error fetching permissions');
      return currentPermissions;
    }

    final Permission ownerPermission =
        (currentPermissions.asValue!.value as List<Permission>).firstWhere((item) => item.permName == 'owner');

    // Check if permissions are already set?
    // ignore: unnecessary_cast
    for (final Map<String, dynamic> acct in ownerPermission.requiredAuth.accounts as List<dynamic>) {
      if (acct['permission']['actor'] == account_guards) {
        print('permission already set, doing nothing');
        return currentPermissions;
      }
    }

    ownerPermission.requiredAuth.accounts.add({
      'weight': ownerPermission.requiredAuth.threshold,
      'permission': {'actor': account_guards, 'permission': 'eosio.code'}
    });

    return await _updatePermission(ownerPermission);
  }

  /// Step 2 setting up guardians - set the guardians for an account
  ///
  /// guardians - list of Seeds account names that are the guardians - 3, 4, or 5 elements.
  ///
  /// Will fail when it's already set up - in that case, call cancelGuardians first.
  ///
  Future<Result> initGuardians(List<String> guardians) async {
    print('[eos] init guardians: $guardians');

    final accountName = settingsStorage.accountName;

    final actions = [
      Action()
        ..account = account_guards
        ..name = actionNameInit
        ..data = {
          'user_account': accountName,
          'guardian_accounts': guardians,
          'time_delay_sec': guardianRecoveryTimeDelaySec,
        }
    ];

    for (final action in actions) {
      action.authorization = [
        Authorization()
          ..actor = accountName
          ..permission = permissionActive
      ];
    }

    final transaction = buildFreeTransaction(actions, accountName);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse(response, (dynamic map) {
              return response["transaction_id"];
            }))
        .catchError((error) => mapEosError(error));
  }

  /// Claim recovered account for user - this switches the new public key live at the end of the
  /// recovery process.
  ///
  /// This can be called without logging in - the assumption is that the user lost their key,
  /// asked for recovery, was recovered, waited 24 hours for the time lock - and then calls this
  /// method to regain access.
  ///
  Future<Result> claimRecoveredAccount(String userAccount) async {
    print('[eos] claim recovered account $userAccount');

    final actions = [
      Action()
        ..account = account_guards
        ..name = actionNameClaim
        ..data = {'user_account': userAccount}
    ];

    for (final action in actions) {
      action.authorization = [
        Authorization()
          ..actor = account_guards
          ..permission = permissionApplication
      ];
    }

    final transaction = Transaction()
      ..actions = [
        ...actions,
      ];

    return EOSClient(baseURL, 'v1', privateKeys: [onboardingPrivateKey])
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse(response, (dynamic map) {
              return response["transaction_id"];
            }))
        .catchError((error) => mapEosError(error));
  }

  /// Cancel guardians.
  ///
  /// This cancels any recovery currently in process, and removes all guardians
  ///
  Future<Result> cancelGuardians() async {
    final accountName = settingsStorage.accountName;
    print('[eos] cancel recovery $accountName');

    final actions = [
      Action()
        ..account = account_guards
        ..name = actionNameCancel
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = permissionOwner
        ]
        ..data = {'user_account': accountName}
    ];

    final transaction = buildFreeTransaction(actions, accountName);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse(response, (dynamic map) {
              return response["transaction_id"];
            }))
        .catchError((error) => mapEosError(error));
  }

  /// Recover an account via the key guardian system
  ///
  /// userAcount - the account to recovery, iE current user is a guardian for userAccount
  /// publicKey - the new public key on the account once the recovery is complete
  ///
  /// When 2 or 3 of the guardians call this function, the account can be recovered with claim
  ///
  Future<Result> recoverAccount(String userAccount, String publicKey) async {
    print('[eos] recover account $userAccount');

    final accountName = settingsStorage.accountName;

    final actions = [
      Action()
        ..account = account_guards
        ..name = actionNameRecover
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = permissionOwner
        ]
        ..data = {
          'guardian_account': accountName,
          'user_account': userAccount,
          'new_public_key': publicKey,
        }
    ];

    final transaction = buildFreeTransaction(actions, accountName);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse(response, (dynamic map) {
              return response["transaction_id"];
            }))
        .catchError((error) => mapEosError(error));
  }

  Future<Result<dynamic>> _getAccountPermissions() async {
    print('[http] get account permissions');
    final accountName = settingsStorage.accountName;

    final url = Uri.parse('$baseURL/v1/chain/get_account');
    final body = '{ "account_name": "$accountName" }';

    return http
        .post(url, headers: headers, body: body)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              final List<dynamic> allAccounts = body['permissions'].toList();
              return allAccounts.map((item) => Permission.fromJson(item)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<dynamic> _updatePermission(Permission permission) async {
    print('[eos] update permission ${permission.permName}');

    final permissionsMap = _requiredAuthToJson(permission.requiredAuth!);

    print('converted JSPN: ${permissionsMap.toString()}');
    final accountName = settingsStorage.accountName;

    final actions = [
      Action()
        ..account = account_eosio
        ..name = actionNameUpdateauth
        ..data = {
          'account': accountName,
          'permission': permission.permName,
          'parent': permission.parent,
          'auth': permissionsMap
        }
    ];

    for (final action in actions) {
      action.authorization = [
        Authorization()
          ..actor = accountName
          ..permission = permissionOwner
      ];
    }

    final transaction = buildFreeTransaction(actions, accountName);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse(response, (dynamic map) {
              return response["transaction_id"];
            }))
        .catchError((error) => mapEosError(error));
  }

  Future<Result<dynamic>> getAccountRecovery(String accountName) async {
    print('[http] get account recovery $accountName');

    if (MockRepository.isMockMode) {
      return MockRepository().mockGetAccountRecovery(accountName);
    }

    final String requestURL = "$baseURL/v1/chain/get_table_rows";

    final String request = createRequest(
        code: account_guards,
        scope: account_guards,
        table: tableRecover,
        lowerBound: accountName,
        upperBound: accountName);

    return http
        .post(Uri.parse(requestURL), headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              final rows = body["rows"] as List<dynamic>;
              return UserRecoversModel.fromTableRows(rows);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<dynamic>> getAccountGuardians(String accountName) async {
    print('[http] get account guardians');

    if (MockRepository.isMockMode) {
      return MockRepository().mockGetAccountGuardians(accountName);
    }

    final String requestURL = "$baseURL/v1/chain/get_table_rows";

    final String request = createRequest(
      code: account_guards,
      scope: account_guards,
      table: tableGuards,
      lowerBound: accountName,
      upperBound: accountName,
    );

    return http
        .post(Uri.parse(requestURL), headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              final rows = body["rows"] as List<dynamic>;
              return UserGuardiansModel.fromTableRows(rows);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<dynamic>> generateRecoveryRequest(String accountName, String publicKey) async {
    print('[ESR] generateRecoveryRequest: $accountName publicKey: ($publicKey)');

    final List<esr.Authorization> auth = [esr.ESRConstants.PlaceholderAuth];

    final Map<String, String> data = {
      'guardian_account': esr.ESRConstants.PlaceholderName,
      'user_account': accountName,
      'new_public_key': publicKey,
    };

    final esr.Action action = esr.Action()
      ..account = account_guards
      ..name = 'recover'
      ..authorization = auth
      ..data = data;

    final esr.SigningRequestCreateArguments args = esr.SigningRequestCreateArguments(action: action, chainId: chain_id);

    return esr.SigningRequestManager.create(args,
            options: esr.defaultSigningRequestEncodingOptions(
              nodeUrl: remoteConfigurations.hyphaEndPoint,
            ))
        .then((esr.SigningRequestManager response) => ValueResult(response.encode()))
        // ignore: return_of_invalid_type_from_catch_error
        .catchError((error) => mapEosError(error));
  }
}

// method to properly convert RequiredAuth to JSON - the library doesn't work
Map<String, dynamic> _requiredAuthToJson(RequiredAuth instance) => <String, dynamic>{
      'threshold': instance.threshold,
      'keys': List<dynamic>.from(instance.keys!.map((e) => e.toJson())),
      'accounts': instance.accounts,
      'waits': instance.waits
    };
