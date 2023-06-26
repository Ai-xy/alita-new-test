import 'package:alita/api/live_api.dart';
import 'package:alita/api/moment_api.dart';
import 'package:alita/api/user_api.dart';
import 'package:alita/base/base_app_controller.dart';
import 'package:alita/model/api/live_room_model.dart';
import 'package:alita/model/api/moment_model.dart';
import 'package:alita/model/api/user_profile_model.dart';
import 'package:alita/model/ui/app_live_room_model.dart';
import 'package:alita/pages/live_list/widgets/live_room_card.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/util/log.dart';
import 'package:alita/util/toast.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';

class AnchorProfileController extends BaseAppController {
  UserProfileModel? userInfo;
  UserProfileModel? userDetail;
  AnchorProfileController(this.userInfo);
  List<MomentModel> momentList = [];
  bool isMe = false;
  bool isFollowed = false;

  @override
  void onInit() {
    super.onInit();
    Log.i("用户信息${userInfo?.toJson().toString()}");
    loadData().then((value) => loadMomentsData());
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  Future loadMomentsData({Map? params}) {
    momentList = [];
    return isMe
        ? MomentApi.getMyMomentList().then((value) {
            momentList = value ?? [];
            update();
            return value;
          })
        : MomentApi.getMomentList(userId: '${userInfo?.userId}').then((value) {
            momentList = value ?? [];
            update();
            return value;
          });
  }

  Future loadData() {
    return UserApi.getUserDetail(userId: userInfo?.userId)
        .then((value) {
          userDetail = UserProfileModel.fromJson(value.data);
          Log.d('获取到的用户信息：${value.data}');
          userInfo = UserProfileModel.fromJson(value.data);
          if (userInfo?.userId == user?.userId) {
            isMe = true;
          }
          if (value.data['followed'] == true) {
            isFollowed = true;
          }
          return value;
        })
        .catchError((err, s) {})
        .whenComplete(update);
  }

  Future follow() {
    return UserApi.followUser(userId: userInfo?.userId ?? -1).then((value) {
      if (value == true) {
        isFollowed = true;
        update();
      }
    });
  }

  Future unfollow() {
    return UserApi.unfollowUser(userId: userInfo?.userId ?? -1).then((value) {
      if (value == true) {
        update();
        isFollowed = false;
      }
    });
  }

  Future queryAuthorLiveRoomInfo(int userId) {
    return LiveApi.queryAuthorLiveRoomInfo(userId).then((value) {
      if (value != null) {
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
                  arguments:
                      AppLiveRoomModel(liveRoom: model, streamUrl: value),
                  preventDuplicates: false);
            } else {
              AppToast.alert(
                  message: 'The current user is not in the live stream');
            }
          }
        }).whenComplete(cancelFunc);
        return model;
      } else {
        AppToast.alert(message: 'The current user is not in the live stream');
      }
    });
  }
}
