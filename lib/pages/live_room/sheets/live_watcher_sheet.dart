import 'package:alita/R/app_icon.dart';
import 'package:alita/model/api/live_room_model.dart';
import 'package:alita/util/log.dart';
import 'package:alita/util/toast.dart';
import 'package:alita/widgets/app_bottom_sheet.dart';
import 'package:alita/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:nim_core/nim_core.dart';

import 'live_anchor_sheet/live_anchor_sheet.dart';

class LiveWatcherSheet extends StatelessWidget {
  final List<NIMChatroomMember> memberList;
  final int count;
  final LiveRoomModel? liveRoom;
  const LiveWatcherSheet(
      {Key? key, required this.memberList, required this.count, this.liveRoom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
        child: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 22.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text('Watch Number ${memberList.length}',
                      style: TextStyle(
                          fontSize: 18.sp,
                          color: const Color.fromRGBO(51, 51, 51, 1),
                          fontWeight: FontWeight.bold)),
                  Container(
                    height: 4.h,
                    width: 46.w,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(254, 166, 35, 1),
                      borderRadius: BorderRadius.circular(24.w),
                    ),
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Image.asset(
                  AppIcon.watcherListClose.uri,
                  width: 24.r,
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: memberList.length,
            itemBuilder: (BuildContext context, int index) {
              NIMChatroomMember member = memberList[index];
              return userProfileItem(member, index, liveRoom);
            })
      ],
    ));
  }

  Widget userProfileItem(
      NIMChatroomMember member, int index, LiveRoomModel? liveRoom) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 25.h, 20.w, 16.w),
      child: InkWell(
        onTap: () {
          //AppToast.alert(message: member.extension?['userId']);
          Get.bottomSheet(LiveAnchorSheet(
            liveRoom: liveRoom,
            userId: int.parse(member.extension?['userId']),
          ));
        },
        child: Row(
          children: [
            AppImage(
              '${member.avatar}',
              width: 36.w,
              height: 36.w,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(32.r),
            ),
            Gap(10.w),
            Text('${member.nickname}',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color.fromRGBO(51, 51, 51, 1),
                )),
            Gap(10.w),
            Image.asset(
                member.extension?['gender'] == "1"
                    ? AppIcon.watcherMale.uri
                    : AppIcon.watcherFemale.uri,
                height: 14.w,
                width: 14.w)
          ],
        ),
      ),
    );
  }
}
