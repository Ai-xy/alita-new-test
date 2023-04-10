import 'package:alita/pages/live_data/live_data_controller.dart';
import 'package:get/get.dart';

class LiveDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LiveDataController());
  }
}
