import 'package:alita/api/user_api.dart';
import 'package:alita/base/base_app_controller.dart';
import 'package:alita/http/http.dart';
import 'package:alita/model/api/live_room_model.dart';
import 'package:alita/model/api/user_profile_model.dart';
import 'package:alita/util/log.dart';
import 'package:alita/util/toast.dart';
import 'package:nim_core/nim_core.dart';

class LiveAnchorSheetController extends BaseAppController {
  String? yxId;
  int? usId;
  bool isFollowed = false;
  bool isMe = false;
  LiveRoomModel? liveRoom;
  LiveAnchorSheetController({this.yxId, this.usId, this.liveRoom});
  UserProfileModel? liveRoomUser;
  static ChatroomService? chatroomService;

  Future loadData() {
    Log.d('loadData');
    chatroomService ??= NimCore.instance.chatroomService;
    return UserApi.getUserDetail(userId: usId)
        .then((value) {
          liveRoomUser = UserProfileModel.fromJson(value.data);
          liveRoomUser?.fansNum = value.data['userFriendMap']['fansNum'];
          liveRoomUser?.friendNum = value.data['userFriendMap']['friendNum'];
          liveRoomUser?.upsNum = value.data['userFriendMap']['upsNum'];

          if (value.data['followed'] == true) {
            isFollowed = true;
          }
          Log.d('获取到的用户信息：${value.data}');
          Log.d('id信息：$userId ${liveRoom?.homeownerId}');
          Log.d('${isMe}', tag: '是不是自己');
          if (userId == usId.toString()) {
            Log.d('点击了自己的弹窗');
            isMe = true;
          } else {
            isMe = false;
          }

          return value;
        })
        .catchError((err, s) {})
        .whenComplete(update);
  }

  //获取用户信息
  getUserInfo(int? value, LiveRoomModel? liveRoom) {
    this.liveRoom = liveRoom;
    usId = value;
    getMyUserInfo();
  }

  getMyUserInfo() {
    Log.d('getMyUserInfo', tag: 'getMyUserInfo');
    UserApi.getMyLiveRoom().then((value) {
      LiveRoomModel liveRoomInfo = LiveRoomModel();
      liveRoomInfo = value;
      liveRoom?.id = liveRoomInfo.id;
    });
  }

  // 关注
  Future follow() {
    return UserApi.followUser(userId: liveRoomUser?.userId ?? -1).then((value) {
      if (value == true) {
        isFollowed = true;
        update();
      }
    }).then((value) {
      loadData();
    });
  }

  Future unfollow() {
    return UserApi.unfollowUser(userId: liveRoomUser?.userId ?? -1)
        .then((value) {
      if (value == true) {
        update();
        isFollowed = false;
      }
    }).then((value) {
      loadData();
    });
  }

  /// 踢出用户
  Future kickOutAnchor() async {
    chatroomService
        ?.kickChatroomMember(
      NIMChatroomMemberOptions(
        roomId: '${liveRoom?.yxRoomId}',
        account: '${liveRoomUser?.yxAccid}',
      ),
    )
        .then((value) {
      if (value.isSuccess) {
        AppToast.alert(message: 'Kick out success!');
      } else {
        AppToast.alert(message: 'Kick out failed!');
      }
      Log.d(
          'ChatroomService##kickChatroomMember:  ${value.code} ${value.errorDetails}',
          tag: '踢出用户');
    });
  }

  /// 禁言用戶
  Future muteAnchor() async {
    chatroomService
        ?.markChatroomMemberMuted(
      isAdd: true,
      options: NIMChatroomMemberOptions(
        roomId: '${liveRoom?.yxRoomId}',
        account: '${liveRoomUser?.yxAccid}',
      ),
    )
        .then((value) {
      if (value.isSuccess) {
        AppToast.alert(message: 'muteAnchor success!');
      } else {
        AppToast.alert(message: 'muteAnchor failed!');
      }
      Log.d(
          'ChatroomService##markChatroomMemberMuted:  ${value.code} ${value.errorDetails}');
    });
  }

  /// 临时禁言用戶
  Future muteAnchorTemp() async {
    chatroomService
        ?.markChatroomMemberTempMuted(
      duration: 20 * 1000,
      options: NIMChatroomMemberOptions(
        roomId: '${liveRoom?.yxRoomId}',
        account: '${liveRoomUser?.yxAccid}',
      ),
      needNotify: true,
    )
        .then((value) {
      if (value.isSuccess) {
        AppToast.alert(message: 'muteAnchorTemp success!');
      } else {
        AppToast.alert(message: 'muteAnchorTemp failed!');
      }
      print(
          'ChatroomService##markChatroomMemberTempMuted:  ${value.code} ${value.errorDetails}');
    });
  }

  /// 拉黑聊天室用户
  /// true,拉黑
  /// false,解除拉黑
  Future blockUser(bool isBlock) async {
    await chatroomService
        ?.markChatroomMemberInBlackList(
            options: NIMChatroomMemberOptions(
                roomId: '${liveRoom?.yxRoomId}',
                account: '${liveRoomUser?.yxAccid}',
                notifyExtension: {
                  'icon': liveRoomUser?.icon,
                  'nickName': liveRoomUser?.nickname,
                  'userId': liveRoomUser?.userId
                }),
            isAdd: isBlock)
        .then((value) {
      if (value.isSuccess) {
        AppToast.alert(message: 'Blockade successful');
      } else {
        AppToast.alert(message: 'Blocking failed');
      }
    });
  }

  // 举报用户
  Future reportAuthor() async {
    UserApi.reportAuthor(liveRoomUser!.userId!)
        .then((value) => null)
        .whenComplete(update);
  }
}
