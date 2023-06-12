import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/R/app_text_style.dart';
import 'package:alita/base/base_app_future_controller.dart';
import 'package:alita/pages/live_list/live_list_controller.dart';
import 'package:alita/pages/live_list/widgets/live_room_card.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class LiveListPage extends StatelessWidget {
  const LiveListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppFutureBuilder<LiveListController>(builder: (_) {
      return DefaultTabController(
        length: _.tagList.length,
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(106.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    Gap(54.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppMessage.yonoLive.tr,
                          style: AppTextStyle.titleStyle,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppPath.sessionList);
                          },
                          child: Transform.scale(
                            scale: 1.5,
                            child: Image.asset(
                              AppIcon.message.uri,
                              width: 28.r,
                              height: 28.r,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(18.h),
                    SizedBox(
                      height: 30.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (BuildContext context, int i) {
                          return Gap(12.w);
                        },
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext context, int i) {
                          return Container(
                            constraints: BoxConstraints(
                              minWidth: 75.w,
                            ),
                            decoration: BoxDecoration(
                                color: AppColor.accentColor,
                                borderRadius: BorderRadius.circular(15.r)),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 18.w),
                            child: Text(
                              '${_.tagList[0].tagName}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColor.white,
                              ),
                            ),
                          );
                        },
                        itemCount: 1 ?? _.tagList.length,
                      ),
                    )
                  ],
                ),
              )),
          body: RefreshIndicator(
            onRefresh: () {
              return _.loadData();
            },
            child: MasonryGridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              crossAxisSpacing: 11.w,
              mainAxisSpacing: 13.h,
              gridDelegate:
                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (BuildContext context, int i) {
                return LiveRoomCard(
                  liveRoom: _.liveRoomList[i],
                  height: i.isEven ? 153.h : 186.h,
                );
              },
              itemCount: _.liveRoomList.length,
            ),
          ),
        ),
      );
    });
  }
}
