import 'package:alita/base/base_app_controller.dart';
import 'package:alita/local_storage/app_local_storge.dart';
import 'package:alita/router/app_path.dart';
import 'package:get/get.dart';

class AboutUsController extends BaseAppController {
  Future logOut() {
    return Future.wait([
      AppLocalStorage.remove(AppStorageKey.token),
      AppLocalStorage.remove(AppStorageKey.user)
    ]).then((value) {
      Get.offAllNamed(AppPath.login);
    });
  }

  Future deleteAccount() {
    return Future.value();
  }
}
