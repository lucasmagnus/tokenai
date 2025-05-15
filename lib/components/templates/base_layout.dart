import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tokenai/constants/all.dart';

class BaseLayout extends StatelessWidget {
  final ObstructingPreferredSizeWidget? appBar;
  final Widget body;
  final EdgeInsetsGeometry? padding;
  final List<Widget>? persistentFooterButtons;
  final AlignmentDirectional? persistentFooterAlignment;
  final Widget? bottomNavigationBar;

  const BaseLayout({
    super.key,
    this.appBar,
    required this.body,
    this.padding,
    this.persistentFooterButtons,
    this.persistentFooterAlignment,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return HeroControllerScope(
      controller: HeroController(),
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).kBackgroundColor,
          appBar: appBar,
          body: SafeArea(
            child: padding != null
                ? Padding(
                    padding: padding!,
                    child: body,
                  )
                : body,
          ),
          bottomNavigationBar: bottomNavigationBar,
        ),
      ),
    );
  }
}

class _EmptyNavigationBar extends StatelessWidget implements ObstructingPreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      backgroundColor: Theme.of(context).kNeutralWhiteishColorLight,
      automaticallyImplyLeading: false,
      border: null,
    );
  }

  @override
  Size get preferredSize => Size.zero;

  @override
  bool shouldFullyObstruct(BuildContext context) => false;
}