import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tokenai/constants/all.dart';

class CustomLoader extends StatelessWidget {
  final double height;
  final double width;
  final Color? color;
  final double radius;

  const CustomLoader({
    this.height = 20,
    this.width = 20,
    this.color,
    this.radius = 30,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return SizedBox(
        height: height,
        width: width,
        child: CupertinoActivityIndicator(
          radius: radius,
        ),
      );
    } else {
      return SizedBox(
        height: height,
        width: width,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Theme.of(context).kPrimaryColor,
          ),
        ),
      );
    }
  }
}
