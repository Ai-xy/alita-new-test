import 'package:alita/R/app_color.dart';
import 'package:alita/model/ui/app_conversation_model.dart';
import 'package:alita/pages/live_room/sheets/live_anchor_sheet/live_anchor_sheet.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/util/log.dart';
import 'package:alita/widgets/app_chatroom/app_chatroom_controller.dart';
import 'package:alita/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:nim_core/nim_core.dart';

class AppChatRoomMessageBox<T extends AppChatRoomController>
    extends StatelessWidget {
  const AppChatRoomMessageBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(builder: (_) {
      return Container(
        alignment: Alignment.bottomCenter,
        width: 230.w,
        height: 0.36 * Get.height,
        child: Obx(() {
          return ListView.separated(
            separatorBuilder: (BuildContext context, int i) => Gap(10.h),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int i) {
              NIMChatroomMessage message = _.messageList[i];
              Log.i('Message==>${message.content}');
              Log.i('MessageMap==>${message.toMap()}');
              return Container(
                padding: EdgeInsets.only(
                  top: 5.h,
                  bottom: 5.h,
                  left: 7.w,
                  right: 7.w,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.2),
                  borderRadius: BorderRadius.circular(21.r),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        /// 点击直播间发送消息的用户信息
                        Get.bottomSheet(LiveAnchorSheet(
                          liveRoom: _.liveRoom,
                          userId: message.remoteExtension?['userId'],
                        ));
                        // Get.toNamed(AppPath.chat,
                        //     arguments: AppUserConversationModel(
                        //         nimUser: NIMUser(
                        //             avatar: message.remoteExtension?['avatar'],
                        //             nick: message.remoteExtension?['nickname']),
                        //         session: NIMSession(
                        //           sessionId: '${message.fromAccount}',
                        //           sessionType: NIMSessionType.p2p,
                        //           senderNickname:
                        //               message.remoteExtension?['nickname'],
                        //         )),
                        //     preventDuplicates: false);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: AppImage(
                        '${message.remoteExtension?['avatar']}',
                        width: 32.r,
                        height: 32.r,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    Gap(12.w),
                    Text(
                      '${message.content}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColor.white,
                      ),
                    )
                  ],
                ),
              );
            },
            itemCount: _.messageList.length,
          );
        }),
      );
    });
  }
}
