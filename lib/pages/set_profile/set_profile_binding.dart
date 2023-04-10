import 'package:alita/pages/set_profile/set_profile_controller.dart';
import 'package:get/instance_manager.dart';

class SetProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SetProfileController());
  }
}
