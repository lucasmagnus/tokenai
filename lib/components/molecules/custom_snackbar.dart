import 'package:flutter/material.dart';
import 'package:tokenai/components/atoms/custom_icon.dart';
import 'package:tokenai/components/atoms/text/custom_text.dart';
import 'package:tokenai/constants/all.dart';

enum SnackbarType {
  DANGER,
  INFO,
  SUCCESS,
  WARNING,
}

class CustomSnackbar extends SnackBar {
  CustomSnackbar({
    required String contentText,
    required SnackbarType type,
    required BuildContext context,
    String? actionText,
    void Function()? onActionPressed,
    Duration? duration,
    SnackBarBehavior? behavior,
  }) : super(
          content: _getSnackbarContentByType(contentText, type, context),
          backgroundColor: _getSnackbarBackgroundColorByType(type, context),
          duration: duration ?? const Duration(seconds: 4),
          behavior: behavior,
          action: actionText != null && onActionPressed != null
              ? SnackBarAction(
                  label: actionText,
                  onPressed: onActionPressed,
                  textColor: type == SnackbarType.WARNING
                      ? Theme.of(context).kNeutralBlackishColor
                      : Theme.of(context).kNeutralWhiteishColor,
                )
              : null,
        );
}

Widget _getSnackbarContentByType(
  String contentText,
  SnackbarType type,
  BuildContext context,
) {
  return Row(
    children: [
      _getSnackbarIconByType(type, context),
      const SizedBox(
        width: 16,
      ),
      Expanded(
        child: CustomText(
          text: contentText,
          style: TypographyStyle.P1,
          color: type == SnackbarType.WARNING
              ? Theme.of(context).kNeutralBlackishColor
              : Theme.of(context).kNeutralWhiteishColor,
          wrap: true,
        ),
      )
    ],
  );
}

CustomIcon _getSnackbarIconByType(SnackbarType type, BuildContext context) {
  switch (type) {
    case SnackbarType.DANGER:
      return CustomIcon(
        svgIconPath: AppAssets.ICON_DANGER,
        color: Theme.of(context).kNeutralWhiteishColor,
      );
    case SnackbarType.INFO:
      return CustomIcon(
        svgIconPath: AppAssets.ICON_INFO,
        color: Theme.of(context).kNeutralWhiteishColor,
      );
    case SnackbarType.SUCCESS:
      return CustomIcon(
        svgIconPath: AppAssets.ICON_SUCCESS,
        color: Theme.of(context).kNeutralWhiteishColor,
      );
    case SnackbarType.WARNING:
      return CustomIcon(
        svgIconPath: AppAssets.ICON_WARNING,
        color: Theme.of(context).kNeutralBlackishColor,
      );
  }
}

Color? _getSnackbarBackgroundColorByType(
  SnackbarType type,
  BuildContext context,
) {
  switch (type) {
    case SnackbarType.DANGER:
      return Theme.of(context).kAlertDangerColor;
    case SnackbarType.INFO:
      return Theme.of(context).kAlertInfoColor;
    case SnackbarType.SUCCESS:
      return Theme.of(context).kAlertSuccessColor;
    case SnackbarType.WARNING:
      return Theme.of(context).kAlertWarningColor;
  }
}
