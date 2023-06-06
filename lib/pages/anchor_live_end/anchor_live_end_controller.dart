import 'package:alita/api/user_api.dart';
import 'package:alita/base/base_app_controller.dart';
import 'package:alita/model/api/live_room_model.dart';
import 'package:alita/util/log.dart';

class AnchorLiveEndController extends BaseAppController {
  final LiveRoomModel liveRoom;

  bool isFollowed = false;
  AnchorLiveEndController({required this.liveRoom});

  @override
  void onInit() {
    super.onInit();
    getUserDetail();
    Log.d('${liveRoom.toJson()}');
  }

  Future getUserDetail() {
    return UserApi.getUserDetail(userId: liveRoom.homeownerId)
        .then((value) {
          if (value.data['followed'] == true) {
            isFollowed = true;
            update();
          }
          return value;
        })
        .catchError((err, s) {})
        .whenComplete(update);
  }

  Future follow() {
    return UserApi.followUser(userId: liveRoom.homeownerId ?? -1);
  }
}
