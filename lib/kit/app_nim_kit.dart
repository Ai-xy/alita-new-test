import 'dart:async';
import 'dart:io';
import 'package:alita/config/app_config.dart';
import 'package:alita/local_storage/app_local_storge.dart';
import 'package:alita/model/api/user_profile_model.dart';
import 'package:alita/util/log.dart';
import 'package:alita/util/toast.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nim_core/nim_core.dart';
import 'package:video_player/video_player.dart';

class AppNimKit {
  static AppNimKit? _instace;
  static AppNimKit get instance {
    _instace ??= AppNimKit._();
    return _instace!;
  }

  static const String tag = 'NIM';

  final UserProfileModel user = UserProfileModel.fromJson(
      AppLocalStorage.getJson(AppStorageKey.user) ?? {});
  AppNimKit._();

  Future _ensureSdkIsInitialized() {
    if (NimCore.instance.isInitialized) return Future.value(true);
    final NIMSDKOptions options = Platform.isAndroid
        ? NIMAndroidSDKOptions(appKey: AppConfig.env.neAppKey)
        : NIMIOSSDKOptions(appKey: AppConfig.env.neAppKey);

    return NimCore.instance.initialize(options).then((NIMResult value) {
      Log.i(value.isSuccess ? 'IM服务初始化成功' : 'IM服务初始化失败', tag: tag);
      return value.isSuccess;
    }).catchError((err, s) {
      Log.e('IM初始化出错', error: err, stackTrace: s, tag: tag);
      return false;
    });
  }

  void subscribeNimAuthStatus() {}

  void subscribeNimAppMessage() {}

  void subscribeNimSystemMessage() {}

  void subscribeNimAvSignal() {
    NimCore.instance.avSignallingService.onlineNotification.listen((event) {
      ///TODO
    });
  }

  Future<bool> login() {
    return _ensureSdkIsInitialized().then((value) {
      return NimCore.instance.authService
          .login(NIMLoginInfo(
              account: '${user.yxAccid}', token: '${user.imToken}'))
          .then((value) {
        Log.i('IM登录结果$value', tag: tag);
        AppToast.alert(message: 'login success');
        return true;
      }).catchError((err, s) {
        Log.e('IM登录出错', tag: tag, error: err, stackTrace: s);
        AppToast.alert(message: 'login fail');
        return false;
      });
    });
  }

  Future<bool> enterChatRoom({
    required String yxRoomId,
    required String nickname,
    required String avatar,
  }) {
    return NimCore.instance.chatroomService
        .enterChatroom(NIMChatroomEnterRequest(
      roomId: yxRoomId,
      nickname: nickname,
      avatar: avatar,
      retryCount: 5,
    ))
        .then((value) {
      Log.i('加入聊天室$yxRoomId结果${value.isSuccess} $value', tag: tag);
      return value.isSuccess;
    }).catchError((err, s) {
      Log.i('加入聊天室$yxRoomId出错', tag: tag);
      return false;
    });
  }

  Future<NIMChatroomMessage?> sendChatRoomTextMessage(
      {required String text, required String roomId}) {
    return ChatroomMessageBuilder.createChatroomTextMessage(
      roomId: roomId,
      text: text,
    ).catchError((err, s) {
      Log.e('创建text信息失败', error: err, stackTrace: s, tag: tag);
      throw err;
    }).then<NIMResult>((result) {
      if (result.isSuccess == false || result.data == null) {
        throw '发送数据失败';
      }
      return NimCore.instance.chatroomService.sendChatroomMessage(result.data!);
    }).then((value) {
      Log.i('发送text信息:$text结果 $value', tag: tag);
      if (value.data is NIMChatroomMessage) {
        return value.data as NIMChatroomMessage;
      }
      return null;
    }).catchError((err, s) {
      Log.e('发送text信息失败', error: err, stackTrace: s, tag: tag);
      throw err;
    });
  }

  Future<NIMMessage?> sendP2PTextMessage(
      {required String text, required String targetAccount}) {
    return MessageBuilder.createTextMessage(
            sessionId: targetAccount,
            sessionType: NIMSessionType.p2p,
            text: text)
        .then((value) {
      return value.isSuccess
          ? sendMessage(message: value.data!, resend: false)
          : Future.value(value.data);
    });
  }

  Future<NIMMessage?> sendImageMessage(
      {required File file, required String targetAccount}) {
    return MessageBuilder.createImageMessage(
      sessionId: targetAccount,
      sessionType: NIMSessionType.p2p,
      filePath: file.path,
      fileSize: file.lengthSync(),
    ).then((value) {
      return value.isSuccess
          ? sendMessage(message: value.data!, resend: false)
          : Future.value(value.data);
    });
  }

  Future<NIMResult<NIMMessage>> createVideoMessage(
      {required File file, required String targetAccount}) {
    VideoPlayerController controller = VideoPlayerController.file(file);
    return controller.initialize().then((value) {
      return MessageBuilder.createVideoMessage(
        sessionId: targetAccount,
        sessionType: NIMSessionType.p2p,
        filePath: file.path,
        fileSize: file.lengthSync(),
        displayName: file.path.substring(file.path.lastIndexOf('/')),
        duration: controller.value.duration.inMilliseconds,
        height: controller.value.size.height ~/ 1,
        width: controller.value.size.width ~/ 1,
      ).whenComplete(controller.dispose);
    });
  }

  Future<NIMMessage> sendMessage(
      {required NIMMessage message,
      bool resend = false,
      Function(NIMMessage)? onMessageStatusChanged}) {
    final Completer<NIMMessage> completer = Completer();
    // DateTime startAt = DateTime.now();
    // final Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    //   if (DateTime.now().difference(startAt) > const Duration(seconds: 5)) {
    //     completer.complete(message);
    //     timer.cancel();
    //   }
    // });
    NimCore.instance.messageService.onMessageStatus.listen((event) {
      if (onMessageStatusChanged != null) {
        onMessageStatusChanged(event);
      }
      if (message.uuid == event.uuid) {
        if (event.status == NIMMessageStatus.success) {
          if (completer.isCompleted) return;
          completer.complete(event);
        }
        if (event.status == NIMMessageStatus.fail) {
          completer.complete(event);
        }
      }
    });
    NimCore.instance.messageService
        .sendMessage(message: message, resend: resend);
    return completer.future;
  }

  Future<NIMMessage?> sendVideoMessage(
      {required File file, required String targetAccount}) {
    return createVideoMessage(file: file, targetAccount: targetAccount)
        .then((value) {
      return value.isSuccess
          ? sendMessage(message: value.data!, resend: false)
          : Future.value(value.data);
    });
  }

  Future<NIMMessage?> sendAudioMessage(
      {required File file, required String targetAccount}) {
    return MessageBuilder.createAudioMessage(
      sessionId: targetAccount,
      sessionType: NIMSessionType.p2p,
      filePath: file.path,
      fileSize: file.lengthSync(),
      duration: 0,
    ).then((value) {
      return value.isSuccess
          ? sendMessage(message: value.data!, resend: false)
          : Future.value(value.data);
    });
  }
}
