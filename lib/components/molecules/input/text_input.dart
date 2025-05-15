import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tokenai/components/atoms/custom_icon.dart';
import 'package:tokenai/components/molecules/input/base_input.dart';
import 'package:tokenai/components/molecules/input/input_states.dart';
import 'package:tokenai/constants/all.dart';
import 'package:tokenai/constants/assets.dart';

class TextInput extends StatefulWidget {
  final String? label;
  final String? placeholder;
  final String? helperText;
  final bool obscureText;
  final bool disabled;
  final int? maxLines;
  final String? initialValue;
  final InputState state;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget Function(Color)? iconLeftBuilder;
  final Widget Function(Color)? iconRightBuilder;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;

  const TextInput({
    this.label,
    this.placeholder,
    this.helperText,
    this.obscureText = false,
    this.disabled = false,
    this.maxLines = 1,
    this.initialValue,
    this.state = InputState.DEFAULT,
    this.keyboardType,
    this.textInputAction,
    this.iconLeftBuilder,
    this.iconRightBuilder,
    this.inputFormatters,
    this.onSaved,
    this.validator,
    Key? key,
  }) : super(key: key);

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  bool _isFocused = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) _controller.text = widget.initialValue!;
  }

  @override
  Widget build(BuildContext context) {
    return BaseInput(
      label: widget.label,
      helperText: widget.helperText,
      state: widget.state,
      disabled: widget.disabled,
      focused: _isFocused,
      onFocusChange: _onFocusChange,
      initialValue: _controller.text,
      onSaved: (value) => widget.onSaved?.call(value),
      validator: (value) => widget.validator?.call(value),
      builder: (BaseInputData data) {
        return CupertinoTextField(
          focusNode: data.node,
          controller: _controller,
          maxLines: widget.maxLines,
          cursorColor: data.mainColor,
          inputFormatters: widget.inputFormatters,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          textInputAction: widget.textInputAction,
          enabled: !widget.disabled,
          onChanged: (value) => data.field.didChange(value),
          placeholder: widget.placeholder,
          suffix: _getSuffixIconByState(data.mainColor),
          prefix: _getPrefixIconByState(data.mainColor),
          style: TextStyle(color: Theme.of(context).kTextColor),
          decoration: BoxDecoration(
            color: Theme.of(context).kBackgroundColorLight,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }

  Widget _getErrorIcon() {
    return const CustomIcon(svgIconPath: AppAssets.ERROR);
  }

  Widget _getSuccessIcon() {
    return const CustomIcon(svgIconPath: AppAssets.SUCCESS);
  }

  Widget? _getSuffixIconByState(Color color) {
    switch (widget.state) {
      case InputState.SUCCESS:
        return widget.iconRightBuilder?.call(color) ?? _getSuccessIcon();
      case InputState.ERROR:
        return widget.iconRightBuilder?.call(color) ?? _getErrorIcon();
      default:
        return widget.iconRightBuilder?.call(color);
    }
  }

  Widget? _getPrefixIconByState(Color color) {
    switch (widget.state) {
      case InputState.SUCCESS:
        return widget.iconRightBuilder != null
            ? _getSuccessIcon()
            : widget.iconLeftBuilder?.call(color);
      case InputState.ERROR:
        return widget.iconRightBuilder != null
            ? _getErrorIcon()
            : widget.iconLeftBuilder?.call(color);
      default:
        return widget.iconLeftBuilder?.call(color);
    }
  }

  void _onFocusChange(FocusNode node, bool focus) {
    setState(() {
      _isFocused = focus;
      if (_isFocused) node.requestFocus();
    });
  }
}
