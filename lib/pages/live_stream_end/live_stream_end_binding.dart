import 'package:alita/pages/live_stream_end/live_stream_end_controller.dart';
import 'package:get/get.dart';

class LiveStreamEndBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LiveStreamEndController());
  }
}
