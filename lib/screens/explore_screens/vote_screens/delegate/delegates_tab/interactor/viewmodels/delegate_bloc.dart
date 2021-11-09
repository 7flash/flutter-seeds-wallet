import 'package:bloc/bloc.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/interactor/mapper/delegate_load_data_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/interactor/mapper/remove_delegate_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/interactor/usecase/delegate_load_data_usecase.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/interactor/usecase/remove_delegate_use_case.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/interactor/viewmodels/delegate_event.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/interactor/viewmodels/delegate_page_commands.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/interactor/viewmodels/delegate_state.dart';

class DelegateBloc extends Bloc<DelegateEvent, DelegateState> {
  DelegateBloc() : super(DelegateState.initial());

  @override
  Stream<DelegateState> mapEventToState(DelegateEvent event) async* {
    if (event is LoadDelegateData) {
      yield state.copyWith(pageState: PageState.loading);
      final Result? result = await DelegateLoadDataUseCase().run();
      yield DelegateLoadDataStateMapper().mapResultToState(state, result);
    } else if (event is RemoveDelegateTap) {
      yield state.copyWith(pageCommand: ShowDelegateRemovalConfirmation());
    } else if (event is RemoveDelegate) {
      yield state.copyWith(pageState: PageState.loading);
      final Result result = await RemoveDelegateUseCase().run();
      yield RemoveDelegateResultMapper().mapResultToState(state, result);
    } else if (event is ShowOnboardingDelegate) {
      yield state.copyWith(pageCommand: ShowOnboardingDelegate());
    }
  }
}
