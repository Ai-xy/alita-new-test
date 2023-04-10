import 'package:json2dart_safe/json2dart.dart';

class CountryListModel {
  List<CountryModel>? countryList;
  CountryListModel.fromList(List list) {
    countryList = list.map((e) => CountryModel.fromJson(e)).toList();
  }
}

class CountryModel {
  int? code;
  String? emoji;
  String? en;
  double? lat;
  double? lng;
  String? locale;

  CountryModel({
    this.code,
    this.emoji,
    this.en,
    this.lat,
    this.lng,
    this.locale,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{}
      ..put('code', code)
      ..put('emoji', emoji)
      ..put('en', en)
      ..put('lat', lat)
      ..put('lng', lng)
      ..put('locale', locale);
  }

  CountryModel.fromJson(Map json) {
    code = json.asInt('code');
    emoji = json.asString('emoji');
    en = json.asString('en');
    lat = json.asDouble('lat');
    lng = json.asDouble('lng');
    locale = json.asString('locale');
  }

  static CountryModel toBean(Map<String, dynamic> json) =>
      CountryModel.fromJson(json);
}
