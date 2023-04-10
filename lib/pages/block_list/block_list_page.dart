import 'package:alita/translation/app_translation.dart';
import 'package:flutter/material.dart';

class BlockListPage extends StatelessWidget {
  const BlockListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppMessage.blockList.tr),
      ),
    );
  }
}
