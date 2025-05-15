import 'package:flutter/material.dart';
import 'package:tokenai/components/atoms/text/custom_text.dart';
import 'package:tokenai/constants/all.dart';
import 'package:tokenai/constants/borders.dart';
import 'input_states.dart';

class BaseInputData {
  final Color mainColor;
  final InputDecoration decoration;
  final FormFieldState field;
  final FocusNode node;

  const BaseInputData(this.mainColor, this.decoration, this.field, this.node);
}

class BaseInput extends StatefulWidget {
  final String? label;
  final String? helperText;
  final bool disabled;
  final bool focused;
  final InputState state;
  final dynamic initialValue;
  final void Function(dynamic)? onSaved;
  final String? Function(dynamic)? validator;
  final Widget Function(BaseInputData data) builder;
  final void Function(FocusNode node, bool focused)? onFocusChange;

  const BaseInput({
    required this.state,
    required this.builder,
    this.label,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFocusChange,
    this.initialValue,
    this.disabled = false,
    this.focused = false,
    Key? key,
  }) : super(key: key);

  @override
  State<BaseInput> createState() => _BaseInputState();
}

class _BaseInputState extends State<BaseInput> {
  final FocusNode _node = FocusNode();

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      enabled: !widget.disabled,
      onSaved: widget.onSaved,
      validator: widget.validator,
      initialValue: widget.initialValue,
      builder: (FormFieldState field) {
        final isValid = field.errorText == null;
        final style = _BaseInputStyle.build(
          context,
          widget.disabled,
          widget.focused,
          isValid ? widget.state : InputState.ERROR,
        );

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label != null) _label(style.mainColor),
            Focus(
              onFocusChange: (bool value) => widget.onFocusChange?.call(_node, value),
              child: widget.builder(
                BaseInputData(
                  style.mainColor,
                  style.decoration,
                  field,
                  _node,
                ),
              ),
            ),
            if (widget.helperText != null || !isValid) _helperText(field.errorText, style.mainColor),
          ],
        );
      },
    );
  }

  Widget _label(Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: CustomText(
        color: color,
        text: widget.label!,
        style: TypographyStyle.L1,
      ),
    );
  }

  Widget _helperText(String? errorText, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, top: 8.0),
      child: CustomText(
        color: color,
        text: errorText ?? widget.helperText!,
        style: TypographyStyle.L1,
      ),
    );
  }
}

class _BaseInputStyle {
  final BuildContext context;
  final Color mainColor;
  final bool disabled;
  final bool focused;
  final InputBorder border;
  final InputState state;

  const _BaseInputStyle(
    this.context,
    this.mainColor,
    this.disabled,
    this.focused,
    this.border,
    this.state,
  );

  factory _BaseInputStyle.build(
    BuildContext context,
    bool disabled,
    bool focused,
    InputState state,
  ) {
    final InputBorder border;
    final Color color;

    switch (state) {
      case InputState.SUCCESS:
        border = baseBorder(Theme.of(context).kAlertSuccessColor);
        color = Theme.of(context).kAlertSuccessColor;
        break;
      case InputState.ERROR:
        border = baseBorder(Theme.of(context).kAlertDangerColor);
        color = Theme.of(context).kAlertDangerColor;
        break;
      default:
        border = focused
            ? baseBorder(Theme.of(context).kPrimaryColor)
            : baseBorder(Theme.of(context).kNeutralGrayishColorLight);

        color = focused ? Theme.of(context).kPrimaryColor : Theme.of(context).kNeutralGrayishColor;
        break;
    }

    return _BaseInputStyle(context, color, disabled, focused, border, state);
  }

  InputDecoration get decoration => InputDecoration(
        contentPadding: const EdgeInsets.all(8.0),
        hintStyle: TypographyStyle.P4.value.copyWith(
          color: Theme.of(context).kNeutralGrayishColor,
          height: 0,
        ),
        helperStyle: TypographyStyle.L1.value.copyWith(
          color: mainColor,
        ),
        enabledBorder: border,
        filled: disabled,
        fillColor: disabled ? Theme.of(context).kNeutralWhiteishColorDark : null,
        disabledBorder: baseBorder(Theme.of(context).kNeutralGrayishColorLight),
        focusedBorder: border,
      );
}
