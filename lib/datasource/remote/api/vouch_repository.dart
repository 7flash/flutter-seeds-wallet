import 'dart:async';

import 'package:async/async.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:eosdart/eosdart.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/eos_repository.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_scopes.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_tables.dart';
import 'package:seeds/datasource/remote/api/network_repository.dart';
import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/datasource/remote/model/vouch_model.dart';

class VouchRepository extends NetworkRepository with EosRepository {
  Future<Result<TransactionResponse>> vouch({
    required String accountName,
    required String vouchee,
  }) async {
    print('[eos] vouch for $vouchee');

    final transaction = buildFreeTransaction([
      Action()
        ..account = SeedsCode.accountAccounts.value
        ..name = actionNameVouch
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = permissionActive
        ]
        ..data = {
          'sponsor_tab': accountName,
          'account': vouchee,
        },
    ], accountName);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse<TransactionResponse>(response, (dynamic map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }

  /// users where accountName is sponsor_tab - who accountname vouched_tab for
  Future<Result<List<VouchModel>>> getVouchees(String accountName) {
    return _getVouches(accountName, true);
  }

  /// users who are sponsors for accountName
  Future<Result<List<VouchModel>>> getSponsors(String accountName) {
    return _getVouches(accountName, false);
  }

  Future<Result<List<VouchModel>>> _getVouches(String accountName, bool isSponsor) {
    print('[http] users where $accountName ($isSponsor ? "is sponsor_tab" : "was sponsored")');

    final membersURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    final request = createRequest(
      code: SeedsCode.accountAccounts,
      scope: SeedsCode.accountAccounts.value,
      indexPosition: isSponsor ? 3 : 2,
      lowerBound: accountName,
      upperBound: accountName,
      table: SeedsTable.tableVouches,
      limit: 200,
    );

    return http
        .post(membersURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<List<VouchModel>>(response, (dynamic body) {
              print("result $isSponsor: $body");
              final List<dynamic> items = body['rows'].toList();
              return items.map((item) => VouchModel.fromJson(item)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }
}
