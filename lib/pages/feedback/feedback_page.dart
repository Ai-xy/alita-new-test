import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/enum/app_feedback_type.dart';
import 'package:alita/pages/feedback/feedback_controller.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/widgets/app_button.dart';
import 'package:alita/widgets/app_checkbox.dart';
import 'package:alita/widgets/app_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeedbackController>(builder: (_) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 取消现有的焦点
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: AppColor.white,
          appBar: AppBar(
            title: Text(AppMessage.feedback.tr),
            backgroundColor: AppColor.scaffoldBackgroundColor,
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                children: [
                  GridView.count(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 4,
                    children: [
                      for (AppFeedbackType item in AppFeedbackType.values)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppCheckBox(
                              onChanged: (_) {},
                            ),
                            Gap(8.w),
                            Text(
                              item.label.tr,
                              style: TextStyle(fontSize: 16.sp),
                            )
                          ],
                        ),
                    ],
                  ),
                  Gap(32.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: TextField(
                      onChanged: _.setContent,
                      controller: _.textSuggestionController,
                      decoration: InputDecoration(
                        hintText: AppMessage.enterFeedbackContentHint.tr,
                        fillColor: const Color(0xFFF9F9F9),
                        filled: true,
                      ),
                      maxLines: 10,
                    ),
                  ),
                  Gap(12.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: TextField(
                      onChanged: _.setEmail,
                      controller: _.textEmailController,
                      decoration: InputDecoration(
                        hintText: AppMessage.enterEmailHint.tr,
                        fillColor: const Color(0xFFF9F9F9),
                        filled: true,
                      ),
                    ),
                  ),
                  Gap(18.h),
                  // GridView.count(
                  //   shrinkWrap: true,
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   crossAxisCount: 3,
                  //   mainAxisSpacing: 12.r,
                  //   crossAxisSpacing: 12.r,
                  //   children: [
                  //     GestureDetector(
                  //       onTap: _.pickImages,
                  //       behavior: HitTestBehavior.opaque,
                  //       child: Image.asset(
                  //         AppIcon.uploadPhoto.uri,
                  //         width: 72.r,
                  //         height: 72.r,
                  //       ),
                  //     ),
                  //     for (String item in _.imageList)
                  //       AppImage(
                  //         item,
                  //         width: 72.r,
                  //         height: 72.r,
                  //         borderRadius: BorderRadius.circular(4.r),
                  //       )
                  //   ],
                  // ),
                  imageInputBox(_),
                  Gap(48.h),
                  AppButton(
                    text: AppMessage.submit.tr,
                    color: AppColor.black,
                    onTap: () {
                      _.submit();
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

  // 图片
  Widget imageInputBox(FeedbackController logic) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(right: 12.w),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12.r,
        crossAxisSpacing: 12.r,
      ),
      primary: false,
      itemCount: logic.imageList.length == 3 ? 3 : (logic.imageList.length) + 1,
      itemBuilder: (BuildContext context, int index) {
        int len = logic.imageList.length;
        if (index < len) {
          return imageBox(logic, index);
        } else {
          if (len == 3) {
            return Container();
          }
          return noImageBox(logic);
        }
      },
    );
  }

  // 没有图片时的添加按钮
  Widget noImageBox(FeedbackController logic) {
    return GestureDetector(
      onTap: () {
        logic.pickImages();
      },
      child: SizedBox(
        height: 72.w,
        width: 72.w,
        child: Image.asset('assets/images/icon_add.png'),
      ),
    );
  }

  // 添加的图片
  Widget imageBox(FeedbackController logic, int index) {
    return Stack(children: [
      SizedBox(
          height: 120.w,
          width: 120.w,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(4.w),
              child: Image.network(logic.imageList[index], fit: BoxFit.cover))),
      Positioned(
        top: 0,
        right: 0,
        child: GestureDetector(
          onTap: () {
            logic.imageList.removeAt(index);
            logic.update();
          },
          child: SizedBox(
              height: 14.w,
              width: 14.w,
              child: Image.asset('assets/images/icon_remove_img.png')),
        ),
      )
    ]);
  }
}
