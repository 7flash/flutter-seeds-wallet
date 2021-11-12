import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/eos_repository.dart';
import 'package:seeds/datasource/remote/api/proposals_repository.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';

class GetInitialVoteSectionDataUseCase {
  final ProposalsRepository _proposalsRepository = ProposalsRepository();

  Future<List<Result>> run() async {
    final account = settingsStorage.accountName;
    return Future.wait([
      _proposalsRepository.getCurrentVoteCycle(),
      _proposalsRepository.getDelegate(account, EosRepository.voiceScopeAlliance),
      _proposalsRepository.getDelegate(account, EosRepository.voiceScopeCampaign),
      _proposalsRepository.getDelegate(account, EosRepository.voiceScopeMilestone)
    ]);
  }
}
