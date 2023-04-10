import 'package:alita/kit/app_permission_kit.dart';
import 'package:alita/util/log.dart';
import 'package:alita/widgets/app_chatroom/app_chatroom_controller.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rtmp_broadcaster/camera.dart';
import 'package:wakelock/wakelock.dart';
import 'my_live_room_binding.dart';

class MyLiveRoomController extends AppChatRoomController
    with WidgetsBindingObserver {
  MyLiveRoomController({required MyLiveRoomConfigArgument argument})
      : cameraController = argument.cameraController,
        super(liveRoom: argument.liveRoom);

  CameraController? cameraController;

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
    super.onClose();
  }
}
