import 'package:alita/pages/session_list/session_list_controller.dart';
import 'package:get/get.dart';

class SessionListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SessionListController());
  }
}
