import 'package:alita/model/api/live_room_model.dart';
import 'package:alita/pages/my_live_room/my_live_room_controller.dart';
import 'package:get/get.dart';
import 'package:rtmp_broadcaster/camera.dart';

class MyLiveRoomConfigArgument {
  final CameraController cameraController;
  final LiveRoomModel liveRoom;
  MyLiveRoomConfigArgument({
    required this.cameraController,
    required this.liveRoom,
  });
}

class MyLiveRoomBinding extends Bindings {
  @override
  void dependencies() {
    final argument = Get.arguments;
    assert(
        argument is MyLiveRoomConfigArgument, 'Unexpected argument was given');
    Get.lazyPut(() => MyLiveRoomController(argument: Get.arguments));
  }
}
