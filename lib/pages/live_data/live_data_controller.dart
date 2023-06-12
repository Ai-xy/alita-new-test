import 'package:alita/api/live_api.dart';
import 'package:alita/base/base_app_controller.dart';
import 'package:alita/util/log.dart';

class LiveDataController extends BaseAppController {
  final List<String> dateItems = [];
  String selectDate = '';
  int selectIndex = 0;
  List<dynamic> incomeList = [];
  List<dynamic> dateList = [];
  List<dynamic> durationList = [];

  dynamic incomeNum = 0;
  @override
  void onInit() {
    super.onInit();
    LiveApi.queryMyLiveRoomInfo('gift').then((value) {
      print(value);
      incomeList = value['nums'];
      dateList = value['days'];

      for (var element in incomeList) {
        incomeNum += element;
      }
      for (var element in dateList) {
        dateItems.add(element);
      }
      selectDate = '2023-01';
      update();
      Log.d('$incomeNum', tag: '收入');
    });

    LiveApi.queryMyLiveRoomInfo('duration').then((value) {
      print(value);
      durationList = value['nums'];
      for (var element in durationList) {}
    });
  }
}
