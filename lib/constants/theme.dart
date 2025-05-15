import 'package:flutter/material.dart';

import 'all.dart';

extension ThemeDataExtension on ThemeData {
  bool get isLight => brightness == Brightness.light;
  ThemeColors get themeColors => ThemeColorsFactory().create(brightness);

  Color get kPrimaryColorDark => themeColors.kPrimaryColorDark;
  Color get kPrimaryColor => themeColors.kPrimaryColor;
  Color get kPrimaryColorLight => themeColors.kPrimaryColorLight;

  Color get kPrimaryVariantColorDark => themeColors.kPrimaryVariantColorDark;
  Color get kPrimaryVariantColor => themeColors.kPrimaryVariantColor;
  Color get kPrimaryVariantColorLight => themeColors.kPrimaryVariantColorLight;

  Color get kSecondaryColorDark => themeColors.kSecondaryColorDark;
  Color get kSecondaryColor => themeColors.kSecondaryColor;
  Color get kSecondaryColorLight => themeColors.kSecondaryColorLight;

  Color get kBackgroundColorDark => themeColors.kBackgroundColorDark;
  Color get kBackgroundColor => themeColors.kBackgroundColor;
  Color get kBackgroundColorLight => themeColors.kBackgroundColorLight;

  Color get kNeutralBlackishColorDark => themeColors.kNeutralBlackishColorDark;
  Color get kNeutralBlackishColor => themeColors.kNeutralBlackishColor;
  Color get kNeutralBlackishColorLight => themeColors.kNeutralBlackishColorLight;

  Color get kNeutralGrayishColorDark => themeColors.kNeutralGrayishColorDark;
  Color get kNeutralGrayishColor => themeColors.kNeutralGrayishColor;
  Color get kNeutralGrayishColorLight => themeColors.kNeutralGrayishColorLight;

  Color get kNeutralWhiteishColorDark => themeColors.kNeutralWhiteishColorDark;
  Color get kNeutralWhiteishColor => themeColors.kNeutralWhiteishColor;
  Color get kNeutralWhiteishColorLight => themeColors.kNeutralWhiteishColorLight;

  Color get kAlertSuccessColorDark => themeColors.kAlertSuccessColorDark;
  Color get kAlertSuccessColor => themeColors.kAlertSuccessColor;
  Color get kAlertSuccessColorLight => themeColors.kAlertSuccessColorLight;

  Color get kAlertInfoColorDark => themeColors.kAlertInfoColorDark;
  Color get kAlertInfoColor => themeColors.kAlertInfoColor;
  Color get kAlertInfoColorLight => themeColors.kAlertInfoColorLight;

  Color get kAlertWarningColorDark => themeColors.kAlertWarningColorDark;
  Color get kAlertWarningColor => themeColors.kAlertWarningColor;
  Color get kAlertWarningColorLight => themeColors.kAlertWarningColorLight;

  Color get kAlertDangerColorDark => themeColors.kAlertDangerColorDark;
  Color get kAlertDangerColor => themeColors.kAlertDangerColor;
  Color get kAlertDangerColorLight => themeColors.kAlertDangerColorLight;

  Color get kTextPrimaryColor => themeColors.kTextPrimaryColor;
  Color get kTextSecondaryColor => themeColors.kTextSecondaryColor;
  Color get kTextAlertColor => themeColors.kTextAlertColor;
  Color get kTextPrimaryColorDisabled => themeColors.kTextPrimaryColorDisabled;
  Color get kTextColor => themeColors.kTextColor;
  Color get kTextBackgroundColor => themeColors.kTextBackgroundColor;
  Color get kDisabledColor => themeColors.kDisabledColor;
  Color get kDividerColor => themeColors.kDividerColor;
  Color get appleButtonColor => themeColors.appleButtonColor;
}

final ThemeData themeLight = ThemeData(
  useMaterial3: true,
  canvasColor: ColorsLight().kBackgroundColor,
  colorScheme: const ColorScheme.light(),
  fontFamily: fontFamily,
  dividerTheme: const DividerThemeData(
    color: Colors.transparent,
  ),
);

final ThemeData themeDark = ThemeData(
  useMaterial3: true,
  canvasColor: ColorsDark().kBackgroundColor,
  colorScheme: const ColorScheme.dark(),
  fontFamily: fontFamily,
  dividerTheme: const DividerThemeData(
    color: Colors.transparent,
  ),
);
