import 'package:alita/R/app_icon.dart';
import 'package:alita/model/api/user_friend_entity.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'block_list_user_center_controller.dart';

class UserCenterBlockListPage extends StatelessWidget {
  const UserCenterBlockListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppMessage.blockList.tr),
      ),
      body: GetBuilder<UserCenterBlockListController>(builder: (_) {
        return ListView.builder(
            itemCount: _.blockList.length,
            itemBuilder: (BuildContext context, int index) {
              UserFriendEntity item = _.blockList[index];

              return blockListItem(_, item, index);
            });
      }),
    );
  }

  Widget blockListItem(
      UserCenterBlockListController _, UserFriendEntity item, int index) {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: Colors.white60,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50.r),
            child: AppImage(
              '${item.icon}',
              width: 48.r,
              height: 48.r,
              fit: BoxFit.cover,
            ),
          ),
          Gap(10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.nickname}',
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
                Gap(2.h),
                Text(
                  '${item.countryId} ${item.gender == 1 ? 'Male' : 'Female'}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF959595),
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _.removeFromBlockList(item.userId!, item.yxAccid!, index);
            },
            child: Image.asset(
              AppIcon.removeFromBlackList.uri,
              width: 18.r,
              height: 18.r,
            ),
          ),
        ],
      ),
    );
  }
}
