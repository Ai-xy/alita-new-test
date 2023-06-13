import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_font.dart';
import 'package:alita/pages/follow/follow_controller.dart';
import 'package:alita/pages/follow/widgets/moment_card.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/widgets/app_tabbar.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class FollowPage extends StatelessWidget {
  const FollowPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FollowController>(builder: (_) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(72.h),
            child: Container(
              margin: EdgeInsets.only(top: 54.h, bottom: 18.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  app.TabBar(
                    isScrollable: true,
                    tabs: [
                      app.AppTab(
                        text: AppMessage.follow.tr,
                      ),
                      app.AppTab(
                        text: AppMessage.dynamic.tr,
                      ),
                    ],
                    labelColor: AppColor.tabbarLabelColor,
                    indicatorSize: app.TabBarIndicatorSize.label,
                    indicatorColor: AppColor.accentColor,
                    unselectedLabelColor: AppColor.tabbarLabelColor,
                    labelStyle: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: AppFontWeight.bold,
                        color: AppColor.tabbarLabelColor),
                    unselectedLabelStyle: TextStyle(
                        fontSize: 14.sp, color: AppColor.tabbarLabelColor),
                    indicator: MaterialIndicator(
                      height: 4.r,
                      topLeftRadius: 4.r,
                      topRightRadius: 4.r,
                      bottomLeftRadius: 4.r,
                      bottomRightRadius: 4.r,
                      tabPosition: TabPosition.bottom,
                      color: AppColor.accentColor,
                    ),
                    indicatorPadding: EdgeInsets.symmetric(horizontal: 8.w),
                  ),
                  // 发布朋友圈按钮
                  // InkWell(
                  //   onTap: () {
                  //     Get.toNamed(AppPath.addMoments)?.then((value) {
                  //       if(value){
                  //         _.loadData();
                  //       }
                  //     });
                  //   },
                  //   child: Padding(
                  //     padding: EdgeInsets.only(right: 16.w),
                  //     child: const Icon(Icons.add),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
          body: TabBarView(
              children: List.generate(2, (index) {
            if (index == 0) {
              return RefreshIndicator(
                onRefresh: () {
                  return _.loadData();
                },
                child: ListView.separated(
                  padding: EdgeInsets.only(bottom: 10.h),
                  separatorBuilder: (BuildContext context, int i) {
                    return Gap(10.h);
                  },
                  itemBuilder: (BuildContext context, int i) {
                    if (_.momentList[i].followFlag == 0) {
                      return Container();
                    }
                    return MomentCard(
                      moment: _.momentList[i],
                      isMe: false,
                      followController: _,
                    );
                  },
                  itemCount: _.momentList.length,
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () {
                return _.loadData();
              },
              child: ListView.separated(
                padding: EdgeInsets.only(bottom: 10.h),
                separatorBuilder: (BuildContext context, int i) {
                  return Gap(10.h);
                },
                itemBuilder: (BuildContext context, int i) {
                  return MomentCard(
                    moment: _.momentList[i],
                    isMe: false,
                    followController: _,
                  );
                },
                itemCount: _.momentList.length,
              ),
            );
          })),
        ),
      );
    });
  }
}
