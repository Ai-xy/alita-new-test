import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/pages/live_room/sheets/live_anchor_sheet/live_anchor_sheet.dart';
import 'package:alita/pages/live_room/sheets/live_watcher_sheet.dart';
import 'package:alita/widgets/app_chatroom/app_chatroom_controller.dart';
import 'package:alita/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:nim_core/nim_core.dart';

/// 直播间左上角房间信息
class AppChatRoomWatcherTile<T extends AppChatRoomController>
    extends StatelessWidget {
  final Function() onClose;
  const AppChatRoomWatcherTile({Key? key, required this.onClose})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(builder: (_) {
      return SizedBox(
        width: Get.width - 30.w,
        child: Row(
          children: [
            Container(
              width: 182.w,
              padding: EdgeInsets.all(5.r),
              decoration: BoxDecoration(
                color: AppColor.white.withOpacity(.2),
                borderRadius: BorderRadius.circular(26.r),
              ),
              child: Row(
                children: [
                  /// 点击头像弹窗
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Get.bottomSheet(LiveAnchorSheet(
                        liveRoom: _.liveRoom,
                        userId: _.liveRoom.homeownerId,
                      ));
                    },
                    child: AppImage(
                      '${_.liveRoom.homeownerIcon}',
                      width: 32.r,
                      height: 32.r,
                      borderRadius: BorderRadius.circular(16.r),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Gap(6.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_.liveRoom.liveRoomName}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColor.white,
                        ),
                      ),
                      Gap(2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            AppIcon.liveHot.uri,
                            height: 12.h,
                          ),
                          Gap(4.w),
                          Text(
                            '${_.liveRoom.sentiment}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColor.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Image.asset(
                    AppIcon.follow.uri,
                    height: 32.h,
                  ),
                ],
              ),
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                for (NIMChatroomMember item in _.chatroomMemberList)
                  Container(
                    margin: EdgeInsets.only(right: 5.w),
                    child: AppImage(
                      '${item.avatar}',
                      width: 24.r,
                      height: 24.r,
                      borderRadius: BorderRadius.circular(12.r),
                      fit: BoxFit.cover,
                    ),
                  ),
                if (_.chatroomMemberList.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(LiveWatcherSheet(
                        memberList: _.chatroomMemberList,
                        count: _.memberNum.value,
                      ));
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      height: 24.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: AppColor.white.withOpacity(.2),
                          borderRadius: BorderRadius.circular(18.r)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Obx(() {
                        return Text('${_.memberNum.value}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColor.white,
                            ));
                      }),
                    ),
                  ),
                GestureDetector(
                  onTap: onClose,
                  behavior: HitTestBehavior.opaque,
                  child: Image.asset(
                    AppIcon.liveClose.uri,
                    width: 24.r,
                  ),
                ),
              ],
            ))
          ],
        ),
      );
    });
  }
}
