import 'package:get/get.dart';

import 'block_list_user_center_controller.dart';

class UserCenterBlockListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserCenterBlockListController());
  }
}
