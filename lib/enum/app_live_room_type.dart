import 'package:alita/R/app_icon.dart';
import 'package:alita/translation/app_translation.dart';

enum AppLiveRoomType {
  publicRoom(
      icon: AppIcon.publicRoom,
      label: AppMessage.public,
      description: AppMessage.everyone),
  passwordRoom(
      icon: AppIcon.password,
      label: AppMessage.passwordRoom,
      description: AppMessage.someoneWhoHasPassword),
  ;

  const AppLiveRoomType(
      {required this.label, required this.description, required this.icon});
  final AppMessage label;
  final AppMessage description;
  final AppIcon icon;
}
