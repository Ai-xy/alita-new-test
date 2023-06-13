import 'package:alita/R/app_color.dart';
import 'package:alita/enum/app_report_type.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/widgets/app_button.dart';
import 'package:alita/widgets/app_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'report_common_controller.dart';

class ReportCommonPage extends StatelessWidget {
  const ReportCommonPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportCommonController>(builder: (_) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(title: Text(AppMessage.report.tr)),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  GridView.count(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 4,
                    children: [
                      for (AppReportType item in AppReportType.values)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppCheckBox(
                              onChanged: (_) {},
                            ),
                            Gap(8.w),
                            Text(
                              item.label.tr,
                              style: TextStyle(fontSize: 13.sp),
                            )
                          ],
                        ),
                    ],
                  ),
                  Gap(32.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: TextField(
                      controller: _.textReportController,
                      decoration: InputDecoration(
                        hintText: AppMessage.reportContentHint.tr,
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      maxLength: 200,
                      maxLines: 10,
                    ),
                  ),
                  Gap(48.h),
                  AppButton(
                    text: AppMessage.submit.tr,
                    color: AppColor.black,
                    onTap: () {
                      _.reportSubmit();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
