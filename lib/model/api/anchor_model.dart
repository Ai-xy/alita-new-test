import 'package:json2dart_safe/json2dart.dart';

class AnchorListModel {
  List<AnchorModel>? anchorList;
  AnchorListModel.fromList(dynamic list) {
    if (list is! List) return;
    anchorList = list.map((e) => AnchorModel.fromJson(e)).toList();
  }
}

class AnchorModel {
  int? age;
  String? birthday;
  String? callVideoUrl;
  int? canCall;
  String? connRate;
  String? countryId;
  int? disturbStatus;
  bool? followed;
  int? free;
  int? gender;
  String? icon;
  String? imToken;
  int? levelId;
  String? nickname;
  int? status;
  int? totalNum;
  int? totalSum;
  int? userId;
  int? userLevel;
  int? userType;
  int? videoPrice;
  String? vip;
  String? yxAccid;

  AnchorModel({
    this.age,
    this.birthday,
    this.callVideoUrl,
    this.canCall,
    this.connRate,
    this.countryId,
    this.disturbStatus,
    this.followed,
    this.free,
    this.gender,
    this.icon,
    this.imToken,
    this.levelId,
    this.nickname,
    this.status,
    this.totalNum,
    this.totalSum,
    this.userId,
    this.userLevel,
    this.userType,
    this.videoPrice,
    this.vip,
    this.yxAccid,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{}
      ..put('age', age)
      ..put('birthday', birthday)
      ..put('callVideoUrl', callVideoUrl)
      ..put('canCall', canCall)
      ..put('connRate', connRate)
      ..put('countryId', countryId)
      ..put('disturbStatus', disturbStatus)
      ..put('followed', followed)
      ..put('free', free)
      ..put('gender', gender)
      ..put('icon', icon)
      ..put('imToken', imToken)
      ..put('levelId', levelId)
      ..put('nickname', nickname)
      ..put('status', status)
      ..put('totalNum', totalNum)
      ..put('totalSum', totalSum)
      ..put('userId', userId)
      ..put('userLevel', userLevel)
      ..put('userType', userType)
      ..put('videoPrice', videoPrice)
      ..put('vip', vip)
      ..put('yxAccid', yxAccid);
  }

  AnchorModel.fromJson(Map<String, dynamic> json) {
    age = json.asInt('age');
    birthday = json.asString('birthday');
    callVideoUrl = json.asString('callVideoUrl');
    canCall = json.asInt('canCall');
    connRate = json.asString('connRate');
    countryId = json.asString('countryId');
    disturbStatus = json.asInt('disturbStatus');
    followed = json.asBool('followed');
    free = json.asInt('free');
    gender = json.asInt('gender');
    icon = json.asString('icon');
    imToken = json.asString('imToken');
    levelId = json.asInt('levelId');
    nickname = json.asString('nickname');
    status = json.asInt('status');
    totalNum = json.asInt('totalNum');
    totalSum = json.asInt('totalSum');
    userId = json.asInt('userId');
    userLevel = json.asInt('userLevel');
    userType = json.asInt('userType');
    videoPrice = json.asInt('videoPrice');
    vip = json.asString('vip');
    yxAccid = json.asString('yxAccid');
  }

  static AnchorModel toBean(Map<String, dynamic> json) =>
      AnchorModel.fromJson(json);
}
