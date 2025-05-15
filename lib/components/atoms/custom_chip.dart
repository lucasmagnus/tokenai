import 'package:flutter/material.dart';
import 'package:tokenai/components/atoms/text/custom_text.dart';
import 'package:tokenai/constants/all.dart';

enum ChipType { PRIMARY, SECONDARY }

class CustomChip extends StatefulWidget {
  final String label;
  final ChipType type;
  final bool selected;
  final bool disabled;
  final Widget Function(Color)? iconBuilder;
  final Function(bool)? onTap;

  const CustomChip({
    required this.label,
    required this.type,
    required this.disabled,
    required this.selected,
    this.iconBuilder,
    this.onTap,
  });

  @override
  State<CustomChip> createState() => _CustomChipState();
}

class _CustomChipState extends State<CustomChip> {
  late bool _isSelected;

  @override
  void initState() {
    _isSelected = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RawChip(
      showCheckmark: false,
      isEnabled: !widget.disabled,
      selected: _isSelected,
      label: CustomText(
        text: widget.label,
        style: TypographyStyle.P2,
        color: _getContentColor(context),
      ),
      backgroundColor: Theme.of(context).kNeutralWhiteishColorDark,
      selectedColor: _getBackgroundColor(context),
      avatar: _getIcon(context),
      onSelected: widget.onTap != null
          ? (value) {
              setState(() {
                _isSelected = value;
              });
              widget.onTap?.call(value);
            }
          : null,
    );
  }

  Color _getContentColor(BuildContext context) {
    return widget.disabled ? _getTextDisabledColor(context) : _getTextColor(context);
  }

  Color _getBackgroundColor(BuildContext context) {
    return widget.disabled
        ? _getDisabledColor(context)
        : widget.type == ChipType.PRIMARY
            ? Theme.of(context).kPrimaryColor
            : Theme.of(context).kSecondaryColor;
  }

  Color _getDisabledColor(BuildContext context) {
    if (_isSelected) {
      return widget.type == ChipType.PRIMARY
          ? Theme.of(context).kPrimaryColorLight
          : Theme.of(context).kSecondaryColorLight;
    }
    return Theme.of(context).kNeutralWhiteishColor;
  }

  Widget? _getIcon(BuildContext context) {
    if (widget.iconBuilder != null) {
      return widget.iconBuilder!(_getContentColor(context));
    }
    return null;
  }

  Color _getTextColor(BuildContext context) {
    if (_isSelected) {
      return widget.type == ChipType.PRIMARY
          ? Theme.of(context).kTextPrimaryColor
          : Theme.of(context).kTextSecondaryColor;
    } else {
      return Theme.of(context).kNeutralGrayishColorDark;
    }
  }

  Color _getTextDisabledColor(BuildContext context) {
    return _isSelected ? Theme.of(context).kTextPrimaryColorDisabled : Theme.of(context).kDisabledColor;
  }
}
