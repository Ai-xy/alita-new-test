// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:io';
import 'package:alita/base/base_app_future_controller.dart';
import 'package:alita/kit/app_media_kit.dart';
import 'package:alita/kit/app_nim_kit.dart';
import 'package:alita/model/ui/app_conversation_model.dart';
import 'package:alita/util/log.dart';
import 'package:alita/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nim_core/nim_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class ChatController extends BaseAppFutureLoadStateController {
  final AppUserConversationModel conversation;

  ChatController({required this.conversation});

  RxList<NIMMessage> messageList = <NIMMessage>[].obs;
  StreamSubscription<List<NIMMessage>>? _streamSubscription;

  final ScrollController scrollController = ScrollController();

  String get sessionId => '${conversation.nimUser?.userId}';
  String get mSessionId => conversation.session.sessionId;

  String? yxSessionId;

  StreamSubscription<List<NIMMessage>>? _subscription;

  /// 语音相关
  Offset startPosition = Offset.zero;
  bool isButtonPressed = false;
  bool isCancelRecord = false;
  double distance = 0.0;
  Timer? timer;
  double _voiceTime = 0.0;
  StreamSubscription? _voiceStreamSubscription;
  FlutterSoundPlayer player = FlutterSoundPlayer();
  bool isPlaying = false;
  bool isSendMsg = false;

  @override
  void onInit() {
    Log.d('sessionId:${sessionId}');
    Log.d('mSessionId:${mSessionId}');

    yxSessionId = sessionId == 'null' ? mSessionId : sessionId;


    // NimCore.instance.messageService.createSession(
    //     sessionId: yxSessionId!,
    //     sessionType: NIMSessionType.p2p,
    //     time: DateTime.now().millisecond);

    _subscription = NimCore.instance.messageService.onMessage.listen((event) {
      _addMessageList(event);
    });
    // 更新未读数
    final sessionInfo = NIMSessionInfo(
        sessionId: yxSessionId!, sessionType: NIMSessionType.p2p);
    updateSessionReadStatus(sessionInfo);
    permission();

    _voiceStreamSubscription = NimCore.instance.audioService.onAudioRecordStatus
        .listen((RecordInfo recordInfo) {
      switch (recordInfo.recordState) {
        case RecordState.SUCCESS:
          if (recordInfo.filePath != null) {
            sendVoiceMessage(yxSessionId!, recordInfo.filePath!,
                recordInfo.fileSize!, recordInfo.duration!);
          }
          break;
        case RecordState.READY:
          break;
        case RecordState.START:
          break;
        case RecordState.REACHED_MAX:
          break;
        case RecordState.FAIL:
          AppToast.alert(message: 'record fail');
          break;
        case RecordState.CANCEL:
          break;
      }
    });
    super.onInit();
  }

  @override
  Future loadData({Map? params}) {
    return NimCore.instance.messageService
        .queryLastMessage(yxSessionId!, NIMSessionType.p2p)
        .then((value) {
      if (value.data is! NIMMessage) return;
      final NIMMessage anchor = value.data as NIMMessage;
      NimCore.instance.messageService
          .queryMessageListEx(anchor, QueryDirection.QUERY_OLD, 30)
          .then((value) {
        if (value.data is List<NIMMessage>) {
          Log.d('查询历史消息${value.data}');
          final List<NIMMessage> data = value.data as List<NIMMessage>;
          _addMessageList(data);
          _addMessageList([anchor]);

          // autoScrollController.scrollToIndex(messageList.length,
          //     preferPosition: AutoScrollPosition.begin);
        }
      });
    });
  }

  Future sendMessage(String message) {
    return AppNimKit.instance
        .sendP2PTextMessage(text: message, targetAccount: yxSessionId!)
        .then((value) {
      if (value == null) return;
      _addMessage(value);
    });
  }

  Future sendImage() {
    return AppMediaKit.pickMultiImage().then((value) {
      if (value == null) return Future.value(value);
      return Future.forEach<XFile>(value, (e) {
        MessageBuilder.createImageMessage(
          sessionId: yxSessionId!,
          sessionType: NIMSessionType.p2p,
          filePath: e.path,
          fileSize: File(e.path).lengthSync(),
        ).then((value) {
          if (value.isSuccess == false) return Future.error('error');
          final NIMMessage message = value.data!;
          message.config = NIMCustomMessageConfig(enablePush: true);
          return NimCore.instance.messageService.sendMessage(message: message);
        }).then((value) {
          if (value.data != null) {
            _addMessage(value.data);
          }
        });
      });
    });
  }

  Future sendVideo() async {
    return AppMediaKit.pickVideo().then((value) {
      if (value == null) return Future.value(value);
      return AppNimKit.instance
          .createVideoMessage(
              file: File(value.path), targetAccount: yxSessionId!)
          .then((value) {
        return value.isSuccess
            ? Future(() {
                NIMMessage message = value.data!;
                _addMessage(message);
                return NimCore.instance.messageService
                    .sendMessage(message: message, resend: false);
              })
            : Future.value(value);
      });
    });
  }

  void _addMessage(NIMMessage message) {
    // messageList.insert(0, message);
    messageList.add(message);
    _scrollToBottom();
  }

  void _addMessageList(List<NIMMessage> list) {
    messageList.addAll(list);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 20), () {
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 10),
          curve: Curves.linearToEaseOut);
    });
  }

  // 更新会话
  void updateSession() {}

  // update会话状态
  updateSessionReadStatus(NIMSessionInfo sessionInfo) async {
    NimCore.instance.messageService.clearSessionUnreadCount([sessionInfo]);
    update();
  }

  Future permission() async {
    await [Permission.microphone].request();
    await [Permission.audio].request();
  }

  // Future _scrollToAnchor(NIMMessage anchor) {
  // int index = messageList.indexWhere((e) => e.uuid == anchor.uuid);
  // if (index > 0) {
  //   return autoScrollController
  //       .scrollToIndex(index, duration: const Duration(milliseconds: 1))
  //       .then((value) {
  //     autoScrollController.scrollToIndex(index,
  //         preferPosition: AutoScrollPosition.middle);
  //   });
  // }
  // return autoScrollController
  //     .scrollToIndex(messageList.length,
  //         duration: const Duration(milliseconds: 1))
  //     .then((value) {
  //   return autoScrollController.scrollToIndex(index,
  //       preferPosition: AutoScrollPosition.middle);
  // });
  // }

  @override
  void onClose() {
    messageList.close();
    _streamSubscription?.cancel();
    scrollController.dispose();
    _subscription?.cancel();
    _voiceStreamSubscription?.cancel();
    if (player.isPlaying) {
      player.stopPlayer();
    }
    player.closePlayer();
    super.onClose();
  }

  // 开始录音
  void startRecord() {
    _voiceTime = 0.0;
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _voiceTime += 0.1;
      update();
    });
    NimCore.instance.audioService
        .startRecord(AudioOutputFormat.AAC, 60)
        .then((value) {});
  }

  // 取消录音
  void cancelRecord() {
    NimCore.instance.audioService.cancelRecord();
  }

  // 结束录音
  void endRecord() {
    timer?.cancel();
    if (_voiceTime >= 1) {
      NimCore.instance.audioService.stopRecord();
    } else {
      NimCore.instance.audioService.cancelRecord();
    }
  }

  /// 发送语音消息
  sendVoiceMessage(
      String sessionId, String filePath, int fileSize, int duration) {
    MessageBuilder.createAudioMessage(
            sessionId: sessionId,
            sessionType: NIMSessionType.p2p,
            filePath: filePath,
            fileSize: fileSize,
            duration: duration)
        .then<NIMResult>((value) {
      if (value.isSuccess) {
        NIMMessage message = value.data!;
        return NimCore.instance.messageService
            .sendMessage(message: message, resend: false);
      } else {
        return value;
      }
    }).then((result) {
      _addMessage(result.data);
      update();
    });
  }

  String timeFormat(int milliSecond) {
    var nowTime = DateTime.now();
    var messageTime = DateTime.fromMillisecondsSinceEpoch(milliSecond);
    if (nowTime.year != messageTime.year) {
      return DateFormat('yyyy-MM-dd HH:mm').format(messageTime);
    } else if (nowTime.day != messageTime.day) {
      return DateFormat('MM-dd HH:mm').format(messageTime);
    } else {
      return DateFormat('HH : mm').format(messageTime);
    }
  }

  Future query(String yxId) async {
    isSendMsg = false;
    await AppNimKit.instance.queryIsSendMsg(yxId).then((value) {
      if (value) {
        isSendMsg = true;
      }
      update();
    });
    update();
  }


}
