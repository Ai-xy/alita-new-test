import 'package:alita/pages/follow/create_moments/create_moments_controller.dart';
import 'package:get/get.dart';

class CreateMomentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateMomentsController());
  }
}
