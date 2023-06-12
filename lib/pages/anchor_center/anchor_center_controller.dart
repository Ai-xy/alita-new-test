import 'package:alita/api/live_api.dart';
import 'package:alita/base/base_app_controller.dart';
import 'package:alita/util/log.dart';

class AnchorCenterController extends BaseAppController {
  List<dynamic> incomeList = [];
  dynamic incomeNum = 0;
  @override
  void onInit() {
    super.onInit();
    LiveApi.queryMyLiveRoomInfo('gift').then((value) {
      print(value);
      incomeList = value['nums'];
      for (var element in incomeList) {
        incomeNum += element;
      }
      update();
      Log.d('$incomeNum', tag: '收入');
    });
  }
}
