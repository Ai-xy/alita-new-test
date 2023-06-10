import 'dart:convert';
import 'dart:math';

import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_font.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/R/app_text_style.dart';
import 'package:alita/api/moment_api.dart';
import 'package:alita/base/base_app_future_controller.dart';
import 'package:alita/http/http.dart';
import 'package:alita/kit/app_date_time_kit.dart';
import 'package:alita/kit/app_nim_kit.dart';
import 'package:alita/model/api/dynamic_comment_model.dart';
import 'package:alita/model/api/moment_model.dart';
import 'package:alita/model/ui/app_gallery_model.dart';
import 'package:alita/pages/anchor_profile/anchor_profile_controller.dart';
import 'package:alita/pages/follow/follow_controller.dart';
import 'package:alita/pages/photo_viewer/photo_viewer_page.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/util/log.dart';
import 'package:alita/util/toast.dart';
import 'package:alita/widgets/app_bottom_input_field.dart';
import 'package:alita/widgets/app_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class _MomentController extends BaseAppFutureLoadStateController {
  final MomentModel moment;

  _MomentController({required this.moment});

  bool get liked => moment.likeFlag == 1;

  bool loading = false;

  String trans = '';

  @override
  Future loadData({Map? params}) {
    return MomentApi.getCommentList(momentId: '${moment.id}').then((value) {
      moment.commentList = (value ?? []).reversed.toList();
    }).whenComplete(update);
  }

  Future comment() {
    return Get.bottomSheet(AppBottomInputField(
      onSubmitted: (String s, {String? giftUrl, String? giftNum}) {
        return MomentApi.comment(content: s, momentId: '${moment.id}')
            .then((value) {
          moment.commentNum = (moment.commentNum ?? 0) + 1;
          moment.commentList = [
            ...moment.commentList,
            DynamicCommentModel(
                commentContent: s, nickname: '${user?.nickname}')
          ];
        }).whenComplete(update);
      },
    ));
  }

  Future like(int flag) {
    return MomentApi.likeMoment(momentId: '${moment.id}', like: flag)
        .then((value) {
      moment.likeFlag = !liked ? 0 : 1;
    }).whenComplete(update);
  }

  Future delete(String id) {
    return MomentApi.delete(id).then((value) {
      update();
      Get.back();
    }).whenComplete(update);
  }
}

class MomentCard extends StatelessWidget {
  final MomentModel moment;
  final AnchorProfileController? anchorProfileController;
  final FollowController? followController;
  final bool isMe; // 是否是个人主页的朋友圈
  const MomentCard(
      {Key? key,
      required this.moment,
      required this.isMe,
      this.anchorProfileController,
      this.followController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String tag = '${moment.id}';
    Random random = new Random();

    return HookBuilder(builder: (context) {
      useEffect(() {
        Get.lazyPut(() => _MomentController(moment: moment), tag: tag);
        return () {
          Get.delete<_MomentController>(force: true);
        };
      }, []);

      return GetBuilder<_MomentController>(
          tag: tag,
          builder: (_) {
            return Container(
              padding: EdgeInsets.only(
                  left: 16.w, right: 16.w, top: 8.h, bottom: 12.h),
              decoration: const BoxDecoration(
                color: AppColor.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppImage(
                        '${moment.icon}',
                        borderRadius: BorderRadius.circular(24.r),
                        width: 48.r,
                        height: 48.r,
                        fit: BoxFit.fill,
                      ),
                      Gap(10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${moment.nickname}',
                              style: AppTextStyle.bodyLarge,
                            ),
                            Gap(1.h),
                            Text(
                              formatTime(moment.createTime),
                              style: TextStyle(
                                  fontSize: 14.sp, color: AppColor.grey),
                            ),
                          ],
                        ),
                      ),
                      isMe
                          ? GestureDetector(
                              onTap: () {
                                _deleteMomentDialog(_, '${moment.id}');
                              },
                              child: const Icon(Icons.more_vert))
                          : Container(
                              padding: EdgeInsets.only(left: 4.w, right: 14.w),
                              height: 24.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                      color: AppColor.borderColor
                                          .withOpacity(.37))),
                              child: Row(
                                children: [
                                  Image.asset(
                                    AppIcon.living.uri,
                                    width: 18.r,
                                    height: 18.r,
                                  ),
                                  Gap(8.w),
                                  Text(
                                    AppMessage.live.tr,
                                    style: TextStyle(
                                        fontSize: 12.sp, color: AppColor.grey),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                  Gap(14.h),
                  Text('${moment.textContent}', style: AppTextStyle.bodyMedium),
                  _.trans == ''
                      ? Container()
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(6.w),
                            Container(
                              margin: EdgeInsets.only(bottom: 6.w),
                              height: 1,
                              color: const Color.fromRGBO(51, 51, 51, .2),
                            ),
                            Flexible(
                              child: Text(
                                _.trans,
                                style: TextStyle(
                                    fontSize: 14.sp, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                  Gap(9.h),
                  _.loading
                      ? SizedBox(
                          width: 14.r,
                          height: 14.r,
                          child: const CircularProgressIndicator())
                      : GestureDetector(
                          onTap: () async {
                            _.loading = true;
                            _.update();
                            await MomentApi.translate('${moment.textContent}')
                                .then((value) {
                              _.trans = value;
                              _.update();
                            }).whenComplete(() {
                              _.loading = false;
                              _.update();
                            });
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                AppIcon.translation.uri,
                                width: 14.r,
                                height: 14.r,
                              ),
                              Gap(2.w),
                              Text(
                                AppMessage.viewTranslations.tr,
                                style: TextStyle(
                                    fontSize: 12.sp, color: AppColor.lightBlue),
                              ),
                            ],
                          ),
                        ),
                  if (moment.imgUrls?.isNotEmpty == true) ...[
                    Gap(10.h),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10.w,
                        childAspectRatio: 136 / 108,
                      ),
                      itemBuilder: (BuildContext context, int i) {
                        final String url = '${moment.imgUrls?.elementAt(i)}';
                        int num = random.nextInt(900000) + 100000;
                        final String tag = '$num$i';
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PhotoViewPage(
                                initalIndex: i,
                                imageList: (moment.imgUrls ?? [])
                                    .map((e) => AppGalleryImageModel(
                                        tag: tag, url: url))
                                    .toList(),
                              ),
                            ));
                          },
                          child: Hero(
                            tag: tag,
                            child: AppImage(
                              url,
                              borderRadius: BorderRadius.circular(4.r),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                      itemCount: moment.imgUrls?.length ?? 0,
                    )
                  ],
                  Gap(16.h),
                  Row(
                    children: [
                      GestureDetector(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            HookBuilder(builder: (context) {
                              return GestureDetector(
                                onTap: () {
                                  int flag = moment.likeFlag!;
                                  if (flag == 0) {
                                    flag = 1;
                                  } else {
                                    flag = 0;
                                  }
                                  _.like(flag).then((value) {
                                    if (isMe) {
                                      anchorProfileController
                                          ?.loadMomentsData();
                                    } else {
                                      if (followController != null) {
                                        followController?.loadData();
                                      } else {}
                                    }
                                  });
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Image.asset(
                                  moment.likeFlag == 1
                                      ? AppIcon.thumbActive.uri
                                      : AppIcon.thumb.uri,
                                  width: 24.r,
                                  height: 24.r,
                                ),
                              );
                            }),
                            Gap(4.w),
                            Transform.translate(
                                offset: Offset(0, 0.5.h),
                                child: Text('${moment.likeNum}',
                                    style: AppTextStyle.bodyMedium)),
                          ],
                        ),
                      ),
                      Gap(30.w),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _.comment,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppIcon.comment.uri,
                              width: 24.r,
                              height: 24.r,
                            ),
                            Gap(4.w),
                            Transform.translate(
                                offset: Offset(0, 0.5.h),
                                child: Text('${_.moment.commentNum}',
                                    style: AppTextStyle.bodyMedium)),
                          ],
                        ),
                      )
                    ],
                  ),
                  if (_.moment.commentList.isNotEmpty) ...[
                    const Divider(
                      color: Color(0xFFE2E2E2),
                    ),
                    for (DynamicCommentModel item in _.moment.commentList)
                      Text.rich(TextSpan(
                          text: '${item.nickname} : ',
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: AppFontWeight.bold),
                          children: [
                            TextSpan(
                              text: '${item.commentContent}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColor.black.withOpacity(.5),
                                fontWeight: AppFontWeight.w400,
                              ),
                            ),
                          ]))
                  ]
                ],
              ),
            );
          });
    });
  }

  Future _deleteMomentDialog(_MomentController _, String id) async {
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
                _.delete(id).then((value) {
                  anchorProfileController?.loadMomentsData();
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.circular(22.w),
                ),
                padding:
                    EdgeInsets.symmetric(vertical: 14.w, horizontal: 137.w),
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: const Color.fromRGBO(255, 50, 94, 1),
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
