import 'package:json2dart_safe/json2dart.dart';

class LiveTagListModel {
  List<LiveTagModel>? tagList;
  LiveTagListModel.fromJson(Map json) {
    List list = json['parentTags'] is List ? json['parentTags'] : [];
    tagList = list.map((e) => LiveTagModel.fromJson(e)).toList();
  }
}

class LiveTagModel {
  int? id;
  int? level;
  int? sort;
  String? tagCode;
  String? tagName;
  List<LiveTagModel>? childrenTags;
  LiveTagModel({
    this.id,
    this.level,
    this.sort,
    this.tagCode,
    this.tagName,
    this.childrenTags,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{}
      ..put('id', id)
      ..put('level', level)
      ..put('sort', sort)
      ..put('tagCode', tagCode)
      ..put('tagName', tagName)
      ..put('childrenTags', childrenTags?.map((e) => e.toJson()));
  }

  LiveTagModel.fromJson(Map json) {
    id = json.asInt('id');
    level = json.asInt('level');
    sort = json.asInt('sort');
    tagCode = json.asString('tagCode');
    tagName = json.asString('tagName');
    List list = json['childrenTags'] is List ? json['childrenTags'] : [];
    childrenTags = list.map((e) => LiveTagModel.fromMap(e)).toList();
  }

  LiveTagModel.fromMap(Map json) {
    id = json.asInt('id');
    level = json.asInt('level');
    sort = json.asInt('sort');
    tagCode = json.asString('tagCode');
    tagName = json.asString('tagName');
  }
}
