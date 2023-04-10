import 'package:alita/R/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLoadingIndicator extends StatelessWidget {
  final double? width;
  final double? height;
  const AppLoadingIndicator({Key? key, this.width, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HookBuilder(builder: (_) {
      final AnimationController animationController =
          useAnimationController(duration: const Duration(seconds: 1))
            ..repeat();
      return RotationTransition(
        turns: animationController,
        child: Image.asset(
          AppIcon.loading.uri,
          width: width ?? 72.r,
          height: height ?? 72.r,
        ),
      );
    });
  }
}
