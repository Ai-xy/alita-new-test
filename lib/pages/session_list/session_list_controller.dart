import 'dart:async';
import 'package:alita/base/base_app_future_controller.dart';
import 'package:alita/model/ui/app_conversation_model.dart';
import 'package:alita/util/log.dart';
import 'package:alita/util/toast.dart';
import 'package:get/get.dart';
import 'package:nim_core/nim_core.dart';

class SessionListController extends BaseAppFutureLoadStateController {
  RxList<AppUserConversationModel> conversationList =
      <AppUserConversationModel>[].obs;
  RxList<AppUserConversationModel> conversationTipList =
      <AppUserConversationModel>[].obs;

  List<AppUserConversationModel> get getConversationTipList =>
      conversationTipList;
  StreamSubscription? streamSubscription;
  var userSessionList = List.empty(growable: true);

  @override
  void onInit() {
    super.onInit();
    streamSubscription =
        NimCore.instance.messageService.onMessage.listen((event) {
      loadData();
      update();
    });
    loadData();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    conversationList.clear();
    conversationTipList.clear();
    streamSubscription?.cancel();
    super.onClose();
  }

  @override
  Future onRefreshData() {
    // 改了这里
    //loadData();

    return super.onRefreshData();
  }

  @override
  Future loadData({Map? params}) async {
    await NimCore.instance.messageService.querySessionList(100).then((value) {
      Log.d('querySessionList: ${value.toMap()}');
      if (value.data is List<NIMSession>) {
        conversationList.value = (value.data as List<NIMSession>)
            .where((e) => e.sessionId != null.toString())
            .map((e) {
          if (e.lastMessageType == NIMMessageType.tip) {
            conversationTipList.add(AppUserConversationModel(session: e));
          }
          return AppUserConversationModel(session: e);
        }).toList();
        return Future.forEach<AppUserConversationModel>(conversationList, (e) {
          print('conversationList内容是');
          print(e.session.toMap());
          return NimCore.instance.userService
              .getUserInfo(e.session.sessionId)
              .then((value) {
            if (value.data is NIMUser) {
              e.nimUser = value.data;
              update();
            }
          });
        });
      }
    }).then((value) {
      getMsgList();
    });
    update();
    return Future.value();
  }

  // 刪除
  Future deleteSession(String sessionId) async {
    NimCore.instance.messageService
        .deleteSession(
            sessionInfo: NIMSessionInfo(
                sessionId: sessionId, sessionType: NIMSessionType.p2p),
            deleteType: NIMSessionDeleteType.localAndRemote,
            sendAck: false)
        .then((value) async {
      if (value.isSuccess) {
        AppToast.alert(message: 'success');
        await loadData();
        update();
      } else {
        AppToast.alert(message: 'delete fail');
      }
    });
  }

  // 查询云信用户信息
  Future<void> getMsgList() async {
    if (conversationList.length > 0) {
      List<String> ids = [];
      conversationList.forEach((element) {
        ids.add(element.session.sessionId);
      });

      NIMResult<List<NIMUser>> userList =
          await NimCore.instance.userService.fetchUserInfoList(ids);
      Log.d('ListUser > ${userList.toMap()}', tag: '云信用户信息');
      userSessionList.addAll(userList.data!);
      update();
    }
  }
}
