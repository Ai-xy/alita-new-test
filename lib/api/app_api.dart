import 'package:alita/config/app_config.dart';
import 'package:alita/http/http.dart';
import 'package:alita/model/api/country_model.dart';
import 'package:alita/model/api/oss_credentials_model.dart';

abstract class AppApi {
  static Future getAbcInfo() {
    return Http.instance.post(ApiRequest('/api/index/getAbcInfo', formData: {
      "channel": 'GOOGLE',
      'deviceNo': AppConfig.deviceId,
      'deviceType': '',
      'osType': '',
      'useSimCard': 0,
      'version': AppConfig.appVersion,
    }));
  }

  static Future<OssCredentialsModel> getOssToken() {
    return Http.instance.get(ApiRequest('/sts/getkey')).then((value) {
      return OssCredentialsModel.fromJson(value.data);
    });
  }

  static Future<List<CountryModel>?> getCountryList() {
    return Http.instance
        .post(ApiRequest('/api/index/getCountryList'))
        .then((value) {
      return CountryListModel.fromList(value.data is List ? value.data : []);
    }).then((value) => value.countryList);
  }
}
