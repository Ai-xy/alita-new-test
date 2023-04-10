import 'package:alita/pages/block_list/block_list_controller.dart';
import 'package:get/get.dart';

class BlockListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BlockListController());
  }
}
