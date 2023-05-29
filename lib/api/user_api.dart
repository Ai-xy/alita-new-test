import 'package:alita/enum/app_gender.dart';
import 'package:alita/generated/json/base/json_convert_content.dart';
import 'package:alita/http/http.dart';
import 'package:alita/model/api/user_friend_entity.dart';
import 'package:alita/model/api/user_profile_model.dart';

abstract class UserApi {
  static Future<UserProfileModel> getUserInfo() {
    return Http.instance
        .post(ApiRequest('/api/user/getUserInfo'))
        .then((value) {
      return UserProfileModel.fromJson(value.data);
    });
  }

  // 查询用户信息
  static Future<UserProfileModel> getUserDetail({int? userId, String? yxId}) {
    return Http.instance
        .post(ApiRequest('/api/index/getUserDetail',
            formData: {"userId": userId, "yxAccid": yxId}))
        .then((value) {
      return UserProfileModel.fromJson(value.data);
    });
  }

  static Future updateUserInfo({
    String? birthday,
    String? country,
    AppGender? gender,
    String? avatar,
    String? inviteCode,
    String? nickname,
    String? signature,
    List<String>? addGreetList,
    int? bodyWeight,
    String? callVideoUrl,
    List<String>? delGreetList,
    String? description,
    int? height,
    List<String>? pics,
    List<int>? deletedPictureList,
  }) {
    return Http.instance.post(ApiRequest('/api/user/updateUserInfo', formData: {
      if (birthday != null) 'birthday': birthday,
      if (country != null) 'countryId': country,
      if (gender != null) 'gender': gender.code,
      if (avatar != null) 'icon': avatar,
      if (inviteCode != null) 'inviteCode': inviteCode,
      if (nickname != null) 'nickname': nickname,
      if (signature != null) 'signature': signature,
      if (addGreetList != null) 'addGreetList': addGreetList,
      if (bodyWeight != null) 'bodyWeight': bodyWeight,
      if (callVideoUrl != null) 'callVideoUrl': callVideoUrl,
      if (delGreetList != null) 'delGreetList': delGreetList,
      if (description != null) 'description': description,
      if (height != null) 'height': height,
      if (pics != null) 'pics': pics,
      if (delGreetList != null) "picsDel": delGreetList,
    }));
  }

  static Future getMyLiveRoom() {
    return Http.instance.post(ApiRequest('/api/expand/wearLive/queryLiveRoom'));
  }

  static Future saveUserInfo({
    required String birthday,
    String country = 'CA',
    AppGender? gender,
    String? avatar,
    required String nickname,
  }) {
    return Http.instance.post(ApiRequest('/api/user/saveUserInfo', formData: {
      'nickname': nickname,
      'countryId': country,
      'gender': gender?.code,
      'birthday': birthday,
      'icon': avatar
    }));
  }

  static Future feedback({
    required String email,
    required String suggestion,
    required String feedbackType,
    required List<String> imageList,
  }) {
    return Http.instance
        .post(ApiRequest('/api/feedback/save', formData: {
      'email': email,
      'suggestion': suggestion,
      'feedbackType': 'AD',
      'pics': imageList
    }))
        .then((value) {
      return UserProfileModel.fromJson(value.data);
    });
  }

  static Future followUser({required int userId}) {
    return Http.instance.post(ApiRequest('/api/user/followUser', formData: {
      'followType': 1,
      'followUserId': userId,
    }));
  }

  static Future unfollowUser({required int userId}) {
    return Http.instance.post(ApiRequest('/api/user/followUser', formData: {
      'followUserId': userId,
      'followType': 2,
    }));
  }

  static Future blockUser({required int userId}) {
    return Http.instance.post(ApiRequest('/api/user/followUser', formData: {
      'followUserId': userId,
      'followType': 3,
    }));
  }

  static Future<List<UserFriendEntity>?> getUserFriend({required int type}) {
    return Http.instance
        .post(ApiRequest('/api/user/userFriend', formData: {
      'currentPage': 1,
      'pageSize': 20,
      'type': type,
    }))
        .then((value) {
      return JsonConvert.fromJsonAsT<List<UserFriendEntity>>(value.data);
    });
  }

  static Future rechargeList() {
    return Http.instance.post(ApiRequest('/api/wallet/rechargeListV2'));
  }

  static Future rechargePay({
    String? password,
    String? payload,
    String? transactionId,
    String? type,
  }) {
    return Http.instance.post(ApiRequest('/api/ios/v2/pay', formData: {
      if (password != null) 'password': password,
      if (payload != null) 'payload': payload,
      if (transactionId != null) 'transactionId': transactionId,
      if (type != null) 'type': type,
    }));
  }
}
