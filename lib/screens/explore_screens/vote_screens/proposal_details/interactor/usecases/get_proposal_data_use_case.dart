import 'package:async/async.dart';
import 'package:seeds/datasource/local/cache_repository.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/profile_repository.dart';
import 'package:seeds/datasource/remote/api/proposals_repository.dart';
import 'package:seeds/datasource/remote/api/voice_repository.dart';
import 'package:seeds/datasource/remote/model/vote_model.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/viewmodels/proposal_view_model.dart';

class GetProposalDataUseCase {
  final ProfileRepository _profileRepository = ProfileRepository();
  final ProposalsRepository _proposalsRepository = ProposalsRepository();
  final VoiceRepository _voiceRepository = VoiceRepository();

  Future<List<Result>> run(ProposalViewModel proposal) {
    final userAccount = settingsStorage.accountName;
    final _getVoice = _getVoiceCall(proposalCategory: proposal.proposalCategory, userAccount: userAccount);

    final futures = [
      _profileRepository.getProfile(proposal.creator),
      _fetchVote(proposal, userAccount),
      _getVoice,
    ];
    return Future.wait(futures);
  }

  Future<Result> _fetchVote(ProposalViewModel proposal, String account) async {
    final cacheRepository = const CacheRepository();
    late Result result;
    VoteModel? voteModel;

    if (proposal.proposalCategory == ProposalCategory.referendum) {
      voteModel = await cacheRepository.getReferendumVote(account, proposal.id);
      if (voteModel == null) {
        result = await _proposalsRepository.getReferendumVote(proposal.id, account);
        if (result.isValue) {
          voteModel = result.asValue!.value as VoteModel;
          if (voteModel.isVoted) {
            await cacheRepository.saveReferendumVote(proposal.id, voteModel);
          }
        }
      }
    } else {
      voteModel = await cacheRepository.getProposalVote(account, proposal.id);
      if (voteModel == null) {
        result = await _proposalsRepository.getProposalVote(proposal.id, account);
        if (result.isValue) {
          voteModel = result.asValue!.value as VoteModel;
          if (voteModel.isVoted) {
            await cacheRepository.saveProposalVote(proposal.id, voteModel);
          }
        }
      }
    }
    return result;
  }

  Future<Result> _getVoiceCall({required ProposalCategory proposalCategory, required String userAccount}) {
    if (proposalCategory == ProposalCategory.campaign) {
      return _voiceRepository.getCampaignVoice(userAccount);
    } else if (proposalCategory == ProposalCategory.milestone) {
      return _voiceRepository.getMilestoneVoice(userAccount);
    } else if (proposalCategory == ProposalCategory.alliance) {
      return _voiceRepository.getAllianceVoice(userAccount);
    } else {
      return _voiceRepository.getReferendumVoice(userAccount);
    }
  }
}
