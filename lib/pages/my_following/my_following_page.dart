import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/enum/app_gender.dart';
import 'package:alita/model/api/user_friend_entity.dart';
import 'package:alita/model/ui/app_conversation_model.dart';
import 'package:alita/pages/my_following/my_following_controller.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/util/toast.dart';
import 'package:alita/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:nim_core/nim_core.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class MyFollowingPage extends StatelessWidget {
  const MyFollowingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyFollowingController>(builder: (_) {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
            backgroundColor: AppColor.white,
            appBar: AppBar(
              title: Text(AppMessage.following.tr),
              backgroundColor: AppColor.white,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(46.h),
                child: Container(
                  padding: EdgeInsets.all(3.r),
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    color: AppColor.scaffoldBackgroundColor,
                  ),
                  child: TabBar(
                    indicatorColor: Colors.green,
                    tabs: [
                      for (String item in [
                        AppMessage.following.tr,
                        AppMessage.friends.tr,
                        AppMessage.followers.tr
                      ])
                        Tab(text: item)
                    ],
                    labelColor: AppColor.black,
                    labelStyle: TextStyle(
                      fontSize: 16.sp,
                      color: AppColor.black,
                    ),
                    unselectedLabelColor: AppColor.black.withOpacity(.5),
                    unselectedLabelStyle: TextStyle(
                      fontSize: 16.sp,
                      color: AppColor.black.withOpacity(.5),
                    ),
                    indicator: RectangularIndicator(
                      bottomLeftRadius: 24.r,
                      bottomRightRadius: 24.r,
                      topLeftRadius: 24.r,
                      topRightRadius: 24.r,
                      paintingStyle: PaintingStyle.fill,
                      color: AppColor.white,
                    ),
                  ),
                ),
              ),
            ),
            body: TabBarView(children: [
              // for (String item in [
              //   AppMessage.following.tr,
              //   AppMessage.friends.tr,
              //   AppMessage.followers.tr
              // ])
              ListView.separated(
                padding: EdgeInsets.only(top: 24.h, left: 16.w, right: 16.w),
                separatorBuilder: (BuildContext context, int i) {
                  return Divider(
                    height: 32.h,
                  );
                },
                itemBuilder: (BuildContext context, int i) {
                  print(_.followUserList1[i].toJson());
                  return FollowItem(_.followUserList1[i], _);
                },
                itemCount: _.followUserList1.length,
              ),
              ListView.separated(
                padding: EdgeInsets.only(top: 24.h, left: 16.w, right: 16.w),
                separatorBuilder: (BuildContext context, int i) {
                  return Divider(
                    height: 32.h,
                  );
                },
                itemBuilder: (BuildContext context, int i) {
                  print(_.followUserList2[i].toJson());

                  return FollowItem(_.followUserList2[i], _);
                },
                itemCount: _.followUserList2.length,
              ),
              ListView.separated(
                padding: EdgeInsets.only(top: 24.h, left: 16.w, right: 16.w),
                separatorBuilder: (BuildContext context, int i) {
                  return Divider(
                    height: 32.h,
                  );
                },
                itemBuilder: (BuildContext context, int i) {
                  print(_.followUserList3[i].toJson());

                  return FollowItem(_.followUserList3[i], _);
                },
                itemCount: _.followUserList3.length,
              ),
            ])),
      );
    });
  }
}

Widget FollowItem(UserFriendEntity item, MyFollowingController controller) {
  return GestureDetector(
    onTap: () {
      // Get.toNamed(AppPath.chat,
      //     arguments: AppUserConversationModel(
      //         nimUser: NIMUser(avatar: item.icon, nick: item.nickname),
      //         session: NIMSession(
      //           sessionId: '${item.yxAccid}',
      //           sessionType: NIMSessionType.p2p,
      //           senderNickname: item.nickname,
      //         )),
      //     preventDuplicates: false);
    },
    child: Row(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50.r),
              child: AppImage(
                '${item.icon}',
                width: 48.r,
                height: 48.r,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 2.r,
              right: 4.r,
              child: Container(
                width: 8.r,
                height: 8.r,
                decoration: BoxDecoration(
                  color:
                      item.status == 1 ? Colors.green : AppGender.female.color,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            )
          ],
        ),
        Gap(10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${item.nickname}',
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
              Gap(2.h),
              Text(
                'Tx Male',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF959595),
                ),
              )
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            if (item.userId != null) {
              controller.queryAuthorLiveRoomInfo(item.userId!);
            } else {
              AppToast.alert(message: 'userId is null');
            }
          },
          child: Image.asset(
            AppIcon.followingLive.uri,
            width: 28.r,
            height: 28.r,
          ),
        ),
        Gap(18.w),
        item.followed == true
            ? GestureDetector(
                onTap: () {
                  if (item.userId != null) {
                    controller.unFollow(item.userId!);
                  }
                },
                child: Image.asset(
                  AppIcon.anchorLike.uri,
                  width: 28.r,
                  height: 28.r,
                ),
              )
            : GestureDetector(
                onTap: () {
                  if (item.userId != null) {
                    controller.follow(item.userId!);
                  }
                },
                child: Image.asset(
                  AppIcon.anchorUnLike.uri,
                  width: 28.r,
                  height: 28.r,
                ),
              ),
      ],
    ),
  );
}
