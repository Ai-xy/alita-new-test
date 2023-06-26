import 'package:alita/api/user_api.dart';
import 'package:alita/base/base_app_controller.dart';
import 'package:alita/enum/anchor_type.dart';
import 'package:alita/model/api/user_friend_entity.dart';

class UserCenterBlockListController extends BaseAppController {
  List<UserFriendEntity> blockList = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getBlockList();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // 获取用户中心拉黑列表
  getBlockList() {
    UserApi.getBlockList().then((value) {
      blockList = value;
    }).whenComplete(update);
  }

  // 移除
  removeFromBlockList(int userId, String yxId, int index) {
    UserApi.removeFromBlockList(userId: userId, yxId: yxId).then((value) {
      if (value == true) {
        blockList.removeAt(index);
      }
    }).whenComplete(update);
  }
}
