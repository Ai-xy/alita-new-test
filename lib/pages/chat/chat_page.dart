import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/kit/app_date_time_kit.dart';
import 'package:alita/pages/chat/chat_controller.dart';
import 'package:alita/pages/chat/widgets/chat_bottom_input_field.dart';
import 'package:alita/pages/chat/widgets/chat_message_card.dart';
import 'package:alita/util/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nim_core/nim_core.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (_) {
      return Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          centerTitle: false,
          title: Text('${_.conversation.session.senderNickname}'),
          actions: [
            Image.asset(
              AppIcon.addFriend.uri,
              width: 42.w,
              height: 24.h,
            ),
            IconButton(
              onPressed: () {},
              icon: Image.asset(
                AppIcon.more.uri,
                width: 5.w,
                height: 20.h,
              ),
            ),
          ],
        ),
        body: Obx(() {
          return ListView.separated(
            controller: _.scrollController,
            addAutomaticKeepAlives: false,
            shrinkWrap: true,
            reverse: true,
            separatorBuilder: (BuildContext context, int i) {
              final NIMMessage message = _.messageList.reversed.elementAt(i);
              final int timestamp = message.timestamp == 0
                  ? DateTime.now().millisecondsSinceEpoch
                  : message.timestamp;

              final bool showTime = i == _.messageList.length - 1
                  ? true
                  : (((timestamp - _.messageList[i + 1].timestamp)).abs() >
                          5 * 60 * 1000)
                      ? true
                      : false;
              return !showTime
                  ? const SizedBox.shrink()
                  : Center(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 68.w),
                        height: 18.h,
                        margin: EdgeInsets.symmetric(vertical: 32.w),
                        decoration: BoxDecoration(
                            color: const Color(0xFF646363).withOpacity(.11),
                            borderRadius: BorderRadius.circular(9.r)),
                        alignment: Alignment.center,
                        child: Text(
                          formdatDateTime(
                              DateTime.fromMillisecondsSinceEpoch(timestamp)),
                          style: TextStyle(
                            color: const Color(0xFF959595),
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    );
            },
            padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 96.h),
            itemBuilder: (BuildContext context, int index) {
              final NIMMessage message =
                  _.messageList.reversed.elementAt(index);
              Log.d(message.toMap().toString());
              final bool isMe = message.fromAccount == _.yxAccid;
              return ChatMessageCard(
                  isMe: isMe,
                  avatar: isMe
                      ? '${_.user?.icon}'
                      : '${_.conversation.nimUser?.avatar}',
                  message: message);
            },
            itemCount: _.messageList.length,
          );
        }),
        bottomSheet: ChatBottomInputField(
          onSubmitted: _.sendMessage,
          onImagePicked: _.sendImage,
          onVideoPicked: _.sendVideo,
        ),
      );
    });
  }
}