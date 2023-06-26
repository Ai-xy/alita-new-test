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

/// 房间内聊天信息

class AppChatRoomMessageBox<T extends AppChatRoomController>
    extends StatelessWidget {
  const AppChatRoomMessageBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(builder: (_) {
      return Container(
        alignment: Alignment.bottomCenter,
        width: 265.w,
        height: 0.36 * Get.height,
        child: Obx(() {
          return ListView.separated(
            separatorBuilder: (BuildContext context, int i) => Gap(10.h),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int i) {
              Log.i('Message长度==>${_.messageList.length}');

              if (i == 0) {
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
                    child: Text(
                      '请勿直播低俗，色情(包括儿童色情)、虐待、违反当地风俗习惯，侵权或违法内容，否则将被我们封停账号。',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color.fromRGBO(255, 141, 167, 1),
                      ),
                    ));
              } else if (i == 1) {
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
                      AppImage(
                        //_.userAvatar,
                        '${_.roomAuthorIcon}',
                        width: 32.r,
                        height: 32.r,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      Gap(12.w),
                      Text(
                        //'${_.user?.nickname}进入直播间',
                        '${_.roomAuthorNickName}进入直播间',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColor.white,
                        ),
                      )
                    ],
                  ),
                );
              } else {
                NIMChatroomMessage message = _.messageList[i - 2];
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
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      Container(
                        constraints: const BoxConstraints(
                          maxWidth: 80,
                        ),
                        child: Text(
                          '${message.remoteExtension?['nickname']}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color.fromRGBO(255, 141, 167, 1),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Gap(6.w),
                      Text(
                        '${message.content}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColor.white,
                        ),
                      ),
                      message.remoteExtension?['giftUrl'] != null
                          ? AppImage(
                              message.remoteExtension?['giftUrl'],
                              height: 40.w,
                              width: 40.w,
                            )
                          : Container(),
                      message.remoteExtension?['giftNum'] != null
                          ? Center(
                              child: Text(
                                'x${message.remoteExtension?['giftNum']}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColor.white,
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                );
              }
            },
            itemCount: _.messageList.length + 2,
          );
        }),
      );
    });
  }
}
