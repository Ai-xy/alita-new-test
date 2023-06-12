import 'package:alita/api/user_api.dart';
import 'package:alita/base/base_app_controller.dart';
import 'package:alita/local_storage/app_local_storge.dart';
import 'package:alita/manager/auth_manager.dart';
import 'package:alita/pages/follow/follow_controller.dart';
import 'package:alita/pages/home/home_controller.dart';
import 'package:alita/pages/hot_live/hot_live_controller.dart';
import 'package:alita/pages/live_list/live_list_controller.dart';
import 'package:alita/pages/session_list/session_list_controller.dart';
import 'package:alita/pages/user_profile/user_profile_controller.dart';
import 'package:alita/router/app_path.dart';
import 'package:get/get.dart';

class AboutUsController extends BaseAppController {
  Future logOut() {
    return Future.wait([
      AppLocalStorage.remove(AppStorageKey.token),
      AppLocalStorage.remove(AppStorageKey.user),
      AppLocalStorage.remove(AppStorageKey.user)
    ]).then((value) {
      AuthManager().logout();
      Get.offAllNamed(AppPath.login);
    });
  }

  Future deleteAccount() {
    AuthManager().logout();
    return UserApi.deleteAccount();
  }
}
