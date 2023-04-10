import 'package:alita/base/base_app_future_controller.dart';
import 'package:alita/enum/app_tab.dart';
import 'package:alita/model/api/live_tag_model.dart';
import 'package:alita/router/app_path.dart';
import 'package:get/get.dart';

class HomeController extends BaseAppFutureLoadStateController {
  List<LiveTagModel> tags = [];

  AppTab currentTab = AppTab.live;

  void setCurrentTab(AppTab v) {
    currentTab = v;
    update();
    if (AppTab.publish == v) {
      Get.toNamed(AppPath.startLive);
    }
  }

  @override
  Future loadData({Map? params}) {
    return Future.value();
  }
}
