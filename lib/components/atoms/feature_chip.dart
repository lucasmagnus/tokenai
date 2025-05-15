import 'package:flutter/material.dart';

class FeatureChip extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final TextStyle? labelStyle;

  const FeatureChip({
    super.key,
    required this.label,
    this.backgroundColor,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: labelStyle ?? const TextStyle(fontSize: 14),
      ),
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
} 