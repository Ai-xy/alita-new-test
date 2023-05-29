import 'dart:async';

import 'package:alita/base/base_app_future_controller.dart';
import 'package:alita/model/ui/app_conversation_model.dart';
import 'package:alita/util/log.dart';
import 'package:get/get.dart';
import 'package:nim_core/nim_core.dart';

class SessionListController extends BaseAppFutureLoadStateController {
  RxList<AppUserConversationModel> conversationList =
      <AppUserConversationModel>[].obs;

  @override
  Future loadData({Map? params}) {
    Log.d('加载信息');
    NimCore.instance.messageService.querySessionList(100).then((value) {
      Log.d('哈哈哈${value.toMap()}');
      if (value.data is List<NIMSession>) {
        conversationList.value = (value.data as List<NIMSession>)
            .where((e) => e.sessionId != null.toString())
            .map((e) => AppUserConversationModel(session: e))
            .toList();
        return Future.forEach<AppUserConversationModel>(conversationList, (e) {
          print('就哦哦');

          print(e.session.toMap());
          return NimCore.instance.userService
              .getUserInfo(e.session.sessionId)
              .then((value) {
            if (value.data is NIMUser) {
              e.nimUser = value.data;
            }
          });
        });
      }
    });
    return Future.value();
  }


}
