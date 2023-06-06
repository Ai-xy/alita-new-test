import 'package:alita/typedef/app_type_def.dart';
import 'package:alita/util/log.dart';
import 'package:alita/util/toast.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_throttle_it/just_throttle_it.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final bool withLoading;
  final String tip;
  final bool withIcon;
  final Widget? icon;
  final Color color;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final Widget? child;
  final BorderRadius? borderRadius;
  const AppButton.withWidget({
    this.text = '',
    this.onTap,
    this.withLoading = true,
    this.tip = 'Loading...',
    this.color = const Color(0xFFFEA623),
    this.width,
    this.height,
    this.textStyle,
    required Widget widget,
    super.key,
    this.withIcon = false,
    this.icon,
    this.borderRadius,
  }) : child = widget;
  const AppButton({
    Key? key,
    required this.text,
    this.onTap,
    this.withLoading = true,
    this.tip = 'Loading...',
    this.withIcon = false,
    this.icon,
    this.color = const Color(0xFFFEA623),
    this.width,
    this.height,
    this.textStyle,
    this.child,
    this.borderRadius,
  })  : assert(withIcon || icon == null,
            'If `withIcon` is true,then the `icon`should not be null '),
        super(key: key);
  AppButton.gray(
      {super.key,
      required this.text,
      this.onTap,
      this.withLoading = true,
      this.tip = 'Loading...',
      this.withIcon = false,
      this.icon,
      this.width,
      this.height,
      this.child,
      this.borderRadius})
      : color = const Color(0xFFECECED),
        textStyle = TextStyle(
          fontSize: 16.sp,
          color: const Color(0xFF202020).withOpacity(.5),
        );

  void _onTap() {
    if (onTap == null) return;
    if (onTap is FutureFunction && withLoading) {
      FutureFunction callback = onTap as FutureFunction;
      CancelFunc cancelFunc = AppToast.loading();
      callback().then((value) {
        Log.i('AppButton回调执行成功$value', tag: 'AppButton');
      }).catchError((err, s) {
        Log.e('AppButton回调执行失败', stackTrace: s, error: err, tag: 'AppButton');
      }).whenComplete(cancelFunc);
      return;
    }
    onTap!();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Throttle.milliseconds(1500, _onTap),
      child: Container(
        width: width,
        height: height ?? 44.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius ?? BorderRadius.circular(22.r),
        ),
        child: Builder(builder: (context) {
          if (child != null) return child!;
          return withIcon
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon ?? const SizedBox.shrink(),
                    Text(
                      text,
                      style: textStyle ??
                          TextStyle(fontSize: 16.sp, color: Colors.white),
                    ),
                  ],
                )
              : Text(
                  text,
                  style: textStyle ??
                      TextStyle(fontSize: 16.sp, color: Colors.white),
                );
        }),
      ),
    );
  }
}
