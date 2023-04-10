import 'package:alita/R/app_color.dart';
import 'package:alita/pages/session_list/session_list_controller.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/session_card.dart';

class SessionListPage extends StatelessWidget {
  const SessionListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SessionListController>(builder: (_) {
      return Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          centerTitle: false,
          title: Text(AppMessage.messages.tr),
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int i) {
            return SessionCard(conversation: _.conversationList[i]);
          },
          itemCount: _.conversationList.length,
        ),
      );
    });
  }
}
