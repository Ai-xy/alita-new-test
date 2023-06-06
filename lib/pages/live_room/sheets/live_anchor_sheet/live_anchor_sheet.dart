import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_font.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/enum/app_gender.dart';
import 'package:alita/model/api/live_room_model.dart';
import 'package:alita/model/ui/app_live_action_model.dart';
import 'package:alita/model/ui/app_live_room_model.dart';
import 'package:alita/model/ui/profile_tile_model.dart';
import 'package:alita/pages/home/country_service.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/util/log.dart';
import 'package:alita/util/toast.dart';
import 'package:alita/widgets/app_bottom_sheet.dart';
import 'package:alita/widgets/app_button.dart';
import 'package:alita/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'live_anchor_sheet_cotroller.dart';

/// 直播间点击用户信息弹窗
class LiveAnchorSheet extends GetView<LiveAnchorSheetController> {
  final LiveRoomModel? liveRoom;
  final int? userId;
  final bool? isRoomOwner;
  LiveAnchorSheet({Key? key, this.liveRoom, this.userId, this.isRoomOwner})
      : super(key: key);

  final LiveAnchorSheetController mController =
      Get.put(LiveAnchorSheetController());

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
        child: GetBuilder<LiveAnchorSheetController>(
      initState: (_) {
        mController.getUserInfo(userId, liveRoom);
        mController.loadData();
      },
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _.isMe
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          _showDialog(_);
                        },
                        child: Image.asset(
                          AppIcon.anchorReport.uri,
                          width: 20.r,
                          height: 20.r,
                        ),
                      ),
                Gap(27.w),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.accentColor),
                borderRadius: BorderRadius.circular(37.r),
              ),
              padding: EdgeInsets.all(5.r),
              child: AppImage(
                '${_.liveRoomUser?.icon}',
                width: 64.r,
                height: 64.r,
                fit: BoxFit.fill,
                borderRadius: BorderRadius.circular(32.r),
              ),
            ),
            Gap(6.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _.liveRoomUser?.nickname ?? 'Frederick',
                  style: TextStyle(
                      fontSize: 16.sp, fontWeight: AppFontWeight.bold),
                ),
                Gap(9.w),
                Container(
                  width: 48.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: _.liveRoomUser?.gender == 1
                        ? AppGender.male.color
                        : AppGender.female.color,
                  ),
                  alignment: Alignment.center,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          _.liveRoomUser?.gender == 1
                              ? AppGender.male.icon.uri
                              : AppGender.female.icon.uri,
                          color: AppColor.white,
                          width: 12.r,
                          height: 12.r,
                        ),
                        Gap(4.w),
                        Text(
                          '${_.liveRoomUser?.age ?? 14}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColor.white,
                          ),
                        ),
                      ]),
                )
              ],
            ),
            Gap(5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ID : ${_.liveRoomUser?.userId}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF989898),
                  ),
                ),
                Gap(5.w),
                Text(
                  _.getCountryEmojiByName('${_.liveRoomUser?.countryId}'),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF989898),
                  ),
                ),
              ],
            ),
            Gap(32.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (ProfileTileModel item in [
                    ProfileTileModel(
                        label: AppMessage.followers.tr,
                        value: '${_.liveRoomUser?.fansNum}'),
                    ProfileTileModel(
                        label: AppMessage.following.tr,
                        value: '${_.liveRoomUser?.upsNum}'),
                    ProfileTileModel(
                        label: AppMessage.friends.tr,
                        value: '${_.liveRoomUser?.friendNum}'),
                  ])
                    Column(
                      children: [
                        Text(
                          '${item.value}',
                          style: TextStyle(
                            fontSize: 16.sp,
                          ),
                        ),
                        Gap(4.h),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColor.black.withOpacity(.5),
                          ),
                        )
                      ],
                    )
                ],
              ),
            ),
            Gap(18.h),

            /// 拉黑、禁言、踢出房间
            Container(
              margin: EdgeInsets.symmetric(horizontal: 42.w),
              child: _.isMe
                  ? Container()
                  : _.user?.userId == liveRoom?.homeownerId
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            for (AppLiveActionModel action in [
                              AppLiveActionModel(
                                  icon: AppIcon.userBlock.uri,
                                  label: '',
                                  onTap: () {
                                    _
                                        .blockUser(true)
                                        .then((value) => Get.back());
                                  }),
                              AppLiveActionModel(
                                  icon: AppIcon.userMute.uri,
                                  label: '',
                                  onTap: () {
                                    _
                                        .muteAnchorTemp()
                                        .then((value) => Get.back());
                                  }),
                              AppLiveActionModel(
                                  icon: AppIcon.userFollow.uri,
                                  label: '',
                                  onTap: () {
                                    _
                                        .kickOutAnchor()
                                        .then((value) => Get.back());
                                  }),
                            ])
                              GestureDetector(
                                onTap: action.onTap,
                                child: Image.asset(
                                  action.icon,
                                  width: 48.r,
                                  height: 48.r,
                                ),
                              )
                          ],
                        )
                      : Container(),
              // child: _.user?.userId == liveRoom?.homeownerId
              //     ? _.isMe
              //         ? Container()
              //         : Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceAround,
              //             children: [
              //               for (AppLiveActionModel action in [
              //                 AppLiveActionModel(
              //                     icon: AppIcon.userBlock.uri,
              //                     label: '',
              //                     onTap: () {
              //                       _
              //                           .blockUser(true)
              //                           .then((value) => Get.back());
              //                     }),
              //                 AppLiveActionModel(
              //                     icon: AppIcon.userMute.uri,
              //                     label: '',
              //                     onTap: () {
              //                       _
              //                           .muteAnchorTemp()
              //                           .then((value) => Get.back());
              //                     }),
              //                 AppLiveActionModel(
              //                     icon: AppIcon.userFollow.uri,
              //                     label: '',
              //                     onTap: () {
              //                       _
              //                           .kickOutAnchor()
              //                           .then((value) => Get.back());
              //                     }),
              //               ])
              //                 GestureDetector(
              //                   onTap: action.onTap,
              //                   child: Image.asset(
              //                     action.icon,
              //                     width: 48.r,
              //                     height: 48.r,
              //                   ),
              //                 )
              //             ],
              //           )
              //     : Container(),
            ),
            Gap(24.h),
            _.isMe
                ? Container()
                : Container(
                    margin:
                        EdgeInsets.only(left: 16.w, right: 16.w, bottom: 23.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            onTap: () {
                              _.isFollowed
                                  ? AppToast.alert(
                                      message: 'You\'re already friends')
                                  : _.follow();
                            },
                            text: ' Follow',
                            textStyle: TextStyle(
                                color: const Color.fromRGBO(254, 166, 35, 1),
                                fontSize: 16.sp),
                            color: AppColor.accentColor.withOpacity(.39),
                            withIcon: true,
                            icon: Image.asset(
                              AppIcon.anchorFollow.uri,
                              width: 20.r,
                              height: 20.r,
                            ),
                          ),
                        ),
                        Gap(24.w),
                        Expanded(
                          child: AppButton(
                            text: ' HomePage',
                            onTap: () {
                              Get.toNamed(AppPath.anchorProfile,
                                  arguments: _.liveRoomUser);
                            },
                            withIcon: true,
                            icon: Image.asset(
                              AppIcon.home.uri,
                              width: 20.r,
                              height: 20.r,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
          ],
        );
      },
    ));
  }

  void _showDialog(LiveAnchorSheetController controller) {
    Get.dialog(Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(left: 20.w, right: 20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20).r,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(47.w, 38.w, 47.w, 40.w),
                    child: Text(
                      'Do you want to report this user?',
                      style: TextStyle(
                          color: const Color.fromRGBO(51, 51, 51, 1),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 40.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(236, 236, 237, 1),
                              borderRadius: BorderRadius.circular(24.w),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 12.w, horizontal: 40.w),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: const Color.fromRGBO(32, 32, 32, .5),
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                        Gap(14.w),
                        GestureDetector(
                          onTap: () {
                            controller.reportAuthor();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(254, 166, 35, 1),
                              borderRadius: BorderRadius.circular(20.w),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 12.w, horizontal: 40.w),
                            child: Text(
                              'Confirm',
                              style: TextStyle(
                                color: const Color.fromRGBO(255, 255, 255, 1),
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
