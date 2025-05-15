import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tokenai/components/molecules/bottom_navigation.dart';
import 'package:tokenai/components/templates/base_layout.dart';

class MainTemplate extends StatefulWidget {
  final List<Widget> pages;
  final StreamController<int>? changePageListener;

  const MainTemplate({
    super.key,
    required this.pages,
    this.changePageListener,
  });

  @override
  State<MainTemplate> createState() => _MainTemplateState();
}

class _MainTemplateState extends State<MainTemplate> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.changePageListener?.stream.listen((index) {
      setState(() {
        _currentIndex = index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      padding: EdgeInsets.zero,
      body: IndexedStack(
        index: _currentIndex,
        children: widget.pages,
      ),
      bottomNavigationBar: BottomNavigation(
        key: GlobalKey(),
        currentIndex: _currentIndex,
        onTabTapped: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}