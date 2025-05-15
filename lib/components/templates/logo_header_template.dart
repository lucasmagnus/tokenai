import 'package:flutter/material.dart';
import 'package:tokenai/components/molecules/logo_header.dart';

class LogoHeaderTemplate extends StatelessWidget {
  final Widget? footer;
  final Widget child;
  final bool avoidHeaderPadding;

  const LogoHeaderTemplate({
    required this.child,
    this.footer,
    this.avoidHeaderPadding = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: footer != null
          ? [
              footer!,
            ]
          : null,
      body: CustomScrollView(
        slivers: [
          LogoHeader(
            avoidPadding: avoidHeaderPadding,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
