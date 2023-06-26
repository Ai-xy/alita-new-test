import 'dart:convert';

import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/api/user_api.dart';
import 'package:alita/enum/app_gender.dart';
import 'package:alita/model/ui/app_conversation_model.dart';
import 'package:alita/model/ui/profile_tile_model.dart';
import 'package:alita/pages/anchor_profile/anchor_profile_controller.dart';
import 'package:alita/pages/follow/widgets/moment_card.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/util/toast.dart';
import 'package:alita/widgets/app_button.dart';
import 'package:alita/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:nim_core/nim_core.dart';

class AnchorProfilePage extends GetView<AnchorProfileController> {
  const AnchorProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _reportDialog(controller);
            },
          ),
        ],
      ),
      body: GetBuilder<AnchorProfileController>(builder: (_) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(249, 249, 249, 1)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    userBgImg(_),
                    userInfo(_),
                    aboutYou(_),
                    follow(_),
                    dynamic(_),
                  ],
                ),
              ),
            ),
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _.isMe ? Container() : followAndMessage(_))
          ],
        );
      }),
    );
  }

  /// 背景板
  Widget userBgImg(AnchorProfileController controller) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 220.w,
          child: controller.userDetail?.pics.length == 0
              ? Image.asset(
                  AppIcon.userProfileBg.uri,
                  fit: BoxFit.cover,
                )
              : AppImage(
                  '${controller.userDetail?.pics[0].url}',
                  fit: BoxFit.cover,
                ),
        ),
        Positioned(
            right: 16.w,
            bottom: 16.w,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.5),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: !controller.isMe
                  ? GestureDetector(
                      onTap: () {
                        controller.queryAuthorLiveRoomInfo(
                            controller.userInfo!.userId!);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            AppIcon.living.uri,
                            width: 18.r,
                            height: 18.r,
                          ),
                          Gap(4.w),
                          Text(
                            'Live',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColor.white,
                            ),
                          ),
                          Gap(8.w),
                        ],
                      ),
                    )
                  : Container(),
            ))
      ],
    );
  }

  /// 用户信息
  Widget userInfo(AnchorProfileController controller) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 23.w, 16.w, 13.w),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color.fromRGBO(254, 166, 35, 1),
                width: 2.w,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.r),
              child: AppImage(
                '${controller.userInfo?.icon}',
                width: 64.r,
                height: 64.r,
                borderRadius: BorderRadius.circular(16.r),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(18.w, 15.w, 0.0, 7.w),
                child: Row(
                  children: [
                    Text(
                      controller.getCountryEmojiByName(
                          '${controller.userInfo?.countryId}'),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF989898),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(
                        '${controller.userInfo?.nickname}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromRGBO(51, 51, 51, 1),
                        ),
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(30, 231, 129, 1),
                          borderRadius: BorderRadius.circular(9.r),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 1.w, horizontal: 8.w),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 2.w),
                              width: 4.w,
                              height: 4.w,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(
                              'Online',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),

              /// ID
              Padding(
                padding: EdgeInsets.fromLTRB(18.w, 0.0, 0.0, 12.w),
                child: Row(
                  children: [
                    Text(
                      'ID : ${controller.userInfo?.userId}',
                      style: TextStyle(
                          color: const Color.fromRGBO(152, 152, 152, 1),
                          fontSize: 14.sp),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 10.w),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 141, 167, 1),
                          borderRadius: BorderRadius.circular(9.r),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 1.w, horizontal: 8.w),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.all(2.w),
                              width: 10.w,
                              height: 10.w,
                              child: Image.asset(
                                controller.userInfo?.gender == 1
                                    ? AppGender.male.icon.uri
                                    : AppGender.female.icon.uri,
                                color: AppColor.white,
                                width: 12.r,
                                height: 12.r,
                              ),
                            ),
                            Text(
                              '${controller.userInfo?.age}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  /// about you
  Widget aboutYou(AnchorProfileController controller) {
    return Padding(
        padding: EdgeInsets.only(left: 16.w, bottom: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About you',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: EdgeInsets.only(top: 6.w, right: 16.w),
              child: Text(
                '${controller.userInfo?.signature == '' ? 'No more introduction yet...' : controller.userInfo?.signature}',
                style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color.fromRGBO(152, 152, 152, 1)),
              ),
            ),
          ],
        ));
  }

  /// 关注
  Widget follow(AnchorProfileController controller) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      for (ProfileTileModel item in [
        ProfileTileModel(
            label: AppMessage.followers.tr,
            value: '${controller.userInfo?.fansNum}'),
        ProfileTileModel(
            label: AppMessage.following.tr,
            value: '${controller.userInfo?.upsNum}'),
        ProfileTileModel(
            label: AppMessage.friends.tr,
            value: '${controller.userInfo?.friendNum}'),
      ])
        Container(
          color: const Color.fromRGBO(112, 112, 112, .02),
          padding: EdgeInsets.fromLTRB(26.w, 14.w, 26.w, 17.w),
          child: Column(
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
          ),
        )
    ]);
  }

  /// 动态
  Widget dynamic(AnchorProfileController controller) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Text(
                  'Dynamic',
                  style: TextStyle(
                      fontSize: 20.sp,
                      color: const Color.fromRGBO(52, 52, 52, 1),
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  width: 36.w,
                  height: 4.w,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(254, 166, 35, 1),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                )
              ],
            ),
          ),
          controller.momentList.isEmpty
              ? Container(
                  height: 222.h,
                  padding: EdgeInsets.only(
                      left: 16.w, right: 16.w, top: 8.h, bottom: 12.h),
                  child: Text(
                    'Nothing was left~',
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color.fromRGBO(152, 152, 152, 1)),
                  ),
                )
              : Center(
                  child: ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    padding: EdgeInsets.only(bottom: 10.h),
                    separatorBuilder: (BuildContext context, int i) {
                      return Gap(10.h);
                    },
                    itemBuilder: (BuildContext context, int i) {
                      return MomentCard(
                          moment: controller.momentList[i],
                          anchorProfileController: controller,
                          isMe: controller.userInfo?.userId ==
                              controller.user?.userId);
                    },
                    itemCount: controller.momentList.length,
                  ),
                ),
        ],
      ),
    );
  }

  /// 关注发消息按钮
  Widget followAndMessage(AnchorProfileController controller) {
    return Container(
      margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 43.w),
      child: Row(
        children: [
          Expanded(
              child: controller.isFollowed
                  ? AppButton(
                      onTap: () {
                        controller.isFollowed
                            ? controller.unfollow()
                            : controller.follow();
                      },
                      text: ' Followed',
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
                    )
                  : AppButton(
                      width: 160.w,
                      text: AppMessage.follow.tr,
                      onTap: () {
                        controller.isFollowed
                            ? controller.unfollow()
                            : controller.follow();
                      },
                      withIcon: true,
                      icon: Image.asset(
                        AppIcon.anchorFollow.uri,
                        width: 20.r,
                        height: 20.r,
                        color: Colors.white,
                      ),
                    )),
          Gap(24.w),
          Expanded(
            child: AppButton(
              text: ' Message',
              onTap: () {
                Get.toNamed(AppPath.chat,
                    arguments: AppUserConversationModel(
                        nimUser: NIMUser(
                            avatar: controller.userInfo?.icon,
                            nick: controller.userInfo?.nickname),
                        session: NIMSession(
                          sessionId: '${controller.userInfo?.yxAccid}',
                          sessionType: NIMSessionType.p2p,
                          senderNickname: controller.userInfo?.nickname,
                        )),
                    preventDuplicates: false);
              },
              withIcon: true,
              icon: Image.asset(
                AppIcon.anchorMessage.uri,
                width: 20.r,
                height: 20.r,
              ),
            ),
          )
        ],
      ),
    );
  }

  // 举报弹窗
  Future _reportDialog(AnchorProfileController controller) async {
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
                Get.toNamed(AppPath.reportCommon,
                        arguments: controller.userInfo?.userId)
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
                UserApi.blockUser(
                    userId: controller.userInfo!.userId!,
                    yxId: controller.userInfo!.yxAccid!);
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
