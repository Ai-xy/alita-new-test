import 'package:alita/R/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nim_core/nim_core.dart';

class ChatTextMessageCard extends StatelessWidget {
  final bool isSelf;
  final NIMMessage message;
  const ChatTextMessageCard(
      {Key? key, required this.isSelf, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 180.0),
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: isSelf ? const Color(0xFFFEA623) : const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        '${message.content}',
        style: TextStyle(
          fontSize: 14.sp,
          color: isSelf ? AppColor.white : AppColor.messageTextolor,
        ),
      ),
    );
  }
}
