import 'package:flutter/material.dart';
import 'package:tokenai/components/atoms/text/custom_text.dart';
import 'package:tokenai/constants/all.dart';

class CustomSwitch extends StatefulWidget {
  final bool disabled;
  final bool isTitleLeft;
  final bool selected;
  final Function onChanged;
  final String? title;

  const CustomSwitch({
    required this.onChanged,
    this.disabled = false,
    this.isTitleLeft = true,
    this.selected = false,
    this.title,
  });

  @override
  CustomSwitchState createState() => CustomSwitchState();
}

class CustomSwitchState extends State<CustomSwitch> {
  late bool _isSelected;

  @override
  void initState() {
    _isSelected = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.isTitleLeft && widget.title != null) _getTitleText(),
        Switch(
          value: _isSelected,
          onChanged: widget.disabled
              ? null
              : (value) {
                  setState(() {
                    _isSelected = value;
                  });
                  widget.onChanged(value);
                },
          activeTrackColor: Theme.of(context).kNeutralWhiteishColorDark,
          activeColor: Theme.of(context).kPrimaryColor,
        ),
        if (!widget.isTitleLeft && widget.title != null) _getTitleText(),
      ],
    );
  }

  Widget _getTitleText() {
    return CustomText(
      text: widget.title!,
      style: TypographyStyle.P2,
      color: Theme.of(context).kTextBackgroundColor,
    );
  }
}
