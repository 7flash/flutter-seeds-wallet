import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/receive_screens/receive_enter_data/interactor/viewmodels/page_commands.dart';
import 'package:seeds/v2/screens/receive_screens/receive_enter_data/interactor/viewmodels/receive_enter_data_state.dart';

class CreateInvoiceResultMapper extends StateMapper {
  ReceiveEnterDataState mapResultToState(ReceiveEnterDataState currentState, Result result) {
    if (result.isError) {
      print('Error invoice hash not retrieved');
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: ShowTransactionFail(),
      );
    } else {
      return currentState.copyWith(
          pageState: PageState.success, pageCommand: NavigateToReceiveDetails(), invoiceLink: result.asValue!.value);
    }
  }
}
