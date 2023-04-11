import 'package:alita/api/user_api.dart';
import 'package:alita/base/base_app_future_controller.dart';
import 'package:alita/model/api/user_friend_entity.dart';

class MyFollowingController extends BaseAppFutureLoadStateController {
  // List<LiveTagModel> tagList = [];
  // List<LiveRoomModel> liveRoomList = [];
  List<UserFriendEntity> followUserList = [];

  @override
  Future loadData({Map? params}) {
    return UserApi.followUser(
      userId: user?.userId ?? 0,
    ).then((value) {
      print(value);
    }).whenComplete(update);
  }
}
