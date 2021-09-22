import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/proposals_repository.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/viewmodels/proposal_view_model.dart';

class VoteProposalUseCase {
  Future<Result> run({required ProposalViewModel proposal, required int amount}) {
    final ProposalsRepository _proposalsRepository = ProposalsRepository();
    final String accountName = settingsStorage.accountName;
    if (proposal.proposalCategory == ProposalCategory.referendum) {
      return _proposalsRepository.voteReferendum(id: proposal.id, amount: amount, accountName: accountName);
    } else {
      return _proposalsRepository.voteProposal(id: proposal.id, amount: amount, accountName: accountName);
    }
  }
}
