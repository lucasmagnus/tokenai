import 'package:flutter/material.dart';
import 'package:tokenai/constants/all.dart';

class CustomDivider extends StatelessWidget {
  final Color? color;
  final double height;
  final double width;
  const CustomDivider({
    this.color,
    this.height = 2.0,
    this.width = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width),
      child: Divider(
        color: color ?? Theme.of(context).kDividerColor,
        height: height,
      ),
    );
  }
}
