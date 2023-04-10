import 'package:alita/R/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserProfileCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const UserProfileCard({Key? key, required this.child, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColor.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 6.r,
              spreadRadius: 1.r,
              color: const Color.fromARGB(0.0784 * 255 ~/ 1, 0, 0, 0),
            )
          ]),
      child: child,
    );
  }
}
