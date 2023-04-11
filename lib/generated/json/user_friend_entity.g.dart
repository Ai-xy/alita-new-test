import 'package:alita/generated/json/base/json_convert_content.dart';
import 'package:alita/model/api/user_friend_entity.dart';

UserFriendEntity $UserFriendEntityFromJson(Map<String, dynamic> json) {
	final UserFriendEntity userFriendEntity = UserFriendEntity();
	final int? age = jsonConvert.convert<int>(json['age']);
	if (age != null) {
		userFriendEntity.age = age;
	}
	final String? birthday = jsonConvert.convert<String>(json['birthday']);
	if (birthday != null) {
		userFriendEntity.birthday = birthday;
	}
	final String? countryId = jsonConvert.convert<String>(json['countryId']);
	if (countryId != null) {
		userFriendEntity.countryId = countryId;
	}
	final bool? followed = jsonConvert.convert<bool>(json['followed']);
	if (followed != null) {
		userFriendEntity.followed = followed;
	}
	final int? gender = jsonConvert.convert<int>(json['gender']);
	if (gender != null) {
		userFriendEntity.gender = gender;
	}
	final String? icon = jsonConvert.convert<String>(json['icon']);
	if (icon != null) {
		userFriendEntity.icon = icon;
	}
	final String? isOpenNotify = jsonConvert.convert<String>(json['isOpenNotify']);
	if (isOpenNotify != null) {
		userFriendEntity.isOpenNotify = isOpenNotify;
	}
	final int? level = jsonConvert.convert<int>(json['level']);
	if (level != null) {
		userFriendEntity.level = level;
	}
	final String? nickname = jsonConvert.convert<String>(json['nickname']);
	if (nickname != null) {
		userFriendEntity.nickname = nickname;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		userFriendEntity.status = status;
	}
	final int? userId = jsonConvert.convert<int>(json['userId']);
	if (userId != null) {
		userFriendEntity.userId = userId;
	}
	final int? userType = jsonConvert.convert<int>(json['userType']);
	if (userType != null) {
		userFriendEntity.userType = userType;
	}
	final int? videoPrice = jsonConvert.convert<int>(json['videoPrice']);
	if (videoPrice != null) {
		userFriendEntity.videoPrice = videoPrice;
	}
	final String? vip = jsonConvert.convert<String>(json['vip']);
	if (vip != null) {
		userFriendEntity.vip = vip;
	}
	final String? yxAccid = jsonConvert.convert<String>(json['yxAccid']);
	if (yxAccid != null) {
		userFriendEntity.yxAccid = yxAccid;
	}
	return userFriendEntity;
}

Map<String, dynamic> $UserFriendEntityToJson(UserFriendEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['age'] = entity.age;
	data['birthday'] = entity.birthday;
	data['countryId'] = entity.countryId;
	data['followed'] = entity.followed;
	data['gender'] = entity.gender;
	data['icon'] = entity.icon;
	data['isOpenNotify'] = entity.isOpenNotify;
	data['level'] = entity.level;
	data['nickname'] = entity.nickname;
	data['status'] = entity.status;
	data['userId'] = entity.userId;
	data['userType'] = entity.userType;
	data['videoPrice'] = entity.videoPrice;
	data['vip'] = entity.vip;
	data['yxAccid'] = entity.yxAccid;
	return data;
}