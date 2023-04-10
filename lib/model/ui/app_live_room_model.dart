import 'package:alita/model/api/live_room_model.dart';
import 'package:fijkplayer/fijkplayer.dart';

class AppLiveRoomModel {
  final LiveRoomModel liveRoom;
  final String streamUrl;
  final FijkPlayer? fijkPlayer;
  AppLiveRoomModel(
      {required this.liveRoom, required this.streamUrl, this.fijkPlayer});
}
