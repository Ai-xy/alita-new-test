import 'package:alita/R/app_color.dart';
import 'package:alita/util/log.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'create_moments_controller.dart';

class CreateMomentsView extends GetView<CreateMomentsController> {
  const CreateMomentsView({super.key});
  Color get bg => const Color.fromRGBO(249, 249, 249, 1);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateMomentsController>(builder: (_) {
      return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            _.showEmojiPicker = false;
            _.update();
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Posts details'),
              backgroundColor: bg,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  _showDialog(context);
                },
              ),
            ),
            body: body(_, context),
            bottomSheet: _.showEmojiPicker
                ? SizedBox(
                    height: 240.w,
                    child: EmojiPicker(
                      config: const Config(columns: 7, bgColor: AppColor.white),
                      textEditingController: _.textController,
                    ),
                  )
                : null,
          ));
    });
  }

  void _showDialog(BuildContext context) {
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
                      'Do you want to discard your current edits?',
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
                            Get.back();
                            Get.back();
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

  Widget body(CreateMomentsController logic, BuildContext context) =>
      SingleChildScrollView(
        child: Container(
          height: 600.w,
          color: bg,
          child: Column(
            children: [
              textInputBox(logic),
              imageInputBox(logic),
              releasedButton(logic)
            ],
          ),
        ),
      );

  // 输入框
  Widget textInputBox(CreateMomentsController logic) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 148.w,
                child: TextFormField(
                  controller: logic.textController,
                  obscureText: false,
                  decoration: const InputDecoration(
                    hintText: 'Enter what you want to say...',
                    hintStyle:
                        TextStyle(color: Color.fromRGBO(125, 125, 125, 1)),
                  ),
                  style: TextStyle(fontSize: 14.sp),
                  textAlign: TextAlign.start,
                  maxLines: 30,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 18.w, bottom: 11.w),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            logic.getImage();
                          },
                          child: SizedBox(
                            height: 16.w,
                            width: 16.w,
                            child: Image.asset(
                                'assets/images/icon_add_moments_img.png'),
                          ),
                        ),
                        Gap(14.w),
                        GestureDetector(
                          onTap: () {
                            controller.showEmojiPicker =
                                !controller.showEmojiPicker;
                            controller.update();
                          },
                          child: SizedBox(
                            height: 16.w,
                            width: 16.w,
                            child: Image.asset(
                                'assets/images/icon_add_moments_emoji.png'),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20.w, bottom: 11.w),
                    child: Text('${logic.textLength}/500',
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                            color: Color.fromRGBO(125, 125, 125, 1))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 图片
  Widget imageInputBox(CreateMomentsController logic) {
    return SizedBox(
        height: 180.w,
        child: GridView.builder(
          padding: EdgeInsets.all(16.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12.0.w,
            crossAxisSpacing: 12.0.w,
          ),
          primary: false,
          itemCount: (logic.imgList?.length)! + 1,
          itemBuilder: (BuildContext context, int index) {
            int len = logic.imgList!.length;
            if (index < len) {
              return imageBox(logic, index);
            } else {
              if (len == 3) {
                return Container();
              }
              return noImageBox(logic);
            }
          },
        ));
  }

  // 没有图片时的添加按钮
  Widget noImageBox(CreateMomentsController logic) {
    return GestureDetector(
      onTap: () {
        logic.getImage();
      },
      child: SizedBox(
        height: 72.w,
        width: 72.w,
        child: Image.asset('assets/images/icon_add_img.png'),
      ),
    );
  }

  // 添加的图片
  Widget imageBox(CreateMomentsController logic, int index) {
    return Stack(children: [
      SizedBox(
          height: 120.w,
          width: 120.w,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8.w),
              child: Image.network('${logic.imgList?[index]}',
                  fit: BoxFit.cover))),
      Positioned(
        top: 0,
        right: 0,
        child: GestureDetector(
          onTap: () {
            logic.imgList?.removeAt(index);
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

  // 按钮
  Widget releasedButton(CreateMomentsController logic) {
    return GestureDetector(
      onTap: () {
        logic.release();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.w),
            color: const Color.fromRGBO(32, 32, 32, 1)),
        child: SizedBox(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.w),
            child: Center(
              child: Text(
                'Release',
                style: TextStyle(
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 16.sp),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
