import 'package:alita/api/user_api.dart';
import 'package:alita/base/base_app_controller.dart';
import 'package:alita/model/api/live_room_model.dart';
import 'package:alita/model/api/user_profile_model.dart';
import 'package:alita/util/log.dart';
import 'package:alita/util/toast.dart';

class AnchorLiveEndController extends BaseAppController {
  final LiveRoomModel liveRoom;

  bool isFollowed = false;
  AnchorLiveEndController({required this.liveRoom});
  UserProfileModel? roomAuthor;

  @override
  void onInit() {
    super.onInit();
    getUserDetail();
    Log.d('${liveRoom.toJson()}', tag: 'liveRoom信息');
  }

  Future getUserDetail() {
    return UserApi.getUserDetail(userId: liveRoom.homeownerId)
        .then((value) {
          roomAuthor = UserProfileModel.fromJson(value.data);
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
    return UserApi.followUser(userId: liveRoom.homeownerId ?? -1).then((value) {
      print('值');
      print(value);
      if (value == true) {
        isFollowed = true;
        update();
      }
    });
  }

  Future unfollow() {
    return UserApi.unfollowUser(userId: liveRoom.homeownerId ?? -1)
        .then((value) {
      print('值');
      print(value);
      if (value == true) {
        update();
        isFollowed = false;
      }
    });
  }
}
