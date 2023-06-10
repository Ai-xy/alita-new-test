import 'dart:async';

import 'package:alita/base/base_app_controller.dart';
import 'package:alita/kit/app_nim_kit.dart';
import 'package:alita/manager/auth_manager.dart';
import 'package:alita/model/api/live_room_model.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/util/log.dart';
import 'package:alita/util/toast.dart';
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

  static ChatroomService? chatroomService;

  ///直播间关注数量
  RxInt memberNum = 0.obs;
  StreamSubscription<List<NIMChatroomMessage>>? _messageReceivedSubscription;
  StreamSubscription<NIMChatroomEvent>? _eventNotifySubscription;

  ScrollController messageListScrollController = ScrollController();

  /// 发送直播间消息
  Future sendMessage(String text, {String? giftUrl, String? giftNum}) async {
    ChatroomMessageBuilder.createChatroomTextMessage(
            roomId: yxRoomId, text: text)
        .then<NIMResult>((value) async {
      if (value.isSuccess) {
        value.data!.enableHistory = false;
        value.data!.remoteExtension = {
          'avatar': user?.icon,
          'userId': user?.userId,
          'nickname': user?.nickname,
          'giftUrl': giftUrl,
          'giftNum': giftNum,
        };
        print('createChatroomTextMessage返回 ${value.toMap().toString()}');
        return chatroomService!.sendChatroomMessage(value.data!);
      } else {
        print('createChatroomTextMessage返回 下卖弄');
        return value;
      }
    }).then((value) {
      if (value.isSuccess) {
        print('createChatroomTextMessage之后返回 ${value.toMap().toString()}');
        _addMessage(value.data);
        update();
      } else {
        AppToast.alert(message: 'send fail');
      }
    });
    // return AppNimKit.instance
    //     .sendChatRoomTextMessage(text: text, roomId: yxRoomId)
    //     .then((value) {
    //   if (value == null) return;
    //   _addMessage(value);
    // });
  }

  /// 发送直播间送礼消息
  Future sendGiftMessage(String text,
      {String? giftUrl, String? giftNum}) async {
    ChatroomMessageBuilder.createChatroomTextMessage(
            roomId: yxRoomId, text: text)
        .then<NIMResult>((value) async {
      if (value.isSuccess) {
        value.data!.enableHistory = false;
        value.data!.remoteExtension = {
          'avatar': user?.icon,
          'userId': user?.userId,
          'nickname': user?.nickname,
          'giftUrl': giftUrl,
          'giftNum': giftNum,
        };
        print('createChatroomTextMessage返回 ${value.toMap().toString()}');
        return chatroomService!.sendChatroomMessage(value.data!);
      } else {
        print('createChatroomTextMessage返回 下卖弄');
        return value;
      }
    }).then((value) {
      if (value.isSuccess) {
        print('createChatroomTextMessage之后返回 ${value.toMap().toString()}');
        _addMessage(value.data);
        update();
      } else {
        AppToast.alert(message: 'send fail');
      }
    });
    // return AppNimKit.instance
    //     .sendChatRoomTextMessage(text: text, roomId: yxRoomId)
    //     .then((value) {
    //   if (value == null) return;
    //   _addMessage(value);
    // });
  }

  // Future sendCustomMessage(String giftUrl) async {
  //   print('发送自定义消息$giftUrl');
  //   return ChatroomMessageBuilder.createChatroomCustomMessage(
  //           roomId: yxRoomId,
  //           attachment: NIMMessageAttachment.fromJson({'giftUrl': giftUrl}))
  //       .then<NIMResult>((value) async {
  //     print('创建的礼物信息');
  //     print(value.toMap());
  //     if (value.isSuccess) {
  //       value.data!.enableHistory = false;
  //       value.data!.remoteExtension = {
  //         'avatar': user?.icon,
  //         'userId': user?.userId,
  //         'nickname': user?.nickname,
  //       };
  //       return chatroomService!.sendChatroomCustomMessage(roomId: yxRoomId);
  //     } else {
  //       return value;
  //     }
  //   }).then((value) {
  //     if (value.isSuccess) {
  //       print('创建的礼物信息下一步是');
  //       print(value.toMap());
  //       _addMessage(value.data);
  //       update();
  //     } else {
  //       AppToast.alert(message: 'send fail');
  //     }
  //   });
  // }

  void _addMessage(NIMChatroomMessage message) {
    Log.d(message.toMap().toString(), tag: '添加到消息list');
    messageList.add(message);
    Log.d(messageList.length.toString(), tag: 'messagelist长度');
    update();
    //scrollToBottom();
  }

  /// 刷新直播间信息
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
              limit: 30)
          .then((value) {
        chatroomMemberList = value.data ?? [];
        update();
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
    // 保存im 房间id，关闭最小化窗口时使用。
    AuthManager().setRoomId(yxRoomId);
    _listenLiveRoomState();
    return AppNimKit.instance
        .enterChatRoom(
            userId: userId,
            yxRoomId: yxRoomId,
            nickname: userNickname,
            avatar: userAvatar,
            gender: userGender)
        .then((value) {
      if (value == false) {
        AppToast.alert(message: 'You have been blacklisted');
        Get.back();
      } else {
        chatroomService ??= NimCore.instance.chatroomService;
        return _refreshRoomInfo();
      }
    }).then((value) {
      return _fetchMessageHistory();
    });
  }

  void _onEventNotified(NIMChatroomEvent event) {
    Log.i('直播间状态变化$event');
    // 如果被踢出,则退出房间
    if (event is NIMChatroomKickOutEvent) {
      switch (event.reason) {
        case NIMChatroomKickOutReason.unknown:
          AppToast.alert(message: 'Unknown');
          break;
        case NIMChatroomKickOutReason.dismissed:
          AppToast.alert(message: 'The chat room has been disbanded');
          break;
        case NIMChatroomKickOutReason.byManager:
          AppToast.alert(message: 'You have been kicked out by the homeowner');
          break;
        case NIMChatroomKickOutReason.byConflictLogin:
          AppToast.alert(message: 'Kicked out by the other end');
          break;
        case NIMChatroomKickOutReason.blacklisted:
          AppToast.alert(message: 'You have been blocked');
          break;
      }
      onExitChatRoom().then((value) {
        // 回到home页
        Get.offNamedUntil(AppPath.home, ModalRoute.withName('/'));
      });
    }
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

      if (item.messageType == NIMMessageType.notification &&
          item.messageAttachment != null) {
        final notificationInfo =
            item.messageAttachment as NIMChatroomNotificationAttachment;

        // 收到被禁言通知
        if (notificationInfo.type ==
            NIMChatroomNotificationTypes.chatRoomMemberMuteAdd) {
          Map<String, dynamic>? info = notificationInfo.extension;
          AppToast.alert(
              message:
                  'You have been silenced for ${info?['duration']} seconds');
        }

        // if (item.messageAttachment?.toMap()['duration'] != null) {
        //   Map<String, dynamic>? info = item.messageAttachment?.toMap();
        //   AppToast.alert(
        //       message:
        //           'You have been silenced for ${info?['duration']} seconds');
        // }
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

  Future onExitChatRoom() async {
    AppToast.alert(message: '退出房间');
    memberNum = 0.obs;
    messageList.clear();
    //messageListScrollController.dispose();
    if (_messageReceivedSubscription != null) {
      _messageReceivedSubscription?.cancel();
    }
    if (_eventNotifySubscription != null) {
      _eventNotifySubscription?.cancel();
    }
    NimCore.instance.chatroomService.exitChatroom(yxRoomId);
    Log.d('退出ExitChatRoom', tag: '退出ExitChatRoom');
  }
}
