import 'package:alita/R/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AppSlideAction extends StatelessWidget {
  const AppSlideAction({
    Key? key,
    required this.icon,
    this.flex = 1,
    this.onPressed,
  }) : super(key: key);

  final AppIcon icon;
  final int flex;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomSlidableAction(
      flex: flex,
      autoClose: true,
      backgroundColor: const Color(0xFFF6F1E5),
      onPressed: (BuildContext context) {
        if (null != onPressed) {
          onPressed!();
        }
      },
      child: Image.asset(
        icon.uri,
        width: 32.r,
        height: 32.r,
      ),
    );
  }
}

class CirclePaint extends CustomPainter {
  final double? radius;
  final Color? color;

  const CirclePaint({
    this.radius,
    this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset offsetCenter = Offset(size.width / 2, size.height / 2);
    final ringPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = color!
      ..strokeWidth = 1;
    canvas.drawCircle(offsetCenter, radius!, ringPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
