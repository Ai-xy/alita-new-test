import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AppPercentIndicator extends StatelessWidget {
  final double? width;
  final double? height;
  final Color backgroundColor;
  final double progress;
  const AppPercentIndicator({
    Key? key,
    this.width,
    this.height,
    this.backgroundColor = Colors.black54,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 110.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: backgroundColor),
      height: height,
      child: Stack(
        children: [
          CircularPercentIndicator(
            radius: 30.0,
            lineWidth: 4.0,
            percent: progress,
            circularStrokeCap: CircularStrokeCap.round,
            center: Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(fontSize: 14.sp, color: Colors.white),
            ),
            progressColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
