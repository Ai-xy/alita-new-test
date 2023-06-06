import 'package:alita/R/app_icon.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:nim_core/nim_core.dart';

import 'block_list_controller.dart';

class BlockListPage extends StatelessWidget {
  const BlockListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppMessage.blockList.tr),
      ),
      body: GetBuilder<BlockListController>(builder: (_) {
        return ListView.builder(
            itemCount: _.blockAnchorList?.length,
            itemBuilder: (BuildContext context, int index) {
              NIMChatroomMember? anchor = _.blockAnchorList?[index];
              return listItem(_, anchor);
            });
      }),
    );
  }

  listItem(BlockListController controller, NIMChatroomMember? anchor) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 11.h),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                height: 48.w,
                width: 48.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.r),
                  child: AppImage(
                    '${anchor?.avatar}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Gap(11.w),
              Text(
                '${anchor?.nickname}',
                style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color.fromRGBO(51, 51, 51, 1)),
              )
            ],
          ),
          InkWell(
            onTap: () {
              controller.unblockUser(anchor?.account, false).then((value) {
                controller.getBlockList();
              });
            },
            child: SizedBox(
              height: 18.w,
              width: 18.w,
              child: Image.asset(AppIcon.removeFromBlackList.uri),
            ),
          )
        ],
      ),
    );
  }
}
