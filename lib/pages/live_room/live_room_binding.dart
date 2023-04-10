import 'package:alita/model/ui/app_live_room_model.dart';
import 'package:get/get.dart';
import 'live_room_controller.dart';

class LiveRoomBinding extends Bindings {
  @override
  void dependencies() {
    final argument = Get.arguments;
    assert(argument is AppLiveRoomModel, 'Unexpected argument was given');
    Get.lazyPut(() => LiveRoomController(live: argument));
  }
}
