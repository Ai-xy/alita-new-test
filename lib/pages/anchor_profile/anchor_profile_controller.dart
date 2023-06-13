import 'package:alita/api/moment_api.dart';
import 'package:alita/api/user_api.dart';
import 'package:alita/base/base_app_controller.dart';
import 'package:alita/model/api/moment_model.dart';
import 'package:alita/model/api/user_profile_model.dart';
import 'package:alita/util/log.dart';

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
    return UserApi.followUser(userId: userInfo?.userId ?? -1);
  }
}
