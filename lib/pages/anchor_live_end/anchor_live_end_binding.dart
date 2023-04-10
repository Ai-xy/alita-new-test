import 'package:alita/model/api/live_room_model.dart';
import 'package:get/get.dart';

import 'anchor_live_end_controller.dart';

class AnchorLiveEndBinding extends Bindings {
  @override
  void dependencies() {
    final argument = Get.arguments;
    assert(argument is LiveRoomModel, 'Unexpected argument was given');
    Get.lazyPut(() => AnchorLiveEndController(liveRoom: argument));
  }
}
