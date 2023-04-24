import 'package:alita/api/live_api.dart';
import 'package:alita/base/base_app_future_controller.dart';
import 'package:alita/model/api/live_room_model.dart';

class HotLiveController extends BaseAppFutureLoadStateController {
  List<LiveRoomModel> liveRoomList = [];
  @override
  Future loadData({Map? params}) {
    return LiveApi.getLiveRoomList(tagId: 32).then((value) {
      liveRoomList = value ?? [];
      return value;
    });
  }
}
