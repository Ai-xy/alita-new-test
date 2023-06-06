import 'package:alita/api/live_api.dart';
import 'package:alita/base/base_app_controller.dart';
import 'package:alita/config/app_config.dart';
import 'package:alita/enum/app_live_room_type.dart';
import 'package:alita/kit/app_media_kit.dart';
import 'package:alita/mixins/app_live_binding.dart';
import 'package:alita/model/api/live_room_model.dart';
import 'package:alita/pages/my_live_room/my_live_room_binding.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/util/log.dart';
import 'package:alita/util/toast.dart';
import 'package:get/get.dart';
import 'package:rtmp_broadcaster/camera.dart';

class StartLiveController extends BaseAppController with AppLiveBinding {
  CameraController? cameraController;
  String? cover;
  @override
  void onInit() {
    initFrontCameraController().then((value) {
      cameraController = value;
      return cameraController?.initialize();
    }).whenComplete(update);
    super.onInit();
  }

  AppLiveRoomType liveRoomType = AppLiveRoomType.publicRoom;
  String password = '';

  bool get locked => liveRoomType == AppLiveRoomType.passwordRoom;

  void setLiveRoomType(AppLiveRoomType type) {
    liveRoomType = type;
    update();
  }

  void setRoomPassword(String text) {
    password = text;
    update();
  }

  Future uploadCover() {
    return AppMediaKit.uploadImage(serverDir: '${AppConfig.env.appId}/')
        .then((value) {
      cover = value;
      update();
    });
  }

  Future? startLive() {
    if (cover == null) {
      AppToast.alert(message: AppMessage.uploadCoverTip.tr);
      return Future.error(AppMessage.uploadCoverTip.tr);
    }
    if (liveRoomType == AppLiveRoomType.passwordRoom &&
        RegExp(r'\d{4}').hasMatch(password)) {
      AppToast.alert(message: AppMessage.enterLiveRoomPassword.tr);
      return Future.error(AppMessage.enterLiveRoomPassword.tr);
    }

    return LiveApi.createLiveRoom(
      cover: '$cover',
      isLocked: liveRoomType == AppLiveRoomType.passwordRoom,
      password: password,
      userIcon: '${user?.icon}',
      userId: user?.userId ?? 0,
      userNickname: user?.nickname ?? '',
    ).then((value) {
      Log.d('创建的房间信息 ${value.toJson()}');
      if (cameraController?.value.isInitialized != true) {}
      LiveRoomModel liveRoomInfo = LiveRoomModel();
      liveRoomInfo = value;
      liveRoomInfo.homeownerId = user?.userId;
      liveRoomInfo.homeownerNickname = user?.nickname;
      liveRoomInfo.homeownerIcon = user?.icon;
      liveRoomInfo.liveRoomName = 'test';
      Log.d('附加信息${liveRoomInfo.toJson().toString()}');
      return Get.toNamed(AppPath.myLiveRoom,
          arguments: MyLiveRoomConfigArgument(
              cameraController: cameraController!, liveRoom: liveRoomInfo));
    });
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}
