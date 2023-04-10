import 'package:nim_core/nim_core.dart';

class AppUserConversationModel {
  NIMUser? nimUser;
  final NIMSession session;
  NIMFriend? friend;
  AppUserConversationModel({this.nimUser, this.friend, required this.session});
}
