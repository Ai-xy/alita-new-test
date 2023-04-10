import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/model/ui/profile_tile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ProfileCard extends StatelessWidget {
  final List<ProfileTileModel> tiles;
  const ProfileCard({Key? key, required this.tiles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          for (ProfileTileModel item in tiles)
            Container(
              margin: EdgeInsets.only(
                top: 12.h,
                bottom: item.widthDivider ? 0 : 12.h,
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColor.profileTileValueColor,
                ),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: item.onTap,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Gap(20.w),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppColor.bodyTextColor,
                            ),
                          ),
                          const Spacer(),
                          item.trailling,
                          Gap(1.w),
                          Image.asset(
                            AppIcon.profileNext.uri,
                            width: 24.r,
                            height: 24.r,
                          ),
                          Gap(18.w),
                        ],
                      ),
                      if (item.widthDivider) ...[
                        Gap(10.h),
                        const Divider(
                          thickness: 0,
                          height: 0,
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
