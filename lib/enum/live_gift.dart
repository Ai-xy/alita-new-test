import 'package:alita/R/app_icon.dart';

enum LiveGift {
  castle(icon: AppIcon.liveGiftCastle),
  rocket(icon: AppIcon.liveGiftRocket),
  heart(icon: AppIcon.liveGiftHeart),
  flower(icon: AppIcon.liveGiftFlower),
  thumb(icon: AppIcon.liveGiftThumb),
  star(icon: AppIcon.liveGiftStar),
  $666(icon: AppIcon.liveGift666),
  lollipop(icon: AppIcon.liveGiftLollipop),
  ;

  final AppIcon icon;
  const LiveGift({required this.icon});
}
