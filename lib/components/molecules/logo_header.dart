import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tokenai/constants/all.dart';

class LogoHeader extends StatelessWidget {
  final bool avoidPadding;
  const LogoHeader({
    Key? key,
    this.avoidPadding = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      expandedHeight:
          avoidPadding ? null : MediaQuery.of(context).size.height * 0.25,
      collapsedHeight: 100,
      flexibleSpace: Container(
        padding: const EdgeInsets.only(top: 60.0),
        alignment: Alignment.topCenter,
        child: Theme.of(context).isLight
            ? SvgPicture.asset(AppAssets.LOGO)
            : SvgPicture.asset(AppAssets.LOGO_DARK),
      ),
    );
  }
}
