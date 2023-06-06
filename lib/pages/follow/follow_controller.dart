import 'package:alita/api/moment_api.dart';
import 'package:alita/base/base_app_future_controller.dart';
import 'package:alita/model/api/moment_model.dart';
import 'package:alita/util/log.dart';
import 'package:alita/util/toast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FollowController extends BaseAppFutureLoadStateController {
  List<MomentModel> momentList = [];


  int currentPage = 1;
  int pageSize = 20;
  bool hasMore = true;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }


  @override
  Future loadData({Map? params}) {
    return MomentApi.getMomentList().then((value) {
      momentList = value ?? [];
      update();
      return value;
    });
  }
}
