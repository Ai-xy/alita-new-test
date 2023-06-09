import 'package:alita/R/app_color.dart';
import 'package:alita/pages/session_list/session_list_controller.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nim_core/nim_core.dart';

import 'widgets/session_card.dart';

class SessionListPage extends StatelessWidget {
  SessionListPage({Key? key}) : super(key: key);
  final SessionListController logic = Get.put(SessionListController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SessionListController>(initState: (s) {
      logic.loadData();
    }, builder: (_) {
      return Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          centerTitle: false,
          title: Text(AppMessage.messages.tr),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return _.loadData();
          },
          child: ListView.builder(
            itemBuilder: (BuildContext context, int i) {
              return SessionCard(
                  conversation: _.conversationList[i],
                  nimUser: _.userSessionList.firstWhere(
                      (element) =>
                          element.userId ==
                          _.conversationList[i].session.sessionId,
                      orElse: () => NIMUser()));
            },
            itemCount: _.conversationList.length,
          ),
        ),
      );
    });
  }
}
