import 'package:alita/local_storage/app_local_storge.dart';
import 'package:alita/model/api/user_profile_model.dart';
import 'package:alita/model/ui/app_live_room_model.dart';
import 'package:alita/widgets/app_chatroom/app_chatroom_controller.dart';
import 'package:fijkplayer/fijkplayer.dart';

class LiveRoomController extends AppChatRoomController {
  final AppLiveRoomModel live;
  LiveRoomController({required this.live}) : super(liveRoom: live.liveRoom);
  late FijkPlayer fijkPlayer;
  bool isRoomOwner = false;
  @override
  UserProfileModel? user;
  static const String tag = 'LiveRoom';

  @override
  void onInit() {
    print('直播间信息');
    print(live.liveRoom.toJson());
    getUser();
    checkIsRoomOwner();
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

  getUser() {
    user = UserProfileModel.fromJson(
        AppLocalStorage.getJson(AppStorageKey.user) ?? {});
  }

  // 查看自己是否为房主
  checkIsRoomOwner() {
    print('id信息${live.liveRoom.homeownerId} ${user?.userId}');
    if (live.liveRoom.homeownerId == user?.userId) {
      isRoomOwner = true;
      update();
    } else {
      isRoomOwner = false;
    }
  }
}
