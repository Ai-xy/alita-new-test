import 'package:alita/generated/json/base/json_field.dart';
import 'package:alita/generated/json/user_friend_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class UserFriendEntity {
  int? age;
  String? birthday;
  String? countryId;
  bool? followed;
  int? gender;
  String? icon;
  String? isOpenNotify;
  int? level;
  String? nickname;
  int? status;
  int? userId;
  int? userType;
  int? videoPrice;
  String? vip;
  String? yxAccid;

  UserFriendEntity();

  factory UserFriendEntity.fromJson(Map<String, dynamic> json) =>
      $UserFriendEntityFromJson(json);

  Map<String, dynamic> toJson() => $UserFriendEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
