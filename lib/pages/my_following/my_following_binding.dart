import 'package:alita/pages/my_following/my_following_controller.dart';
import 'package:get/get.dart';

class MyFollowingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyFollowingController());
  }
}
