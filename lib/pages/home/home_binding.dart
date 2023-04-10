import 'package:alita/pages/follow/follow_controller.dart';
import 'package:alita/pages/home/country_service.dart';
import 'package:alita/pages/home/home_controller.dart';
import 'package:alita/pages/hot_live/hot_live_controller.dart';
import 'package:alita/pages/live_list/live_list_controller.dart';
import 'package:alita/pages/user_profile/user_profile_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => LiveListController());
    Get.lazyPut(() => HotLiveController());
    Get.lazyPut(() => FollowController());
    Get.lazyPut(() => UserProfileController());
    Get.put(CountryService());
  }
}
