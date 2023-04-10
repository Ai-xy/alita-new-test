import 'package:alita/api/app_api.dart';
import 'package:alita/model/api/country_model.dart';
import 'package:get/get.dart';

class CountryService extends GetxService {
  List<CountryModel> countryList = [];
  @override
  void onInit() {
    AppApi.getCountryList().then((value) {
      countryList = value ?? [];
    });
    super.onInit();
  }

  String getCountryEmojiByName(String name) {
    for (CountryModel item in countryList) {
      if (item.en == name) {
        return '${item.emoji}';
      }
    }
    return '';
  }
}
