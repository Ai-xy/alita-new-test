import 'package:json2dart_safe/json2dart.dart';

class DynamicCommentListModel {
  List<DynamicCommentModel>? commentList;
  DynamicCommentListModel.fromList(List list) {
    commentList = list.map((e) => DynamicCommentModel.fromJson(e)).toList();
  }
}

class DynamicCommentModel {
  String? commentContent;
  String? createTime;
  String? icon;
  int? id;
  String? nickname;
  int? parentCommentId;
  List<DynamicCommentModel>? subComments;
  int? userId;

  DynamicCommentModel({
    this.commentContent,
    this.createTime,
    this.icon,
    this.id,
    this.nickname,
    this.parentCommentId,
    this.subComments,
    this.userId,
  });

  Map toJson() {
    return {}
      ..put('commentContent', commentContent)
      ..put('createTime', createTime)
      ..put('icon', icon)
      ..put('id', id)
      ..put('nickname', nickname)
      ..put('parentCommentId', parentCommentId)
      ..put('subComments', subComments?.map((v) => v.toJson()).toList())
      ..put('userId', userId);
  }

  DynamicCommentModel.fromJson(Map json) {
    commentContent = json.asString('commentContent');
    createTime = json.asString('createTime');
    icon = json.asString('icon');
    id = json.asInt('id');
    nickname = json.asString('nickname');
    parentCommentId = json.asInt('parentCommentId');
    subComments = json.asList<DynamicCommentModel>(
        'subComments', (v) => DynamicCommentModel.fromJson(v));
    userId = json.asInt('userId');
  }

  static DynamicCommentModel toBean(Map<String, dynamic> json) =>
      DynamicCommentModel.fromJson(json);
}
