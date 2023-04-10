import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountDownClock extends StatefulWidget {
  const CountDownClock({Key? key}) : super(key: key);

  @override
  State<CountDownClock> createState() => _CountDownClockState();
}

class _CountDownClockState extends State<CountDownClock>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Timer timer;
  int count = 3;
  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..forward();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (count == 0) {
        timer.cancel();
        return;
      }
      setState(() {
        count--;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();
    return Material(
      color: Colors.white.withOpacity(.4),
      borderRadius: BorderRadius.circular(49.r),
      textStyle: TextStyle(
          fontSize: 64.sp,
          color: Colors.white.withOpacity(1 - animationController.value)),
      child: Opacity(
        opacity: 1 - animationController.value,
        child: Container(
          width: 98.r,
          height: 98.r,
          alignment: Alignment.center,
          child: Text(
            key: ValueKey(count),
            '$count',
          ),
        ),
      ),
    );
  }
}
