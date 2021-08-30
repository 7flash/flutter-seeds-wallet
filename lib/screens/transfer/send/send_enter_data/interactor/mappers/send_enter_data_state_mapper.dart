import 'package:seeds/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/datasource/local/models/fiat_data_model.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/balance_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/transfer/send/send_enter_data/interactor/viewmodels/send_enter_data_state.dart';
import 'package:seeds/utils/rate_states_extensions.dart';

class SendEnterDataStateMapper extends StateMapper {
  SendEnterDataPageState mapResultToState(
      SendEnterDataPageState currentState, Result result, RatesState rateState, String quantity) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error loading current balance");
    } else {
      final BalanceModel balance = result.asValue!.value as BalanceModel;
      final double parsedQuantity = double.parse(quantity);

      final selectedFiat = settingsStorage.selectedFiatCurrency;
      final fiatAmount = rateState.seedsToFiat(parsedQuantity, selectedFiat);
      final availableBalanceFiat = rateState.fromSeedsToFiat(balance.quantity, selectedFiat);

      return currentState.copyWith(
        pageState: PageState.success,
        fiatAmount: fiatAmount,
        availableBalance: TokenDataModel(balance.quantity, token: settingsStorage.selectedToken),
        availableBalanceFiat: FiatDataModel(availableBalanceFiat),
      );
    }
  }
}
