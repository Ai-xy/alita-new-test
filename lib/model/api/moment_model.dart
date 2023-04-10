import 'package:json2dart_safe/json2dart.dart';

import 'dynamic_comment_model.dart';

class MomentListModel {
  List<MomentModel>? momentList;
  MomentListModel.fromList(List list) {
    momentList = list.map((e) => MomentModel.fromJson(e)).toList();
  }
}

class MomentModel {
  int? id;
  String? textContent;
  String? nickname;
  String? icon;
  int? userId;
  String? yxAccid;
  int? onlineGroupStatus;
  int? onlineStatus;
  List<String>? imgUrls;
  int? likeFlag;
  int? likeNum;
  int? commentNum;
  int? followFlag;
  DateTime createTime = DateTime.now();

  List<DynamicCommentModel> commentList = [];

  MomentModel({
    this.id,
    this.textContent,
    this.nickname,
    this.icon,
    this.userId,
    this.yxAccid,
    this.onlineGroupStatus,
    this.onlineStatus,
    this.imgUrls,
    this.likeFlag,
    this.likeNum,
    this.followFlag,
    this.commentNum,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{}
      ..put('id', id)
      ..put('textContent', textContent)
      ..put('nickname', nickname)
      ..put('icon', icon)
      ..put('userId', userId)
      ..put('yxAccid', yxAccid)
      ..put('onlineGroupStatus', onlineGroupStatus)
      ..put('onlineStatus', onlineStatus)
      ..put('imgUrls', imgUrls)
      ..put('likeFlag', likeFlag)
      ..put('likeNum', likeNum)
      ..put('followFlag', followFlag)
      ..put('createTime', createTime)
      ..put('commentNum', commentNum);
  }

  MomentModel.fromJson(Map<String, dynamic> json) {
    id = json.asInt('id');
    textContent = json.asString('textContent');
    nickname = json.asString('nickname');
    icon = json.asString('icon');
    userId = json.asInt('userId');
    yxAccid = json.asString('yxAccid');
    onlineGroupStatus = json.asInt('onlineGroupStatus');
    onlineStatus = json.asInt('onlineStatus');
    imgUrls = json.asList<String>('imgUrls', null);
    likeFlag = json.asInt('likeFlag');
    likeNum = json.asInt('likeNum');
    followFlag = json.asInt('followFlag');
    commentNum = json.asInt('commentNum');
    createTime =
        DateTime.tryParse(json.asString('createTime')) ?? DateTime.now();
  }
}
