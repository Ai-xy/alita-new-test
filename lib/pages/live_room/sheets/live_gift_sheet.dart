import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/R/app_text_style.dart';
import 'package:alita/api/live_api.dart';
import 'package:alita/base/base_app_controller.dart';
import 'package:alita/model/api/gift_model.dart';
import 'package:alita/model/api/live_room_model.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/widgets/app_button.dart';
import 'package:alita/widgets/app_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class _LiveGiftController extends BaseAppController {
  List<GiftModel> giftList = [];
  int selectedGiftNum = 1;
  final List<String> giftNumItems = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10'
  ];
  GiftModel selectedGift = GiftModel();

  @override
  void onInit() {
    LiveApi.getGiftList().then((value) {
      giftList = value;
      if (giftList.isNotEmpty) {
        selectedGift = giftList.first;
      }
    }).whenComplete(update);
    super.onInit();
  }

  void selectGift(GiftModel gift) {
    selectedGift = gift;
    update();
  }

  void selectGiftNum(int num) {
    selectedGiftNum = num;
    update();
  }

  // 送礼
  void sendGift(int targetUserID) {
    LiveApi.sendGift(selectedGift.id!, targetUserID, selectedGiftNum);
  }
}

class LiveGiftSheet extends StatelessWidget {
  final LiveRoomModel? liveRoom;
  const LiveGiftSheet({Key? key, this.liveRoom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HookBuilder(builder: (context) {
      useEffect(() {
        Get.put(_LiveGiftController(), permanent: true);
        return null;
      }, []);
      return GetBuilder<_LiveGiftController>(builder: (_) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r)),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColor.white,
            ),
            constraints: BoxConstraints(
              maxHeight: Get.height * .5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Gap(16.h),
                Container(
                  margin: EdgeInsets.only(left: 16.w),
                  child: Text(
                    AppMessage.hot.tr,
                    style: AppTextStyle.titleStyle,
                  ),
                ),
                Gap(1.h),
                Container(
                  width: 24.w,
                  height: 2.h,
                  margin: EdgeInsets.only(left: 20.w),
                  decoration: BoxDecoration(
                      color: AppColor.accentColor,
                      borderRadius: BorderRadius.circular(4.r)),
                ),
                GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                      left: 24.w, right: 24.w, top: 24.h, bottom: 32.h),
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  mainAxisSpacing: 10.r,
                  crossAxisSpacing: 10.r,
                  children: [
                    for (GiftModel gift in _.giftList)
                      GestureDetector(
                        onTap: () {
                          _.selectGift(gift);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: _.selectedGift.id == gift.id
                                    ? AppColor.accentColor
                                    : Colors.transparent,
                                width: 1.5),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Column(
                            children: [
                              Gap(6.h),
                              AppImage(
                                '${gift.giftImg}',
                                width: 48.r,
                                height: 48.r,
                                fit: BoxFit.fill,
                              ),
                              Text(
                                'x${gift.giftPrice}',
                                style: TextStyle(fontSize: 13.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                Row(
                  children: [
                    Gap(27.w),
                    Image.asset(
                      AppIcon.liveDiamond.uri,
                      width: 20.r,
                      height: 20.r,
                    ),
                    Gap(8.w),
                    Text(
                      '${_.user?.diamondNum ?? 0}',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    Image.asset(
                      AppIcon.rightArrow.uri,
                      width: 16.r,
                      height: 16.r,
                    ),
                    const Spacer(),
                    Container(
                      margin: EdgeInsets.only(right: 26.w),
                      height: 34.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.circular(17.r),
                      ),
                      child: Row(
                        children: [
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
                                        _.selectGiftNum(index + 1);
                                      },
                                      children: List<Widget>.generate(
                                          _.giftNumItems.length, (int index) {
                                        return Center(
                                          child: Text(_.giftNumItems[index]),
                                        );
                                      }),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Row(
                              children: [
                                Gap(24.w),
                                Text('${_.selectedGiftNum}'),
                                Gap(14.w),
                                Image.asset(
                                  AppIcon.downArrow.uri,
                                  width: 16.r,
                                  height: 16.r,
                                ),
                                Gap(10.w),
                              ],
                            ),
                          ),
                          AppButton(
                            onTap: () {
                              //TODO 送礼
                              _.sendGift(liveRoom!.homeownerId!);
                            },
                            width: 64.w,
                            height: 34.h,
                            text: AppMessage.send.tr,
                            borderRadius: BorderRadius.circular(17.r),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap(Get.mediaQuery.padding.bottom + 38.h),
              ],
            ),
          ),
        );
      });
    });
  }
}
