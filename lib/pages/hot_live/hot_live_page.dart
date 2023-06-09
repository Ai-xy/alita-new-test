import 'package:alita/R/app_text_style.dart';
import 'package:alita/base/base_app_future_controller.dart';
import 'package:alita/pages/live_list/widgets/live_room_card.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'hot_live_controller.dart';

class HotLivePage extends StatelessWidget {
  const HotLivePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppFutureBuilder<HotLiveController>(builder: (_) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(106.h),
          child: Container(
            padding: EdgeInsets.only(top: 54.h, left: 16.w),
            height: 95.h,
            child: Text(
              AppMessage.popular.tr,
              style: AppTextStyle.titleStyle,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return _.loadData();
          },
          child: MasonryGridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            crossAxisSpacing: 11.w,
            mainAxisSpacing: 13.h,
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
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
      );
    });
  }
}
