import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_font.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/R/app_text_style.dart';
import 'package:alita/model/ui/profile_tile_model.dart';
import 'package:alita/pages/user_profile/user_profile_controller.dart';
import 'package:alita/pages/user_profile/widgets/user_profile_card.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserProfileController>(builder: (_) {
      return Stack(
        children: [
          Image.asset(AppIcon.meHeaderBackground.uri),
          Material(
            color: Colors.transparent,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              children: [
                Gap(44.h),
                Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Get.toNamed(AppPath.editProfile);
                      },
                      child: Transform.scale(
                        scale: 2.4,
                        child: Image.asset(
                          AppIcon.editProfile.uri,
                          width: 20.r,
                          height: 20.r,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Gap(20.w),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Get.toNamed(AppPath.aboutUs);
                      },
                      child: Transform.scale(
                        scale: 2.4,
                        child: Image.asset(
                          AppIcon.setting.uri,
                          width: 20.r,
                          height: 20.r,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(8.h),
                Row(
                  children: [
                    AppImage(
                      '${_.user?.icon}',
                      width: 68.r,
                      height: 68.r,
                      borderRadius: BorderRadius.circular(34.r),
                    ),
                    Gap(18.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_.user?.nickname}',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: AppFontWeight.bold,
                            ),
                            key: ValueKey(_.user?.nickname),
                          ),
                          Text(
                            'ID:${_.user?.userId}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColor.black.withOpacity(.5),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Gap(30.h),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Get.toNamed(AppPath.myFollowing);
                  },
                  child: Builder(builder: (context) {
                    final List<ProfileTileModel> tiles = [
                      ProfileTileModel(
                        label: AppMessage.followers.tr,
                        value: '${_.user?.fansNum}',
                      ),
                      ProfileTileModel(
                        label: AppMessage.following.tr,
                        value: '${_.user?.upsNum}',
                      ),
                      ProfileTileModel(
                        label: AppMessage.friends.tr,
                        value: '${_.user?.friendNum}',
                      ),
                    ];
                    return Row(
                      children: [
                        for (ProfileTileModel item in tiles)
                          Expanded(
                            child: Column(
                              children: [
                                Text('${item.value}',
                                    style: AppTextStyle.bodyLarge),
                                Gap(4.h),
                                Text(
                                  item.label,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: AppColor.black.withOpacity(.5),
                                  ),
                                ),
                              ],
                            ),
                          )
                      ],
                    );
                  }),
                ),
                Gap(24.h),
                Builder(builder: (context) {
                  final List<ProfileTileModel> tiles = [
                    ProfileTileModel(
                      label: AppMessage.myWallet.tr,
                      value: '${_.user?.diamondNum}',
                      icon: AppIcon.coin.uri,
                      backgroundImage: AppIcon.myWalletBackground.uri,
                    ),
                    ProfileTileModel(
                        label: AppMessage.userLevel.tr,
                        value: '${_.user?.level}',
                        icon: AppIcon.crown.uri,
                        backgroundImage: AppIcon.userLevelBackground.uri,
                        onTap: () {
                          Get.toNamed(AppPath.vip);
                        }),
                  ];
                  return Row(
                    children: [
                      for (ProfileTileModel item in tiles) ...[
                        Expanded(
                          child: GestureDetector(
                            onTap: item.onTap,
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              width: 164.w,
                              height: 80.h,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('${item.backgroundImage}'),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Gap(12.h),
                                  Container(
                                    margin: EdgeInsets.only(left: 20.w),
                                    child: Text(
                                      item.label,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColor.white,
                                      ),
                                    ),
                                  ),
                                  Gap(13.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        '${item.icon}',
                                        width: 22.r,
                                        height: 22.r,
                                      ),
                                      Gap(6.w),
                                      Text(
                                        '${item.value}',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: AppColor.white,
                                          fontWeight: AppFontWeight.bold,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (item == tiles.first) Gap(16.w)
                      ]
                    ],
                  );
                }),
                Gap(16.h),
                UserProfileCard(
                  padding: EdgeInsets.only(top: 14.h, left: 18.w, bottom: 18.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppMessage.me.tr,
                        style: AppTextStyle.bodyLarge,
                      ),
                      Gap(13.h),
                      Builder(builder: (context) {
                        final List<ProfileTileModel> tiles = [
                          ProfileTileModel(
                              label: AppMessage.messages.tr,
                              icon: AppIcon.myMessage.uri,
                              onTap: () {
                                Get.toNamed(AppPath.sessionList);
                              }),
                          ProfileTileModel(
                            label: AppMessage.knapsack.tr,
                            icon: AppIcon.myKnapsack.uri,
                          ),
                          ProfileTileModel(
                            label: AppMessage.signIn.tr,
                            icon: AppIcon.signIn.uri,
                          ),
                        ];
                        return Row(
                          children: [
                            for (ProfileTileModel item in tiles)
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: item.onTap,
                                child: Container(
                                  margin: EdgeInsets.only(right: 40.w),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        '${item.icon}',
                                        width: 40.r,
                                        height: 40.r,
                                      ),
                                      Gap(4.h),
                                      Text(
                                        item.label,
                                        style: AppTextStyle.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        );
                      })
                    ],
                  ),
                ),
                Gap(12.h),
                Builder(builder: (BuildContext context) {
                  final List<ProfileTileModel> tiles = [
                    ProfileTileModel(
                        label: AppMessage.anchorCenter.tr,
                        onTap: () {
                          Get.toNamed(AppPath.anchorProfile);
                        }),
                    ProfileTileModel(
                        label: AppMessage.officialCustomerService.tr),
                    ProfileTileModel(
                        label: AppMessage.problemFeedback.tr,
                        onTap: () {
                          Get.toNamed(AppPath.feedback);
                        }),
                  ];
                  return UserProfileCard(
                    padding: EdgeInsets.only(
                        top: 14.h, left: 20.w, bottom: 2.h, right: 18.w),
                    child: Column(
                      children: [
                        for (ProfileTileModel item in tiles)
                          GestureDetector(
                            onTap: item.onTap,
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 16.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.label,
                                    style: TextStyle(fontSize: 16.sp),
                                  ),
                                  Image.asset(
                                    AppIcon.next.uri,
                                    width: 24.r,
                                    height: 24.r,
                                    color: AppColor.lightGrey,
                                  ),
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                  );
                }),
              ],
            ),
          )
        ],
      );
    });
  }
}
