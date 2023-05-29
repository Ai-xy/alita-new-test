import 'package:alita/api/live_api.dart';
import 'package:alita/base/base_app_future_controller.dart';
import 'package:alita/model/api/live_room_model.dart';
import 'package:alita/model/api/live_tag_model.dart';

class LiveListController extends BaseAppFutureLoadStateController {
  List<LiveTagModel> tagList = [];
  List<LiveRoomModel> liveRoomList = [];
  @override
  Future loadData({Map? params}) {
    return LiveApi.getTags().catchError((err, s) {}).then((value) {
      tagList = value ?? [];
      print(value);
      return value;
    }).then((value) {
      return LiveApi.getLiveRoomList(tagId: 32).then((value) {
        value?.forEach((element) {
          print('加载数据');

          print(element.toJson());
        });
        print(value.toString());
        liveRoomList = value ?? [];
        update();
        return value;
      });
    });
  }
}
