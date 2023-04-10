import 'package:alita/api/login_api.dart';
import 'package:alita/base/base_app_controller.dart';
import 'package:alita/kit/app_validate_kit.dart';
import 'package:alita/mixins/app_auth_binding.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/util/toast.dart';
import 'package:get/get.dart';

class RegisterController extends BaseAppController with AppAuthBinding {
  String email = '';
  String password = '';
  String confirmPassword = '';

  void setEmial(String text) {
    email = text;
    update();
  }

  void setPassword(String text) {
    password = text;
    update();
  }

  void setConfirmPassword(String text) {
    confirmPassword = text;
    update();
  }

  Future signUp() {
    if (isEmpty(email)) {
      return Future.error(
          AppToast.alert(message: AppMessage.enterEmailHint.tr));
    }
    if (isEmpty(password)) {
      return Future.error(
          AppToast.alert(message: AppMessage.enterPasswordHint.tr));
    }
    if (isEmpty(confirmPassword)) {
      return Future.error(
          AppToast.alert(message: AppMessage.enterPasswordAgainHint.tr));
    }
    return LoginApi.login(email: email, password: password).then((user) {
      return saveUserInfo(user);
    }).then((value) {
      Get.offAllNamed(AppPath.setProfile);
    });
  }
}
