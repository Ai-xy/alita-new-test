import 'package:json2dart_safe/json2dart.dart';

class UserProfileModel {
  int? age;
  AnchorIncomeMap? anchorIncomeMap;
  String? birthday;
  bool? canGetDiamond;
  String? countryId;
  int? diamondNum;
  int? disturbStatus;
  int? fansNum;
  int? friendNum;
  int? gender;
  String? icon;
  String? imToken;
  bool? isFirstCharge;
  int? level;
  bool? isNew;
  String? nickname;
  bool? onReview;
  String? storeUrl;
  String? token;
  int? upsNum;
  int? userId;
  String? userTagType;
  int? userType;
  int? valid;
  int? videoPrice;
  String? vip;
  int? vipExpireMs;
  String? yxAccid;
  String? signature;

  List<UserMediaModel>? mediaList;

  List<UserMediaModel> get pics {
    if (mediaList == null || mediaList?.isNotEmpty != true) return [];
    return mediaList!.where((e) => e.type == UserMediaType.photo).toList();
  }

  UserProfileModel({
    this.age,
    this.anchorIncomeMap,
    this.birthday,
    this.canGetDiamond,
    this.countryId,
    this.diamondNum,
    this.disturbStatus,
    this.fansNum,
    this.friendNum,
    this.gender,
    this.icon,
    this.imToken,
    this.isFirstCharge,
    this.level,
    this.isNew,
    this.nickname,
    this.onReview,
    this.storeUrl,
    this.token,
    this.upsNum,
    this.userId,
    this.userTagType,
    this.userType,
    this.valid,
    this.videoPrice,
    this.vip,
    this.vipExpireMs,
    this.yxAccid,
    this.signature,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{}
      ..put('age', age)
      ..put('anchorIncomeMap', anchorIncomeMap?.toJson())
      ..put('birthday', birthday)
      ..put('canGetDiamond', canGetDiamond)
      ..put('countryId', countryId)
      ..put('diamondNum', diamondNum)
      ..put('disturbStatus', disturbStatus)
      ..put('fansNum', fansNum)
      ..put('friendNum', friendNum)
      ..put('gender', gender)
      ..put('icon', icon)
      ..put('imToken', imToken)
      ..put('isFirstCharge', isFirstCharge)
      ..put('level', level)
      ..put('new', isNew)
      ..put('nickname', nickname)
      ..put('onReview', onReview)
      ..put('storeUrl', storeUrl)
      ..put('token', token)
      ..put('upsNum', upsNum)
      ..put('userId', userId)
      ..put('userTagType', userTagType)
      ..put('userType', userType)
      ..put('valid', valid)
      ..put('videoPrice', videoPrice)
      ..put('vip', vip)
      ..put('vipExpireMs', vipExpireMs)
      ..put('yxAccid', yxAccid)
      ..put('signature', signature);
  }

  UserProfileModel.fromJson(Map json) {
    age = json.asInt('age');
    anchorIncomeMap =
        json.asBean('anchorIncomeMap', (v) => AnchorIncomeMap.fromJson(v));
    birthday = json.asString('birthday');
    canGetDiamond = json.asBool('canGetDiamond');
    countryId = json.asString('countryId');
    diamondNum = json.asInt('diamondNum');
    disturbStatus = json.asInt('disturbStatus');
    fansNum = json.asInt('fansNum');
    friendNum = json.asInt('friendNum');
    gender = json.asInt('gender');
    icon = json.asString('icon');
    imToken = json.asString('imToken');
    isFirstCharge = json.asBool('isFirstCharge');
    level = json.asInt('level');
    isNew = json.asBool('new');
    nickname = json.asString('nickname');
    onReview = json.asBool('onReview');
    storeUrl = json.asString('storeUrl');
    token = json.asString('token');
    upsNum = json.asInt('upsNum');
    userId = json.asInt('userId');
    userTagType = json.asString('userTagType');
    userType = json.asInt('userType');
    valid = json.asInt('valid');
    videoPrice = json.asInt('videoPrice');
    vip = json.asString('vip');
    vipExpireMs = json.asInt('vipExpireMs');
    yxAccid = json.asString('yxAccid');
    mediaList = json.asList<UserMediaModel>(
        'picList', (v) => UserMediaModel.fromJson(v));
    signature = json.asString('signature');
  }

  static UserProfileModel toBean(Map<String, dynamic> json) =>
      UserProfileModel.fromJson(json);
}

class AnchorIncomeMap {
  String? income;
  String? paid;
  String? unpaid;

  AnchorIncomeMap({
    this.income,
    this.paid,
    this.unpaid,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{}
      ..put('income', income)
      ..put('paid', paid)
      ..put('unpaid', unpaid);
  }

  AnchorIncomeMap.fromJson(Map json) {
    income = json.asString('income');
    paid = json.asString('paid');
    unpaid = json.asString('unpaid');
  }
}

enum UserMediaType {
  photo(code: 1),
  video(code: 2);

  final int code;

  const UserMediaType({required this.code});
}

UserMediaType getUserMediaType(int code) {
  for (UserMediaType type in UserMediaType.values) {
    if (code == type.code) {
      return type;
    }
  }
  return UserMediaType.photo;
}

class UserMediaModel {
  int? id;
  String? url;
  String? cover;
  UserMediaType? type;
  bool? isLocked;
  bool? isPremium;
  bool? isValid;

  UserMediaModel.fromJson(Map json) {
    id = json['id'];
    url = json['mediaUrl'];
    cover = json['videoCover'];
    type = getUserMediaType(json['mediaType']);
    isLocked = json['unlockStatus'] == 0;
    isPremium = json['chargeFlag'] == 1;
    isValid = json['vaild'] == 1;
  }
}
