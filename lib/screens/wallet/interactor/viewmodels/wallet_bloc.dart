import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/wallet/interactor/mappers/user_account_state_mapper.dart';
import 'package:seeds/screens/wallet/interactor/usecases/get_user_account.dart';

part 'wallet_event.dart';

part 'wallet_state.dart';

/// --- BLOC
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(WalletState.initial()) {
    on<OnLoadWalletData>(_onLoadWalletData);
  }

  Future<void> _onLoadWalletData(OnLoadWalletData event, Emitter<WalletState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final results = await GetUserAccountUseCase().run();
    WalletState newState;
    emit(newState = UserAccountStateMapper().mapResultToState(state, results));
    if (newState.profile.status == ProfileStatus.citizen) {
      // Here is the first time the get user profile is called in the app
      // so we need save here the is citizen status in the settingsStorage
      // to avoid show shimmer again in the citizenship module
      settingsStorage.saveIsCitizen(true);
    }
    if (newState.profile.status == ProfileStatus.visitor) {
      settingsStorage.saveIsVisitor(true);
    }
  }
}
