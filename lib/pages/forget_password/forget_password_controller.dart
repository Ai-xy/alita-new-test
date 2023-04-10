import 'package:alita/api/login_api.dart';
import 'package:alita/base/base_app_controller.dart';
import 'package:alita/kit/app_validate_kit.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/util/toast.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends BaseAppController {
  String email = '';
  String password = '';
  String rePassword = '';

  void setEmail(String text) {
    email = text;
    update();
  }

  void setPassword(String text) {
    password = text;
    update();
  }

  void setRePassword(String text) {
    rePassword = text;
    update();
  }

  Future resetPassword() {
    if (isEmpty(email)) {
      return Future.error(
          AppToast.alert(message: AppMessage.enterEmailHint.tr));
    }
    if (isEmpty(password)) {
      return Future.error(
          AppToast.alert(message: AppMessage.enterPasswordHint.tr));
    }
    if (isEmpty(rePassword)) {
      return Future.error(
          AppToast.alert(message: AppMessage.enterPasswordAgainHint.tr));
    }
    return LoginApi.resetPassword(email: email, password: password)
        .then((value) {
      Get.back();
    });
  }
}
