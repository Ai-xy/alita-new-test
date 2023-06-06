import 'package:alita/base/base_app_controller.dart';
import 'package:alita/model/api/live_room_model.dart';
import 'package:alita/util/toast.dart';
import 'package:nim_core/nim_core.dart';

class BlockListController extends BaseAppController {
  final LiveRoomModel? liveRoom;
  List<NIMChatroomMember>? blockAnchorList = [];

  BlockListController({this.liveRoom});

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getBlockList();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  /// 获取聊天室黑名单
  getBlockList() {
    blockAnchorList = [];
    NimCore.instance.chatroomService
        .fetchChatroomMembers(
      roomId: '${liveRoom?.yxRoomId}',
      queryType: NIMChatroomMemberQueryType.allNormalMember,
      limit: 50,
    )
        .then((result) {
      var index = 0;
      result.data?.forEach((member) {
        if (member.memberType == NIMChatroomMemberType.restricted) {
          blockAnchorList?.add(member);
        }
        NIMChatroomMember data = member;
        print(data.avatar);
        print(data..extension);

        print(
            'ChatroomService fetchChatroomMembers ##member_${index++}: ${member.account} ${member.nickname} ${member.memberType}');
      });
      update();
    });
  }

  /// 拉黑聊天室用户
  /// true,拉黑
  /// false,解除拉黑
  Future unblockUser(String? userYxId, bool isBlock) async {
    await NimCore.instance.chatroomService
        .markChatroomMemberInBlackList(
            options: NIMChatroomMemberOptions(
                roomId: '${liveRoom?.yxRoomId}', account: '$userYxId'),
            isAdd: isBlock)
        .then((value) {
      if (value.isSuccess) {
        AppToast.alert(message: 'unBlockade successful');
      } else {
        AppToast.alert(message: 'unBlocking failed');
      }
    });
  }
}
