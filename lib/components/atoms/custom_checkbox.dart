import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tokenai/components/atoms/text/custom_text.dart';
import 'package:tokenai/constants/all.dart';

class CustomCheckbox extends StatefulWidget {
  final bool value;
  final String? title;
  final String? description;
  final Color? color;
  final Function(bool) onChanged;

  const CustomCheckbox({
    required this.onChanged,
    this.color,
    this.value = false,
    this.title,
    this.description,
  });

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool _isSelected;

  @override
  void initState() {
    _isSelected = widget.value;
    super.initState();
  }

  void _toggleSelection() {
    setState(() {
      _isSelected = !_isSelected;
    });
    widget.onChanged(_isSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: CupertinoCheckbox(
                activeColor: widget.color ?? Theme.of(context).kPrimaryColor,
                value: _isSelected,
                onChanged: (value) {
                  _toggleSelection();
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: _toggleSelection,
                child: CustomText(
                  text: widget.title!,
                  style: TypographyStyle.H5,
                ),
              ),
            ),
          ],
        ),
        widget.description != null
            ? Padding(
          padding: const EdgeInsets.only(left: 32),
          child: GestureDetector(
            onTap: _toggleSelection,
            child: CustomText(
              text: widget.description!,
              style: TypographyStyle.P4,
              wrap: true,
            ),
          ),
        )
            : const SizedBox.shrink(),
      ],
    );
  }
}