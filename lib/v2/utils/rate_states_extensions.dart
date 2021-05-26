import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';

extension RatesStateExtensions on RatesState {
  double _seedsTo(double seedsValue, String currencySymbol) {
    var usdValue = rate?.toUSD(seedsValue) ?? 0;
    return fiatRate?.usdTo(usdValue, currencySymbol) ?? 0;
  }

  double _toSeeds(double currencyValue, String currencySymbol) {
    if (currencySymbol == "USD") {
      return rate?.toSeeds(currencyValue) ?? 0;
    } else {
      var usdValue = fiatRate?.toUSD(currencyValue, currencySymbol) ?? 0;
      return rate?.toSeeds(usdValue) ?? 0;
    }
  }

  /// Returns a double that represents the amount of seeds in a given fiat currency
  double fromSeedsToFiat(double seedsAmount, String currencySymbol) {
    return _seedsTo(seedsAmount, currencySymbol);
  }

  /// Returns a double representing the amount of given fiat currency in seeds
  double fromFiatToSeeds(double currencyAmount, String currencySymbol) {
    return _toSeeds(currencyAmount, currencySymbol);
  }
}
