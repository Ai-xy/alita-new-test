import 'package:alita/api/user_api.dart';
import 'package:alita/base/base_app_future_controller.dart';
import 'package:alita/model/api/user_friend_entity.dart';

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
}
