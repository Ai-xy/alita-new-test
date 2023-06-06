import 'package:alita/pages/chat/chat_controller.dart';
import 'package:alita/pages/chat/widgets/chat_text_message_card.dart';
import 'package:alita/pages/chat/widgets/chat_video_message_card.dart';
import 'package:alita/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:nim_core/nim_core.dart';

import 'chat_audio_message_card.dart';
import 'chat_image_message.dart';

class ChatMessageCard extends StatelessWidget {
  final bool isMe;
  final NIMMessage message;
  final String avatar;
  final ChatController? controller;
  const ChatMessageCard(
      {Key? key,
      required this.isMe,
      required this.avatar,
      required this.message,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isMe
        ? _SenderMessageCard(
            avatar: avatar,
            message: message,
            controller: controller,
          )
        : _ReceiverMessageCard(
            message: message,
            avatar: avatar,
            controller: controller,
          );
  }
}

class _SenderMessageCard extends StatelessWidget {
  final NIMMessage message;
  final String avatar;
  final ChatController? controller;

  const _SenderMessageCard(
      {Key? key, required this.message, required this.avatar, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 84.w, top: 28.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _MessageContent(
            message: message,
            isMe: true,
            controller: controller,
          ),
          Gap(12.w),
          AppImage(
            avatar,
            width: 32.r,
            height: 32.r,
            borderRadius: BorderRadius.circular(16.r),
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}

class _ReceiverMessageCard extends StatelessWidget {
  final NIMMessage message;
  final String avatar;
  final ChatController? controller;
  const _ReceiverMessageCard(
      {Key? key, required this.message, required this.avatar, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 84.w, top: 28.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppImage(
            avatar,
            width: 32.r,
            height: 32.r,
            borderRadius: BorderRadius.circular(16.r),
            fit: BoxFit.cover,
          ),
          Gap(12.w),
          _MessageContent(
            message: message,
            isMe: false,
            controller: controller,
          ),
        ],
      ),
    );
  }
}

class _MessageContent extends StatelessWidget {
  final NIMMessage message;
  final bool isMe;
  final ChatController? controller;
  const _MessageContent(
      {Key? key, required this.message, required this.isMe, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message.messageType == NIMMessageType.image &&
        message.messageAttachment is NIMImageAttachment) {
      return Builder(builder: (BuildContext context) {
        return ChatImageMessageCard(message: message);
      });
    }
    if (message.messageType == NIMMessageType.video &&
        message.messageAttachment is NIMVideoAttachment) {
      return ChatVideoMessageCard(message: message);
    }
    if (message.messageType == NIMMessageType.audio &&
        message.messageAttachment is NIMAudioAttachment) {
      return ChatAudioMessageCard(
        isSelf: isMe,
        message: message,
        controller: controller,
      );
    }
    return ChatTextMessageCard(isSelf: isMe, message: message);
  }
}
