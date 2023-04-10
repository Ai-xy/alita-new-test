import 'package:alita/R/app_icon.dart';

enum AppTab {
  live(icon: AppIcon.live, activeIcon: AppIcon.liveActive),
  hot(icon: AppIcon.hot, activeIcon: AppIcon.hotActive),
  publish(icon: AppIcon.publish, activeIcon: AppIcon.publishActive),
  follow(icon: AppIcon.tabFollow, activeIcon: AppIcon.tabFollowActive),
  me(icon: AppIcon.me, activeIcon: AppIcon.meActive),
  ;

  final AppIcon icon;
  final AppIcon activeIcon;

  const AppTab({
    required this.icon,
    required this.activeIcon,
  });
}
