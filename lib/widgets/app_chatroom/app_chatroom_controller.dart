import 'dart:async';

import 'package:alita/base/base_app_controller.dart';
import 'package:alita/kit/app_nim_kit.dart';
import 'package:alita/model/api/live_room_model.dart';
import 'package:alita/util/log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nim_core/nim_core.dart';

abstract class AppChatRoomController extends BaseAppController {
  String get yxRoomId => '${liveRoom.yxRoomId}';
  String get streamUrl => '${liveRoom.streamUrl}';

  final LiveRoomModel liveRoom;

  AppChatRoomController({required this.liveRoom});

  RxList<NIMChatroomMessage> messageList = <NIMChatroomMessage>[].obs;
  List<NIMChatroomMember> chatroomMemberList = [];

  ///直播间关注数量
  RxInt memberNum = 0.obs;
  StreamSubscription<List<NIMChatroomMessage>>? _messageReceivedSubscription;
  StreamSubscription<NIMChatroomEvent>? _eventNotifySubscription;

  ScrollController messageListScrollController = ScrollController();

  Future sendMessage(String text) {
    return AppNimKit.instance
        .sendChatRoomTextMessage(text: text, roomId: yxRoomId)
        .then((value) {
      if (value == null) return;
      _addMessage(value);
    });
  }

  void _addMessage(NIMChatroomMessage message) {
    messageList.add(message);
    scrollToBottom();
  }

  Future _refreshRoomInfo() {
    return NimCore.instance.chatroomService
        .fetchChatroomInfo(yxRoomId)
        .then((value) {
      memberNum.value = value.data?.onlineUserCount ?? 1;
      Log.i('聊天室信息${value.toMap()} 当前在线数量${value.data?.onlineUserCount}');
    }).then((value) {
      return NimCore.instance.chatroomService
          .fetchChatroomMembers(
              roomId: yxRoomId,
              queryType:
                  NIMChatroomMemberQueryType.onlineGuestMemberByEnterTimeAsc,
              limit: 3)
          .then((value) {
        chatroomMemberList = value.data ?? [];
        for (NIMChatroomMember item in chatroomMemberList) {
          Log.i('直播间成员${item.nickname}');
        }
      });
    });
  }

  Future _fetchMessageHistory() {
    return NimCore.instance.chatroomService
        .fetchMessageHistory(
            roomId: yxRoomId,
            startTime: DateTime.now().millisecond,
            limit: 99,
            direction: QueryDirection.QUERY_OLD)
        .then((value) {
      if (value.data is List<NIMChatroomMessage>) {
        messageList.addAll(value.data as List<NIMChatroomMessage>);
      }
    });
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      messageListScrollController.animateTo(
          messageListScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease);
    });
  }

  Future onEnterRoom() {
    _listenLiveRoomState();
    return AppNimKit.instance
        .enterChatRoom(
            yxRoomId: yxRoomId, nickname: userNickname, avatar: userAvatar)
        .then((value) {
      return _refreshRoomInfo();
    }).then((value) {
      return _fetchMessageHistory();
    });
  }

  void _onEventNotified(NIMChatroomEvent event) {
    Log.i('直播间状态变化$event');
  }

  void _handleMemberInOrOut() {
    _refreshRoomInfo();
  }

  void _onMessageReceived(List<NIMChatroomMessage> event) {
    for (NIMChatroomMessage item in event) {
      Log.i('收到消息${item.toMap()}');
      if (item.messageAttachment is NIMChatroomMemberInAttachment ||
          item.messageAttachment is NIMChatroomNotificationAttachment) {
        _handleMemberInOrOut();
      }
      if (item.messageType == NIMMessageType.text &&
          (item.content == null || item.content?.isEmpty != true)) {
        _addMessage(item);
      }
    }
  }

  void _listenLiveRoomState() {
    _eventNotifySubscription = NimCore.instance.chatroomService.onEventNotified
        .listen(_onEventNotified);
    _messageReceivedSubscription = NimCore
        .instance.chatroomService.onMessageReceived
        .listen(_onMessageReceived);
  }

  void onExitChatRoom() {
    memberNum.close();
    messageList.close();
    messageListScrollController.dispose();
    _eventNotifySubscription?.cancel();
    _messageReceivedSubscription?.cancel();
    NimCore.instance.chatroomService.exitChatroom(yxRoomId);
  }
}
