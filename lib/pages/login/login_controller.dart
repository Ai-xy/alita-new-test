// import 'dart:html';

import 'package:alita/api/login_api.dart';
import 'package:alita/base/base_app_controller.dart';
import 'package:alita/kit/app_validate_kit.dart';
import 'package:alita/model/api/user_profile_model.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/util/toast.dart';
import 'package:alita/widgets/app_tabbar.dart';
import 'package:get/get.dart';

class LoginController extends BaseAppController {
  String email = '';
  String password = '';

  void setEmial(String text) {
    email = text;
    update();
  }

  void setPassword(String text) {
    password = text;
    update();
  }

  Future login() {
    if (isEmpty(email)) {
      return Future.error(
          AppToast.alert(message: AppMessage.enterEmailHint.tr));
    }
    if (isEmpty(password)) {
      return Future.error(
          AppToast.alert(message: AppMessage.enterPasswordHint.tr));
    }

    return LoginApi.login(email: email, password: password).then((user) {
      return _afterLogin(user: user);
    });
  }

  Future quickLogin() {
    return Future.value();
  }

  Future _afterLogin({required UserProfileModel user}) {
    return saveUserInfo(user).then((value) {
      return user.valid == 1 ? loginYX() : Get.offAllNamed(AppPath.setProfile);
    }).then((value) async {
      await loginYX();
      return Get.offAllNamed(AppPath.home);
    });
  }
}
