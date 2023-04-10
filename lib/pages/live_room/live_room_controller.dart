import 'package:alita/model/ui/app_live_room_model.dart';
import 'package:alita/widgets/app_chatroom/app_chatroom_controller.dart';
import 'package:fijkplayer/fijkplayer.dart';

class LiveRoomController extends AppChatRoomController {
  final AppLiveRoomModel live;
  LiveRoomController({required this.live}) : super(liveRoom: live.liveRoom);
  late FijkPlayer fijkPlayer;

  static const String tag = 'LiveRoom';

  @override
  void onInit() {
    fijkPlayer = FijkPlayer()
      ..setDataSource('${liveRoom.streamUrl}', autoPlay: true, showCover: true);
    onEnterRoom();
    super.onInit();
  }

  @override
  void onClose() {
    fijkPlayer.release;
    onExitChatRoom();
    super.onClose();
  }
}
