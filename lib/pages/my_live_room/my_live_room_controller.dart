import 'dart:typed_data';

import 'package:alita/api/user_api.dart';
import 'package:alita/kit/app_permission_kit.dart';
import 'package:alita/model/api/live_room_model.dart';
import 'package:alita/util/log.dart';
import 'package:alita/util/toast.dart';
import 'package:alita/widgets/app_chatroom/app_chatroom_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rtmp_broadcaster/camera.dart';
import 'package:screenshot/screenshot.dart';
import 'package:wakelock/wakelock.dart';
import 'my_live_room_binding.dart';

class MyLiveRoomController extends AppChatRoomController
    with WidgetsBindingObserver {
  MyLiveRoomController({required MyLiveRoomConfigArgument argument})
      : cameraController = argument.cameraController,
        super(liveRoom: argument.liveRoom);
  CameraController? cameraController;

  // 屏幕截屏
  ScreenshotController screenshotController = ScreenshotController();
  // 截下的图
  Uint8List? screenShotImage;

  // 反转摄像头
  Future flipCamera() {
    if (cameraController == null) {
      return Future.error('cameraController is null');
    }
    CameraController controller = cameraController!;
    return controller.stopVideoStreaming().whenComplete(() {
      controller.dispose();
      CameraLensDirection targetDirection =
          controller.description.lensDirection == CameraLensDirection.front
              ? CameraLensDirection.back
              : CameraLensDirection.front;
      return availableCameras().then((cameras) {
        for (CameraDescription description in cameras) {
          if (description.lensDirection == targetDirection) {
            cameraController = CameraController(
              description,
              ResolutionPreset.medium,
            );
            return cameraController?.initialize().then((value) {
              return cameraController?.startVideoStreaming(streamUrl);
            });
          }
        }
      });
    });
  }

  Future<void>? pauseVideoStreaming() {
    if (cameraController?.value.isStreamingVideoRtmp != true) {
      return Future.value(null);
    }
    return cameraController?.pauseVideoStreaming().catchError((err, s) {
      Log.e('暂停直播出错', error: err, stackTrace: s);
    });
  }

  Future<void>? resumeVideoStreaming() {
    if (cameraController?.value.isStreamingVideoRtmp == true) {
      return Future.value(null);
    }

    return cameraController?.resumeVideoStreaming().catchError((err, s) {
      Log.e('恢复直播出错', error: err, stackTrace: s);
    });
  }

  Future<void>? startRecordScreen() {
    return cameraController?.startVideoRecording('');
  }

  bool get isStreaming => cameraController?.value.isStreamingVideoRtmp ?? false;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (cameraController == null ||
        cameraController?.value.isInitialized != true) {
      return;
    }
    if (state == AppLifecycleState.paused && isStreaming) {
      pauseVideoStreaming();
      return;
    }
    if (state == AppLifecycleState.resumed) {
      resumeVideoStreaming();
      return;
    }
  }

  @override
  void onInit() {
    Wakelock.enable();
    WidgetsBinding.instance.addObserver(this);
    onEnterRoom();
    Future.delayed(const Duration(seconds: 3), () {
      cameraController?.startVideoStreaming(streamUrl);
    });
    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    Wakelock.disable();
    cameraController?.stopVideoStreaming();
    cameraController?.dispose();
    super.onClose();
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

  bool isRecording = false;
  String? videoPath;

  void startRecording() async {
    try {
      await FlutterScreenRecording.startRecordScreen('alita_record');
      isRecording = true;
      update();
    } catch (error) {
      print(error);
    }
  }

  void stopRecording() async {
    try {
      String path = await FlutterScreenRecording.stopRecordScreen;
      isRecording = false;
      videoPath = path;
      update();
      _saveToGallery(path).then((value) {
        AppToast.alert(
            message:
                'Screen recording has been successfully saved to the album');
      });
    } catch (error) {
      print(error);
    }
  }

  /// 保存至相册
  Future<void> _saveToGallery(String path) async {
    if (await Permission.storage.request().isGranted) {
      var file = await DefaultCacheManager().getSingleFile(path);
      await ImageGallerySaver.saveFile(file.path);
    }
  }
}
