import 'package:flutter/material.dart';
import 'package:tokenai/components/atoms/custom_radio.dart';
import 'package:tokenai/components/atoms/text/custom_text.dart';
import 'package:tokenai/constants/all.dart';

class RadioGroup extends StatefulWidget {
  final Map<dynamic, String> groupItems;
  final dynamic initialValue;
  final Function(dynamic) onItemSelected;
  final bool toggleable;

  const RadioGroup({
    required this.groupItems,
    required this.onItemSelected,
    this.initialValue,
    this.toggleable = false,
    Key? key,
  }) : super(key: key);

  @override
  State<RadioGroup> createState() => _RadioGroupState();
}

class _RadioGroupState<T> extends State<RadioGroup> {
  dynamic _groupValue;

  @override
  void initState() {
    if (widget.initialValue != null) {
      _groupValue = widget.initialValue;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widget.groupItems.entries
          .map(
            (entry) => CustomRadio(
              groupValue: _groupValue,
              toggleable: widget.toggleable,
              onChanged: (value) {
                setState(() {
                  _groupValue = value;
                });
                widget.onItemSelected(value);
              },
              title: CustomText(
                text: entry.value,
                style: TypographyStyle.P2,
                color: Theme.of(context).kTextBackgroundColor,
              ),
              value: entry.key,
            ),
          )
          .toList(),
    );
  }
}
