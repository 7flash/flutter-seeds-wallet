import 'package:flutter/foundation.dart';
import 'package:seeds/datasource/remote/model/account_guardians_model.dart';
import 'package:seeds/datasource/remote/model/user_recover_model.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:async/async.dart';

class MockRepository {
  static const bool _LiveMockMode = false;

  static bool get isMockMode => _LiveMockMode && !kReleaseMode;

  Future<Result<dynamic>> mockGetAccountRecovery(String accountName) async {
    return ValueResult(
      UserRecoversModel(
        alreadySignedGuardians: ["testingseed1", "testingseed2", "testingseed3"],
        publicKey: "EOS6XYZ",
        completeTimestamp: (DateTime.now().millisecondsSinceEpoch ~/ 1000) - 60 * 19,
      ),
    );
  }

  Future<Result<dynamic>> mockGetAccountGuardians(String accountName) async {
    return ValueResult(
      UserGuardiansModel(
        guardians: ["testingseed1", "testingseed2", "testingseed3"],
        timeDelaySec: 60 * 20,
      ),
    );
  }
}
