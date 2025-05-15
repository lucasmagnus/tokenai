import 'package:flutter/material.dart';
import 'package:tokenai/constants/all.dart';

class CustomRadio extends StatelessWidget {
  final bool disabled;
  final dynamic groupValue;
  final Function(dynamic) onChanged;
  final Widget? title;
  final dynamic value;
  final bool toggleable;

  const CustomRadio({
    required this.onChanged,
    required this.value,
    this.disabled = false,
    this.groupValue,
    this.title,
    this.toggleable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<dynamic>(
          toggleable: toggleable,
          value: value,
          groupValue: groupValue,
          activeColor: Theme.of(context).kPrimaryColor,
          onChanged: disabled ? null : (value) => onChanged(value),
        ),
        if (title != null) title!
      ],
    );
  }
}
