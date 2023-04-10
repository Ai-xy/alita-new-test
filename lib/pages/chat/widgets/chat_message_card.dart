import 'package:alita/pages/chat/widgets/chat_text_message_card.dart';
import 'package:alita/pages/chat/widgets/chat_video_message_card.dart';
import 'package:alita/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:nim_core/nim_core.dart';

import 'chat_image_message.dart';

class ChatMessageCard extends StatelessWidget {
  final bool isMe;
  final NIMMessage message;
  final String avatar;
  const ChatMessageCard(
      {Key? key,
      required this.isMe,
      required this.avatar,
      required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isMe
        ? _SenderMessageCard(
            avatar: avatar,
            message: message,
          )
        : _ReceiverMessageCard(message: message, avatar: avatar);
  }
}

class _SenderMessageCard extends StatelessWidget {
  final NIMMessage message;
  final String avatar;

  const _SenderMessageCard(
      {Key? key, required this.message, required this.avatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 84.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _MessageContent(message: message, isMe: true),
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
  const _ReceiverMessageCard(
      {Key? key, required this.message, required this.avatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 84.w),
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
          _MessageContent(message: message, isMe: false),
        ],
      ),
    );
  }
}

class _MessageContent extends StatelessWidget {
  final NIMMessage message;
  final bool isMe;
  const _MessageContent({Key? key, required this.message, required this.isMe})
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
    return ChatTextMessageCard(isSelf: isMe, message: message);
  }
}
