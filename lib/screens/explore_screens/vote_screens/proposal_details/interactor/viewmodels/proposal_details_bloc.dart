import 'package:async/async.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposal_details/interactor/mappers/vote_proposal_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposal_details/interactor/usecases/vote_proposal_use_case.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposal_details/interactor/viewmodels/bloc.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposal_details/interactor/viewmodels/page_commands.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/viewmodels/proposals_args_data.dart';

import '../mappers/next_proposal_data_state_mapper.dart';
import '../mappers/proposal_data_state_mapper.dart';
import '../usecases/get_proposal_data_use_case.dart';

/// --- BLOC
class ProposalDetailsBloc extends Bloc<ProposalDetailsEvent, ProposalDetailsState> {
  ProposalDetailsBloc(ProposalsArgsData proposalsArgsData) : super(ProposalDetailsState.initial(proposalsArgsData));

  @override
  Stream<ProposalDetailsState> mapEventToState(ProposalDetailsEvent event) async* {
    if (event is OnLoadProposalData) {
      yield state.copyWith(pageState: PageState.loading);
      final List<Result> results = await GetProposalDataUseCase().run(state.proposals[state.currentIndex]);
      yield ProposalDataStateMapper().mapResultsToState(state, results);
    }
    if (event is OnNextProposalTapped) {
      yield state.copyWith(pageState: PageState.loading);
      final List<Result> results = await GetProposalDataUseCase().run(state.proposals[state.currentIndex + 1]);
      yield NextProposalDataStateMapper().mapResultsToState(state, results);
    }
    if (event is OnVoteAmountChanged) {
      yield state.copyWith(voteAmount: event.voteAmount);
    }
    if (event is OnVoteButtonPressed) {
      yield state.copyWith(pageCommand: ShowConfimVote());
    }
    if (event is OnConfirmVoteButtonPressed) {
      yield state.copyWith(pageState: PageState.loading);
      final Result result = await VoteProposalUseCase().run(
        proposal: state.proposals[state.currentIndex],
        amount: state.voteAmount,
      );
      yield VoteProposalStateMapper().mapResultsToState(state, result);
    }
  }
}
