import 'package:alita/api/user_api.dart';
import 'package:alita/base/base_app_controller.dart';
import 'package:alita/model/api/live_room_model.dart';
import 'package:alita/model/api/user_profile_model.dart';

class LiveAnchorSheetController extends BaseAppController {
  String? yxId;
  int? usId;
  LiveRoomModel? liveRoom;
  LiveAnchorSheetController({this.yxId, this.usId, this.liveRoom});
  UserProfileModel? liveRoomUser;
  UserProfileModel? me;

  Future<UserProfileModel> loadData() {
    return UserApi.getUserDetail(userId: usId)
        .then((value) {
          liveRoomUser = value;
          print('获取到的用户信息：${liveRoomUser?.toJson()}');
          print('id信息：$userId ${liveRoom?.homeownerId}');
          return value;
        })
        .catchError((err, s) {})
        .whenComplete(update);
  }

  //获取用户信息
  getUserInfo(int? value, LiveRoomModel? liveRoom) {
    me = user;
    this.liveRoom = liveRoom;
    usId = value;
    update();
  }
}
