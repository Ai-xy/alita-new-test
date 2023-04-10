import 'package:alita/widgets/app_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:nim_core/nim_core.dart';

class LiveWatcherSheet extends StatelessWidget {
  final List<NIMChatroomMember> memberList;
  final int count;
  const LiveWatcherSheet(
      {Key? key, required this.memberList, required this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
        child: Column(
      children: [],
    ));
  }
}
