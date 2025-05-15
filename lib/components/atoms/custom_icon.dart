import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomIcon extends StatelessWidget {
  final String svgIconPath;
  final Color? color;
  final double width;
  final double height;

  const CustomIcon({
    required this.svgIconPath,
    this.color,
    this.width = 20,
    this.height = 20,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: SvgPicture.asset(
          svgIconPath,
          colorFilter:
              color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
          width: width,
          height: height,
        ),
      ),
    );
  }
}
