import 'package:alita/R/app_color.dart';
import 'package:alita/enum/app_tab.dart';
import 'package:alita/pages/follow/follow_page.dart';
import 'package:alita/pages/home/home_controller.dart';
import 'package:alita/pages/hot_live/hot_live_page.dart';
import 'package:alita/pages/live_list/live_list_page.dart';
import 'package:alita/pages/user_profile/user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (_) {
      return Scaffold(
        body: IndexedStack(
          index: _.currentTab.index,
          children: [
            LiveListPage(),
            HotLivePage(),
            FollowPage(),
            FollowPage(),
            UserProfilePage(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: AppColor.white, boxShadow: [
            BoxShadow(
              offset: Offset(3.r, 0),
              blurRadius: 4.r,
              spreadRadius: 1.r,
              color: AppColor.bottomNavigationBarShadowColor,
            ),
          ]),
          height: 84.h,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            for (AppTab tab in AppTab.values)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _.setCurrentTab(tab);
                },
                child: Container(
                  padding: EdgeInsets.only(bottom: 40.h, top: 12.h),
                  alignment: Alignment.center,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _.currentTab != tab
                        ? Image.asset(
                            tab.icon.uri,
                            width: 32.r,
                            height: 32.r,
                            key: ValueKey(
                              tab.icon.uri,
                            ),
                          )
                        : Image.asset(
                            tab.activeIcon.uri,
                            width: 32.r,
                            height: 32.r,
                            key: ValueKey(
                              tab.activeIcon.uri,
                            ),
                          ),
                  ),
                ),
              )
          ]),
        ),
      );
    });
  }
}
