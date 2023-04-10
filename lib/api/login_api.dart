import 'package:alita/config/app_config.dart';
import 'package:alita/http/http.dart';
import 'package:alita/kit/app_md5_kit.dart';
import 'package:alita/model/api/user_profile_model.dart';

abstract class LoginApi {
  static Future<UserProfileModel> login({
    required String email,
    required String password,
  }) {
    return Http.instance
        .post(ApiRequest('/api/login/email', formData: {
      'email': email,
      'password': AppMd5Kit.generateMd5(
          AppMd5Kit.generateMd5(password + AppConfig.env.appId))
    }))
        .then((value) {
      return UserProfileModel.fromJson(value.data);
    });
  }

  static Future resetPassword({
    required String email,
    required String password,
  }) {
    return Http.instance.post(ApiRequest('/api/login/setPassWord', formData: {
      'email': email,
      'password': AppMd5Kit.generateMd5(
          AppMd5Kit.generateMd5(password + AppConfig.env.appId))
    }));
  }
}
