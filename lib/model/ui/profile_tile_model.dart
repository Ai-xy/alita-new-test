import 'package:flutter/material.dart';

class ProfileTileModel {
  final String? icon;
  final String label;
  final String? value;
  final Function()? onTap;
  final String? backgroundImage;
  final bool widthDivider;
  final Widget trailling;

  ProfileTileModel({
    this.icon,
    required this.label,
    this.value,
    this.onTap,
    this.backgroundImage,
    this.widthDivider = true,
    this.trailling = const SizedBox.shrink(),
  });
}
