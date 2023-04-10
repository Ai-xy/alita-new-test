import 'package:alita/pages/start_live/start_live_controller.dart';
import 'package:get/instance_manager.dart';

class StartLiveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StartLiveController());
  }
}
