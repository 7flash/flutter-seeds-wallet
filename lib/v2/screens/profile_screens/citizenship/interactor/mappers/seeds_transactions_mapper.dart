import 'package:seeds/v2/datasource/remote/model/seeds_history_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/citizenship/interactor/viewmodels/citizenship_state.dart';

class SeedsTransactionsMapper extends StateMapper {
  CitizenshipState mapResultToState(CitizenshipState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error seeds transaction history");
    } else {
      final SeedsHistoryModel seedsHistoryModel = result.asValue!.value;

      return currentState.copyWith(
        pageState: PageState.success,
        seedsTransactionsCount: seedsHistoryModel.totalNumberOfTransactions,
      );
    }
  }
}
