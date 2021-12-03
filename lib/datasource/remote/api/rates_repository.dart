import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/network_repository.dart';
import 'package:seeds/datasource/remote/model/fiat_rate_model.dart';
import 'package:seeds/datasource/remote/model/rate_model.dart';

class RatesRepository extends NetworkRepository {
  Future<Result<FiatRateModel>> getFiatRates() {
    print("[http] get fiat rates");

    return http
        .get(Uri.parse("https://api-payment.hypha.earth/fiatExchangeRates?api_key=$fxApiKey"))
        .then((http.Response response) => mapHttpResponse<FiatRateModel>(response, (dynamic body) {
              return FiatRateModel.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<RateModel>> getSeedsRate() async {
    print('[http] get seeds rate USD');

    final request = '{"json":true,"code":"tlosto.seeds","scope":"tlosto.seeds","table":"price"}';

    return http
        .post(Uri.parse('$baseURL/v1/chain/get_table_rows'), headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<RateModel>(response, (dynamic body) {
              return RateModel.fromSeedsJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<RateModel>> getTelosRate() async {
    print('[http] get telos rate USD');

    final params = '''
    {
      "json": true,
      "code": "delphioracle",
      "scope": "tlosusd",
      "table": "datapoints",
      "table_key": "",
      "lower_bound": "",
      "upper_bound": "",
      "limit": 1,
      "key_type": "",
      "index_position": "",
      "encode_type": "dec",
      "reverse": false,
      "show_payer": false
    }
    ''';

    return http
        .post(Uri.parse('$baseURL/v1/chain/get_table_rows'), headers: headers, body: params)
        .then((http.Response response) => mapHttpResponse<RateModel>(response, (dynamic body) {
              return RateModel.fromOracleJson("TLOS", 4, body);
            }))
        .catchError((error) => mapHttpError(error));
  }
}
