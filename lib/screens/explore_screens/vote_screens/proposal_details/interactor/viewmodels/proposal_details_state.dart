import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/datasource/remote/model/voice_model.dart';
import 'package:seeds/datasource/remote/model/vote_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/viewmodels/proposal_view_model.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/viewmodels/proposals_args_data.dart';

enum VoteStatus { canVote, alreadyVoted, notCitizen }

/// --- STATE
class ProposalDetailsState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;
  final int currentIndex;
  final List<ProposalViewModel> proposals;
  final bool showNextButton;
  final bool isCitizen;
  final int voteAmount;
  final ProfileModel? creator;
  final VoteModel? vote;
  final VoiceModel? tokens;

  const ProposalDetailsState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    required this.currentIndex,
    required this.proposals,
    required this.showNextButton,
    required this.isCitizen,
    required this.voteAmount,
    this.creator,
    this.vote,
    this.tokens,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        errorMessage,
        currentIndex,
        proposals,
        showNextButton,
        isCitizen,
        voteAmount,
        creator,
        vote,
        tokens,
      ];

  VoteStatus get voteStatus {
    if (!isCitizen) {
      return VoteStatus.notCitizen;
    } else if (vote!.isVoted) {
      return VoteStatus.alreadyVoted;
    } else {
      return VoteStatus.canVote;
    }
  }

  bool get shouldShowNexProposalButton {
    final isVoted = vote?.isVoted ?? false;
    final hasMoreItems = currentIndex < proposals.length - 1;
    return showNextButton ||
        isVoted ||
        !isCitizen ||
        (proposals[currentIndex].stage != 'active' || proposals[currentIndex].status != 'active') && hasMoreItems;
  }

  bool get shouldShowVoteModule {
    final isVoted = vote?.isVoted ?? false;
    return !showNextButton &&
        !isVoted &&
        isCitizen &&
        (proposals[currentIndex].stage == 'active' || proposals[currentIndex].status == 'active');
  }

  ProposalDetailsState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
    int? currentIndex,
    List<ProposalViewModel>? proposals,
    bool? showNextButton,
    bool? isCitizen,
    int? voteAmount,
    ProfileModel? creator,
    VoteModel? vote,
    VoiceModel? tokens,
  }) {
    return ProposalDetailsState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
      currentIndex: currentIndex ?? this.currentIndex,
      proposals: proposals ?? this.proposals,
      showNextButton: showNextButton ?? this.showNextButton,
      isCitizen: isCitizen ?? this.isCitizen,
      voteAmount: voteAmount ?? this.voteAmount,
      creator: creator ?? this.creator,
      vote: vote ?? this.vote,
      tokens: tokens ?? this.tokens,
    );
  }

  factory ProposalDetailsState.initial(ProposalsArgsData proposalsArgsData) {
    return ProposalDetailsState(
      pageState: PageState.initial,
      currentIndex: proposalsArgsData.index,
      proposals: proposalsArgsData.proposals,
      showNextButton: false,
      isCitizen: proposalsArgsData.profile.status == ProfileStatus.citizen,
      voteAmount: 0,
    );
  }
}
