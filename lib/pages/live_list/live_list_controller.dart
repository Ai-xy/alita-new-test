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
      return value;
    }).then((value) {
      return LiveApi.getLiveRoomList().then((value) {
        liveRoomList = value ?? [];
        update();
        return value;
      });
    });
  }
}
