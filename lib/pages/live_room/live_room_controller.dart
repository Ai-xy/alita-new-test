import 'package:alita/kit/app_fijk_player_kit.dart';
import 'package:alita/local_storage/app_local_storge.dart';
import 'package:alita/model/api/user_profile_model.dart';
import 'package:alita/model/ui/app_live_room_model.dart';
import 'package:alita/pages/live_list/widgets/live_room_card.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/util/log.dart';
import 'package:alita/util/toast.dart';
import 'package:alita/widgets/app_chatroom/app_chatroom_controller.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';

class LiveRoomController extends AppChatRoomController {
  final AppLiveRoomModel live;
  LiveRoomController({required this.live}) : super(liveRoom: live.liveRoom);
  FijkPlayerManager fijkPlayerManager = FijkPlayerManager();
  bool isRoomOwner = false;
  @override
  UserProfileModel? user;
  // 屏幕截屏
  ScreenshotController screenshotController = ScreenshotController();
  // 截下的图
  Uint8List? screenShotImage;
  static const String tag = 'LiveRoom';
  bool isPip = false;

  @override
  void onInit() {
    print('直播间信息');
    print(live.streamUrl);
    print(live.liveRoom.toJson());
    getUser();
    checkIsRoomOwner();
    // fijkPlayer = FijkPlayer()
    //   ..setDataSource('${liveRoom.streamUrl}', autoPlay: true, showCover: true);

    // fijkPlayer = FijkPlayer()
    //   ..setDataSource(live.streamUrl, autoPlay: true, showCover: true);

    // if (roomId != liveRoom.id && roomId != null) {
    //   // 换房间
    //   if(isP)
    //   fijkPlayer.release();
    //   AppToast.alert(message: '退出');
    //   onExitChatRoom();
    //   AppLocalStorage.getBool(AppStorageKey.pip);
    // }

    isPip = AppLocalStorage.getBool(AppStorageKey.pip);
    if (isPip == false) {
      fijkPlayerManager.setFijkPlayer('${mLiveRoom?.streamUrl}');
      // fijkPlayer = FijkPlayer()
      //   ..setDataSource(live.streamUrl, autoPlay: true, showCover: true);
      fijkPlayerManager.fijkPlayer.addListener(() {
        if (fijkPlayerManager.fijkPlayer.state == FijkState.completed ||
            fijkPlayerManager.fijkPlayer.state == FijkState.error) {
          // 直播已结束
          AppToast.alert(message: '直播已结束');
          isPip = AppLocalStorage.getBool(AppStorageKey.pip);
          Get.toNamed(AppPath.liveStreamEnd);
        }
      });
      AppToast.alert(message: '进入直播间');
      onEnterRoom();
    }
    super.onInit();
  }

  @override
  void onClose() {
    isPip = AppLocalStorage.getBool(AppStorageKey.pip);
    if (isPip == false) {
      fijkPlayerManager.fijkPlayer.pause();
      fijkPlayerManager.fijkPlayer.release();
      onExitChatRoom();
    }
    super.onClose();
  }

  getUser() {
    user = UserProfileModel.fromJson(
        AppLocalStorage.getJson(AppStorageKey.user) ?? {});
  }

  // 查看自己是否为房主
  checkIsRoomOwner() {
    print('id信息${live.liveRoom.homeownerId} ${user?.userId}');
    if (live.liveRoom.homeownerId == user?.userId) {
      isRoomOwner = true;
      update();
    } else {
      isRoomOwner = false;
    }
  }

  saveScreenshot(BuildContext context) async {
    try {
      Uint8List? imageBytes = await screenshotController.capture();

      await ImageGallerySaver.saveImage(imageBytes!);

      AppToast.alert(message: 'Screenshot saved to gallery!');
    } catch (e) {
      print(e);
    }
  }
}
