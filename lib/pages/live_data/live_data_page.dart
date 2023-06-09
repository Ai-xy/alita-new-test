import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_font.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'live_data_controller.dart';

class LiveDataPage extends StatelessWidget {
  const LiveDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppMessage.data.tr)),
      body: GetBuilder<LiveDataController>(builder: (_) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Gap(20.h),
              GestureDetector(
                onTap: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 300.w,
                        child: CupertinoPicker(
                          backgroundColor: Colors.white,
                          itemExtent: 50.0,
                          onSelectedItemChanged: (int index) {
                            _.selectIndex = index;
                            _.selectDate = _.dateList[index];
                            _.update();
                          },
                          children: List<Widget>.generate(_.dateItems.length,
                              (int index) {
                            return Center(
                              child: Text(_.dateItems[index]),
                            );
                          }),
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  children: [
                    Gap(7.w),
                    Text(
                      _.selectDate,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColor.bodyText2Color,
                      ),
                    ),
                    Gap(2.w),
                    Image.asset(
                      AppIcon.expandMore.uri,
                      width: 14.r,
                      height: 14.r,
                    ),
                  ],
                ),
              ),
              Gap(15.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Image.asset(AppIcon.dataIncomeKongoBackground.uri),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _.incomeList.isNotEmpty
                                      ? '${_.incomeList[_.selectIndex]}'
                                      : '',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                    fontWeight: AppFontWeight.bold,
                                  ),
                                ),
                                Gap(7.h),
                                Text(
                                  AppMessage.income.tr,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.white,
                                    fontWeight: AppFontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Gap(15.w),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Image.asset(AppIcon.dataDurationKongoBackground.uri),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _.durationList.isNotEmpty
                                      ? '${_.durationList[_.selectIndex]}'
                                      : '10h21m31s',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                    fontWeight: AppFontWeight.bold,
                                  ),
                                ),
                                Gap(7.h),
                                Text(
                                  AppMessage.liveBroadcastDuration.tr,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.white,
                                    fontWeight: AppFontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
