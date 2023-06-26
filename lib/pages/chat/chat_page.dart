import 'dart:convert';

import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/api/user_api.dart';
import 'package:alita/kit/app_date_time_kit.dart';
import 'package:alita/pages/chat/chat_controller.dart';
import 'package:alita/pages/chat/widgets/chat_bottom_input_field/chat_bottom_input_field.dart';
import 'package:alita/pages/chat/widgets/chat_message_card.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/translation/app_translation.dart';
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
            title: Text(_.conversation.nimUser?.nick == ''
                ? AppMessage.officalNotice.tr
                : '${_.conversation.nimUser?.nick}' == 'null'
                    ? 'Official Notice'
                    : '${_.conversation.nimUser?.nick}'),
            actions:
                _.conversation.session.lastMessageType != NIMMessageType.tip
                    ? [
                        _.isFollowed == true
                            ? Container()
                            : IconButton(
                                onPressed: () {
                                  _.follow();
                                },
                                icon: Image.asset(
                                  AppIcon.addFriend.uri,
                                  width: 42.w,
                                  height: 24.h,
                                ),
                              ),
                        IconButton(
                          onPressed: () {
                            _reportDialog(_);
                          },
                          icon: Image.asset(
                            AppIcon.more.uri,
                            width: 5.w,
                            height: 20.h,
                          ),
                        ),
                      ]
                    : [],
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
                    ? DateTime.now().microsecond
                    : message.timestamp;

                final bool showTime = i == _.messageList.length - 1
                    ? true
                    : (((timestamp -
                                    _.messageList.reversed
                                        .elementAt(i + 1)
                                        .timestamp))
                                .abs() >
                            5 * 60 * 1000)
                        ? true
                        : false;
                return !showTime
                    ? const SizedBox.shrink()
                    : Center(
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 88.w),
                          height: 18.h,
                          margin: EdgeInsets.only(top: 32.w),
                          decoration: BoxDecoration(
                              color: const Color(0xFF646363).withOpacity(.11),
                              borderRadius: BorderRadius.circular(9.r)),
                          alignment: Alignment.center,
                          child: Text(
                            _.timeFormat(timestamp),
                            // formdatDateTime(
                            //     DateTime.fromMillisecondsSinceEpoch(timestamp)),
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
                    controller: _,
                    isMe: isMe,
                    avatar: isMe
                        ? '${_.user?.icon}'
                        : '${_.conversation.nimUser?.avatar}',
                    message: message);
              },
              itemCount: _.messageList.length,
            );
          }),
          bottomSheet: Visibility(
            visible:
                _.conversation.session.lastMessageType != NIMMessageType.tip,
            child: ChatBottomInputField(
              onSubmitted: _.sendMessage,
              onImagePicked: _.sendImage,
              onVideoPicked: _.sendVideo,
            ),
          ));
    });
  }

  // 举报弹窗
  Future _reportDialog(ChatController controller) async {
    Map<String, dynamic> extension =
        jsonDecode(controller.conversation.nimUser?.toMap()['extension']);
    print('举报弹${extension}');
    int usId = int.parse('${extension['userId']}');
    String yxId = extension['yxAccid'];
    Get.dialog(Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Get.toNamed(AppPath.reportCommon, arguments: usId)
                    ?.then((value) => Get.back());
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.circular(22.w),
                ),
                padding:
                    EdgeInsets.symmetric(vertical: 14.w, horizontal: 137.w),
                child: Text(
                  'Report',
                  style: TextStyle(
                    color: const Color.fromRGBO(32, 32, 32, 1),
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),

            /// block
            GestureDetector(
              onTap: () {
                UserApi.blockUser(userId: usId, yxId: yxId);
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 12.w, 0, 0),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.circular(22.w),
                ),
                padding:
                    EdgeInsets.symmetric(vertical: 14.w, horizontal: 137.w),
                child: Text(
                  ' Block ',
                  style: TextStyle(
                    color: const Color.fromRGBO(32, 32, 32, 1),
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 12.w, 0, 25.w),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(254, 166, 35, 1),
                  borderRadius: BorderRadius.circular(22.w),
                ),
                padding:
                    EdgeInsets.symmetric(vertical: 14.w, horizontal: 137.w),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
