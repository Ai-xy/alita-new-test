import 'dart:async';
import 'dart:ui';
import 'package:alita/base/base_app_controller.dart';
import 'package:alita/util/toast.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:nim_core/nim_core.dart';

class ChatBottomInputFieldController extends BaseAppController {
  // Offset startPosition = Offset.zero;
  // bool isButtonPressed = false;
  // bool isCancelRecord = false;
  // double distance = 0.0;
  // Timer? timer;
  // double _voiceTime = 0.0;
  // StreamSubscription? _voiceStreamSubscription;
  // FlutterSoundPlayer player = FlutterSoundPlayer();
  //
  // @override
  // void onInit() {
  //   super.onInit();
  //   _voiceStreamSubscription = NimCore.instance.audioService.onAudioRecordStatus
  //       .listen((RecordInfo recordInfo) {
  //     switch (recordInfo.recordState) {
  //       case RecordState.SUCCESS:
  //         if (recordInfo.filePath != null) {
  //           yxWS.sendVoiceMessage('${user?.yxAccid}', recordInfo.filePath!,
  //               recordInfo.fileSize!, recordInfo.duration!);
  //         }
  //         break;
  //       case RecordState.READY:
  //         break;
  //       case RecordState.START:
  //         break;
  //       case RecordState.REACHED_MAX:
  //         break;
  //       case RecordState.FAIL:
  //         AppToast.alert(message: 'record fail');
  //         break;
  //       case RecordState.CANCEL:
  //         break;
  //     }
  //   });
  // }
  //
  // @override
  // void onClose() {
  //   // TODO: implement onClose
  //   super.onClose();
  //   _voiceStreamSubscription?.cancel();
  //   if (player.isPlaying) {
  //     player.stopPlayer();
  //   }
  //   player.closePlayer();
  // }
  //
  // // 开始录音
  // void startRecord() {
  //   _voiceTime = 0.0;
  //   timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
  //     _voiceTime += 0.1;
  //     update();
  //   });
  //   NimCore.instance.audioService
  //       .startRecord(AudioOutputFormat.AAC, 60)
  //       .then((value) {});
  // }
  //
  // // 取消录音
  // void cancelRecord() {
  //   NimCore.instance.audioService.cancelRecord();
  // }
  //
  // // 结束录音
  // void endRecord() {
  //   timer?.cancel();
  //   if (_voiceTime >= 1) {
  //     NimCore.instance.audioService.stopRecord();
  //   } else {
  //     NimCore.instance.audioService.cancelRecord();
  //   }
  // }
}
