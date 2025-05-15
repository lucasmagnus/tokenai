import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tokenai/components/atoms/text/custom_text.dart'
    show CustomText, TypographyStyle;
import 'package:tokenai/constants/all.dart';

enum ButtonType { PRIMARY, SECONDARY, TERTIARY, GHOST, DESTRUCTIVE }

class Button extends StatelessWidget {
  final String label;
  final ButtonType type;
  final Function() onPressed;
  final Widget Function(Color)? icon;
  final bool isIconLeft;
  final bool disabled;
  final bool loading;
  final bool fullWidth;

  const Button({
    required this.label,
    required this.onPressed,
    required this.type,
    this.icon,
    this.isIconLeft = true,
    this.disabled = false,
    this.loading = false,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    _ButtonStyle style = _ButtonStyle.buildStyle(type, disabled, context);
    Widget buttonWidget;

    if (type == ButtonType.TERTIARY || type == ButtonType.GHOST) {
      buttonWidget = OutlinedButton(
        onPressed: disabled || loading ? null : onPressed,
        style: ButtonStyle(
          shape: style.shape,
          side: MaterialStateProperty.all(
            BorderSide(width: borderWidth, color: style.borderColor!),
          ),
          overlayColor: style.overlayColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: _getButtonContent(style.contentColor!, context),
        ),
      );
    } else {
      buttonWidget = CupertinoButton(
        onPressed: disabled || loading ? null : onPressed,
        color: style.backgroundColor,
        child: _getButtonContent(style.contentColor!, context),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      );
    }

    return SizedBox(
      height: buttonSize,
      width: fullWidth ? double.infinity : null,
      child: buttonWidget,
    );
  }

  Widget _getButtonContent(Color contentColor, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null && isIconLeft) getIcon(contentColor),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child:
              loading
                  ? Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).kTextColor),
                      ),
                    ),
                  )
                  : CustomText(
                    text: label.toUpperCase(),
                    style: TypographyStyle.L1,
                    color: contentColor,
                  ),
        ),
        if (icon != null && !isIconLeft) getIcon(contentColor),
      ],
    );
  }

  Widget getIcon(Color contentColor) {
    return SizedBox(height: 24, width: 24, child: icon?.call(contentColor));
  }
}

class _ButtonStyle {
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? contentColor;
  final MaterialStateProperty<Color?>? overlayColor;
  final MaterialStateProperty<OutlinedBorder> shape;

  _ButtonStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.contentColor,
    required this.overlayColor,
    required this.shape,
  });

  factory _ButtonStyle.buildStyle(
    ButtonType type,
    bool isDisabled,
    BuildContext context,
  ) {
    Color? backgroundColor;
    Color? borderColor;
    Color? contentColor;
    Color? overlayColor;

    switch (type) {
      case ButtonType.DESTRUCTIVE:
        backgroundColor = Theme.of(context).kAlertDangerColor;
        contentColor = Theme.of(context).kTextAlertColor;
        overlayColor = Theme.of(context).kAlertDangerColorDark;
        break;
      case ButtonType.SECONDARY:
        backgroundColor = Theme.of(context).kSecondaryColor;
        contentColor = Theme.of(context).kTextSecondaryColor;
        overlayColor = Theme.of(context).kSecondaryColorDark;
        break;
      case ButtonType.GHOST:
        borderColor = Colors.transparent;
        contentColor =
            isDisabled
                ? Theme.of(context).kDisabledColor
                : Theme.of(context).kPrimaryColor;
        overlayColor = Theme.of(context).kNeutralGrayishColorDark.withAlpha(50);
        break;
      case ButtonType.TERTIARY:
        borderColor = Theme.of(context).kPrimaryColor;
        contentColor =
            isDisabled
                ? Theme.of(context).kDisabledColor
                : Theme.of(context).kPrimaryColor;
        overlayColor = Theme.of(context).kNeutralGrayishColorDark.withAlpha(50);
        break;
      case ButtonType.PRIMARY:
        backgroundColor = Theme.of(context).kPrimaryColor;
        contentColor = Theme.of(context).kTextPrimaryColor;
        overlayColor = Theme.of(context).kPrimaryColorDark;
        break;
    }

    return _ButtonStyle(
      backgroundColor:
          isDisabled ? Theme.of(context).kDisabledColor : backgroundColor,
      borderColor:
          (isDisabled && type == ButtonType.TERTIARY)
              ? Theme.of(context).kDisabledColor
              : borderColor,
      contentColor: contentColor,
      overlayColor: MaterialStateProperty.all(overlayColor),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
