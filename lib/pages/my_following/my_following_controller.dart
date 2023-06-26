import 'package:alita/api/live_api.dart';
import 'package:alita/api/user_api.dart';
import 'package:alita/base/base_app_future_controller.dart';
import 'package:alita/model/api/live_room_model.dart';
import 'package:alita/model/api/user_friend_entity.dart';
import 'package:alita/model/ui/app_live_room_model.dart';
import 'package:alita/pages/live_list/widgets/live_room_card.dart';
import 'package:alita/pages/user_profile/user_profile_controller.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/util/log.dart';
import 'package:alita/util/toast.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';

class MyFollowingController extends BaseAppFutureLoadStateController {
  // List<LiveTagModel> tagList = [];
  // List<LiveRoomModel> liveRoomList = [];
  List<UserFriendEntity> followUserList1 = [];
  List<UserFriendEntity> followUserList2 = [];
  List<UserFriendEntity> followUserList3 = [];

  final UserProfileController _controller = Get.find();
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
    }).then((value) {
      _controller.loadData();
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

  // // 进入关注的人的直播间
  // Future queryAuthorLiveRoomInfo(int userId) {
  //   return LiveApi.queryAuthorLiveRoomInfo(userId).then((value) {
  //     LiveRoomModel model = value;
  //     if (model.lockFlag == "1") {
  //       password = model.password;
  //       Get.dialog(const CustomDialog());
  //     } else {
  //       if (model.liveState == 2) {
  //         Get.toNamed(AppPath.liveRoom,
  //             arguments: AppLiveRoomModel(liveRoom: model, streamUrl: value),
  //             preventDuplicates: false);
  //       } else {
  //         Get.toNamed(AppPath.anchorLiveEnd,
  //             preventDuplicates: false, arguments: model);
  //       }
  //     }
  //     return model;
  //   });
  // }

  // 进入他人的直播间
  Future queryAuthorLiveRoomInfo(int userId) {
    return LiveApi.queryAuthorLiveRoomInfo(userId).then((value) {
      LiveRoomModel model = value;
      CancelFunc cancelFunc = AppToast.loading();
      LiveApi.getLiveStream(id: model.id ?? 0, password: '${model.password}')
          .then((value) {
        mLiveRoom = model;
        mLiveRoom?.streamUrl = value;
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
      }).whenComplete(cancelFunc);
      return model;
    });
  }
}
