import 'package:alita/R/app_icon.dart';
import 'package:alita/translation/app_translation.dart';

enum VipLevel {
  level1(
    icon: AppIcon.level1,
    growthValue: 200,
    description: AppMessage.memberLogo,
  ),
  level2(
    icon: AppIcon.level2,
    growthValue: 2400,
    description: AppMessage.memberLogo,
  ),
  level3(
    icon: AppIcon.level3,
    growthValue: 4950,
    description: AppMessage.extra3,
  ),
  level4(
    icon: AppIcon.level4,
    growthValue: 9050,
    description: AppMessage.extra5,
  ),
  level5(
    icon: AppIcon.level5,
    growthValue: 12800,
    description: AppMessage.extra7,
  ),
  level6(
    icon: AppIcon.level6,
    growthValue: 21000,
    description: AppMessage.extra9,
  ),
  level7(
    icon: AppIcon.level7,
    growthValue: 24500,
    description: AppMessage.extra11,
  ),
  level8(
    icon: AppIcon.level8,
    growthValue: 49500,
    description: AppMessage.extra13,
  ),
  ;

  final AppIcon icon;
  final int growthValue;
  final AppMessage description;

  const VipLevel({
    required this.icon,
    required this.growthValue,
    required this.description,
  });
}
