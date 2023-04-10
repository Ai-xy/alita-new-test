import 'package:json2dart_safe/json2dart.dart';

class LiveRoomListModel {
  List<LiveRoomModel>? liveRoomList;
  LiveRoomListModel.fromList(List list) {
    liveRoomList = list.map((e) => LiveRoomModel.fromJson(e)).toList();
  }
}

class LiveRoomModel {
  int? id;
  String? liveRoomName;
  String? liveStreamName;
  String? coverImg;
  String? label;
  String? password;
  String? lockFlag;
  String? yxRoomId;
  int? liveState;
  int? homeownerId;
  int? sentiment;
  String? homeownerNickname;
  String? homeownerIcon;
  String? streamUrl;
  bool get isLiving => liveState == 1;
  bool get isPrivate => lockFlag == '1';
  LiveRoomModel({
    this.id,
    this.liveRoomName,
    this.liveStreamName,
    this.coverImg,
    this.label,
    this.password,
    this.lockFlag,
    this.yxRoomId,
    this.liveState,
    this.homeownerId,
    this.sentiment,
    this.homeownerNickname,
    this.homeownerIcon,
    this.streamUrl,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{}
      ..put('id', id)
      ..put('liveRoomName', liveRoomName)
      ..put('liveStreamName', liveStreamName)
      ..put('coverImg', coverImg)
      ..put('label', label)
      ..put('password', password)
      ..put('lockFlag', lockFlag)
      ..put('yxRoomId', yxRoomId)
      ..put('liveState', liveState)
      ..put('homeownerId', homeownerId)
      ..put('sentiment', sentiment)
      ..put('homeownerNickname', homeownerNickname)
      ..put('homeownerIcon', homeownerIcon);
  }

  LiveRoomModel.fromJson(Map<String, dynamic> json) {
    id = json.asInt('id');
    liveRoomName = json.asString('liveRoomName');
    liveStreamName = json.asString('liveStreamName');
    coverImg = json.asString('coverImg');
    label = json.asString('label');
    password = json.asString('password');
    lockFlag = json.asString('lockFlag');
    yxRoomId = json.asString('yxRoomId');
    liveState = json.asInt('liveState');
    homeownerId = json.asInt('homeownerId');
    sentiment = json.asInt('sentiment');
    homeownerNickname = json.asString('homeownerNickname');
    homeownerIcon = json.asString('homeownerIcon');
    streamUrl = json.asString('pushUrl');
  }
}
