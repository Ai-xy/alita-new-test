import 'package:alita/api/user_api.dart';
import 'package:alita/base/base_app_controller.dart';
import 'package:alita/model/api/live_room_model.dart';

class AnchorLiveEndController extends BaseAppController {
  final LiveRoomModel liveRoom;

  AnchorLiveEndController({required this.liveRoom});

  Future follow() {
    return UserApi.followUser(userId: liveRoom.homeownerId ?? -1);
  }
}
