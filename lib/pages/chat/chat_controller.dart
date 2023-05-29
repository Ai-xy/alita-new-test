// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:io';
import 'package:alita/base/base_app_future_controller.dart';
import 'package:alita/kit/app_media_kit.dart';
import 'package:alita/kit/app_nim_kit.dart';
import 'package:alita/model/ui/app_conversation_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nim_core/nim_core.dart';

class ChatController extends BaseAppFutureLoadStateController {
  final AppUserConversationModel conversation;

  ChatController({required this.conversation});

  RxList<NIMMessage> messageList = <NIMMessage>[].obs;
  StreamSubscription<List<NIMMessage>>? _streamSubscription;

  final ScrollController scrollController = ScrollController();

  String get sessionId => '${conversation.nimUser?.userId}';

  StreamSubscription<List<NIMMessage>>? _subscription;

  @override
  void onInit() {
    NimCore.instance.messageService.createSession(
        sessionId: sessionId,
        sessionType: NIMSessionType.p2p,
        time: DateTime.now().millisecond);
    _subscription = NimCore.instance.messageService.onMessage.listen((event) {
      _addMessageList(event);
    });
    // 跟新未读数
    final sessionInfo = NIMSessionInfo(
        sessionId: conversation.session.sessionId,
        sessionType: NIMSessionType.p2p);
    updateSessionReadStatus(sessionInfo);
    super.onInit();
  }

  @override
  Future loadData({Map? params}) {
    return NimCore.instance.messageService
        .queryLastMessage(sessionId, NIMSessionType.p2p)
        .then((value) {
      if (value.data is! NIMMessage) return;
      final NIMMessage anchor = value.data as NIMMessage;
      NimCore.instance.messageService
          .queryMessageListEx(anchor, QueryDirection.QUERY_OLD, 99)
          .then((value) {
        if (value.data is List<NIMMessage>) {
          final List<NIMMessage> data = value.data as List<NIMMessage>;
          _addMessageList(data);
          // autoScrollController.scrollToIndex(messageList.length,
          //     preferPosition: AutoScrollPosition.begin);
        }
      });
    });
  }

  Future sendMessage(String message) {
    return AppNimKit.instance
        .sendP2PTextMessage(text: message, targetAccount: sessionId)
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
          sessionId: sessionId,
          sessionType: NIMSessionType.p2p,
          filePath: e.path,
          fileSize: File(e.path).lengthSync(),
        ).then((value) {
          if (value.isSuccess == false) return Future.error('error');
          final NIMMessage message = value.data!;
          _addMessage(message);
          return NimCore.instance.messageService.sendMessage(message: message);
        });
      });
    });
  }

  Future sendVideo() {
    return AppMediaKit.pickVideo().then((value) {
      if (value == null) return Future.value(value);
      return AppNimKit.instance
          .createVideoMessage(file: File(value.path), targetAccount: sessionId)
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
    super.onClose();
  }
}
