import 'package:alita/pages/anchor_center/anchor_center_controller.dart';
import 'package:get/get.dart';

class AnchorCenterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AnchorCenterController());
  }
}
