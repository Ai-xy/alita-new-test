import 'package:json2dart_safe/json2dart.dart';

class GiftListModel {
  List<GiftModel> giftList = [];
  GiftListModel.fromList(dynamic list) {
    if (list is! List) return;
    giftList = list.map((e) => GiftModel.fromJson(e)).toList();
  }
}

class GiftModel {
  int? id;
  String? name;
  int? giftPrice;
  String? giftSmallImg;
  String? giftImg;
  int? vaild;

  GiftModel({
    this.id,
    this.name,
    this.giftPrice,
    this.giftSmallImg,
    this.giftImg,
    this.vaild,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{}
      ..put('id', id)
      ..put('name', name)
      ..put('giftPrice', giftPrice)
      ..put('giftSmallImg', giftSmallImg)
      ..put('giftImg', giftImg)
      ..put('vaild', vaild);
  }

  GiftModel.fromJson(Map<String, dynamic> json) {
    id = json.asInt('id');
    name = json.asString('name');
    giftPrice = json.asInt('giftPrice');
    giftSmallImg = json.asString('giftSmallImg');
    giftImg = json.asString('giftImg');
    vaild = json.asInt('vaild');
  }
}
