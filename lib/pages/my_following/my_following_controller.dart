import 'package:alita/api/live_api.dart';
import 'package:alita/api/user_api.dart';
import 'package:alita/base/base_app_future_controller.dart';
import 'package:alita/model/api/live_room_model.dart';
import 'package:alita/model/api/user_friend_entity.dart';
import 'package:alita/model/ui/app_live_room_model.dart';
import 'package:alita/pages/live_list/widgets/live_room_card.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/util/log.dart';
import 'package:get/get.dart';

class MyFollowingController extends BaseAppFutureLoadStateController {
  // List<LiveTagModel> tagList = [];
  // List<LiveRoomModel> liveRoomList = [];
  List<UserFriendEntity> followUserList1 = [];
  List<UserFriendEntity> followUserList2 = [];
  List<UserFriendEntity> followUserList3 = [];

  @override
  Future loadData({Map? params}) {
    UserApi.getUserFriend(
      type: 1,
    ).then((value) {
      followUserList2 = value!;
    }).whenComplete(update);
    UserApi.getUserFriend(
      type: 2,
    ).then((value) {
      followUserList3 = value!;
    }).whenComplete(update);
    return UserApi.getUserFriend(
      type: 3,
    ).then((value) {
      followUserList1 = value!;
    }).whenComplete(update);
  }

  Future follow(int userId) {
    return UserApi.followUser(userId: userId).then((value) {
      loadData();
    });
  }

  Future unFollow(int userId) {
    return UserApi.unfollowUser(userId: userId).then((value) {
      loadData();
    });
  }

  // 进入关注的人的直播间
  Future queryAuthorLiveRoomInfo(int userId) {
    return LiveApi.queryAuthorLiveRoomInfo(userId).then((value) {
      LiveRoomModel model = value;
      if (model.lockFlag == "1") {
        password = model.password;
        Get.dialog(const CustomDialog());
      } else {
        if (model.liveState == 2) {
          Get.toNamed(AppPath.liveRoom,
              arguments: AppLiveRoomModel(liveRoom: model, streamUrl: value),
              preventDuplicates: false);
        } else {
          Get.toNamed(AppPath.anchorLiveEnd,
              preventDuplicates: false, arguments: model);
        }
      }
      return model;
    });
  }
}
