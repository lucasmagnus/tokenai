import 'package:flutter/material.dart';

class ThemeColorsFactory {
  final Map<Brightness, ThemeColors> map = {
    Brightness.light: ColorsLight(),
    Brightness.dark: ColorsDark()
  };

  ThemeColors create(Brightness type) {
    if (!map.containsKey(type)) {
      throw Exception('brightness type not found');
    }

    return map[type] as ThemeColors;
  }
}

abstract class ThemeColors {
  late Color kPrimaryColorLight;
  late Color kPrimaryColor;
  late Color kPrimaryColorDark;

  late Color kPrimaryVariantColorLight;
  late Color kPrimaryVariantColor;
  late Color kPrimaryVariantColorDark;

  late Color kSecondaryColorLight;
  late Color kSecondaryColor;
  late Color kSecondaryColorDark;

  late Color kNeutralGrayishColorLight;
  late Color kNeutralGrayishColor;
  late Color kNeutralGrayishColorDark;

  late Color kNeutralWhiteishColorLight;
  late Color kNeutralWhiteishColor;
  late Color kNeutralWhiteishColorDark;

  late Color kBackgroundColorLight;
  late Color kBackgroundColor;
  late Color kBackgroundColorDark;

  late Color kNeutralBlackishColorDark;
  late Color kNeutralBlackishColor;
  late Color kNeutralBlackishColorLight;

  late Color kAlertSuccessColorLight;
  late Color kAlertSuccessColor;
  late Color kAlertSuccessColorDark;

  late Color kAlertInfoColorLight;
  late Color kAlertInfoColor;
  late Color kAlertInfoColorDark;

  late Color kAlertWarningColorLight;
  late Color kAlertWarningColor;
  late Color kAlertWarningColorDark;

  late Color kAlertDangerColorLight;
  late Color kAlertDangerColor;
  late Color kAlertDangerColorDark;

  late Color kTextPrimaryColor;
  late Color kTextSecondaryColor;
  late Color kTextAlertColor;
  late Color kTextPrimaryColorDisabled;
  late Color kTextColor;
  late Color kTextBackgroundColor;

  late Color kDisabledColor;

  late Color kDividerColor;
  late Color appleButtonColor;
}

class ColorsDark implements ThemeColors {
  @override
  late Color kPrimaryColorLight = const Color(0xFFEBCAFF);
  @override
  late Color kPrimaryColor = const Color(0xFFB799FF);
  @override
  late Color kPrimaryColorDark = const Color(0xFF856BCB);
  @override
  late Color kPrimaryVariantColorLight = const Color(0xFFA7F1EF);
  @override
  late Color kPrimaryVariantColor = const Color(0xFF5DDEDA);
  @override
  late Color kPrimaryVariantColorDark = const Color(0xFF72CDCA);
  @override
  late Color kSecondaryColorLight = const Color(0xFFFFBE8A);
  @override
  late Color kSecondaryColor = const Color(0xFFFF8D5C);
  @override
  late Color kSecondaryColorDark = const Color(0xFFC75E30);
  @override
  late Color kNeutralGrayishColorLight = const Color(0xFFDFDFDF);
  @override
  late Color kNeutralGrayishColor = const Color(0xFFADADAD);
  @override
  late Color kNeutralGrayishColorDark = const Color(0xFF7E7E7E);

  @override
  late Color kNeutralWhiteishColorLight = const Color(0xFFFFFFFF);
  @override
  late Color kNeutralWhiteishColor = const Color(0xFFF8F8F8);
  @override
  late Color kNeutralWhiteishColorDark = const Color(0xFFF0F0F0);

  @override
  late Color kBackgroundColorLight = const Color(0xFF2f3137);
  @override
  late Color kBackgroundColor = const Color(0xFF1e2026);
  @override
  late Color kBackgroundColorDark = const Color(0xFF000009);

  @override
  late Color kNeutralBlackishColorDark = const Color(0xFFF0F0F0);
  @override
  late Color kNeutralBlackishColor = const Color(0xFFF8F8F8);
  @override
  late Color kNeutralBlackishColorLight = const Color(0xFFFFFFFF);

  @override
  late Color kAlertSuccessColorLight = const Color(0xFF84CB7A);
  @override
  late Color kAlertSuccessColor = const Color(0xFF486b43);
  @override
  late Color kAlertSuccessColorDark = const Color(0xFF84CB7A);

  @override
  late Color kAlertInfoColorLight = const Color(0xFFBEFFFF);
  @override
  late Color kAlertInfoColor = const Color(0xFF8ADCFF);
  @override
  late Color kAlertInfoColorDark = const Color(0xFF55AACC);

  @override
  late Color kAlertWarningColorLight = const Color(0xFFFFFFBC);
  @override
  late Color kAlertWarningColor = const Color(0xFFFFED8B);
  @override
  late Color kAlertWarningColorDark = const Color(0xFFCABB5C);

  @override
  late Color kAlertDangerColorLight = const Color(0xFFFFB2AF);
  @override
  late Color kAlertDangerColor = const Color(0xFFFF8080);
  @override
  late Color kAlertDangerColorDark = const Color(0xFFC85054);

  @override
  late Color kTextPrimaryColor = kBackgroundColorLight;
  @override
  late Color kTextSecondaryColor = const Color(0xFFA1A1A1);
  @override
  late Color kTextAlertColor = kNeutralWhiteishColorLight;
  @override
  late Color kTextPrimaryColorDisabled = kBackgroundColorLight;
  @override
  late Color kTextColor = kNeutralWhiteishColorDark;
  @override
  late Color kTextBackgroundColor = kNeutralWhiteishColorDark;

  @override
  late Color kDisabledColor = kNeutralGrayishColorLight;

  @override
  late Color kDividerColor = kNeutralGrayishColorLight;
  @override
  late Color appleButtonColor = Colors.white;
}

class ColorsLight implements ThemeColors {
  @override
  late Color kPrimaryColorDark = const Color(0xFF522DA8);
  @override
  late Color kPrimaryColor = const Color(0xFF8559DA);
  @override
  late Color kPrimaryColorLight = const Color(0xFF9175D4);
  @override
  late Color kPrimaryVariantColorDark = const Color(0xFF5E0078);
  @override
  late Color kPrimaryVariantColor = const Color(0xFF8F2DA8);
  @override
  late Color kPrimaryVariantColorLight = const Color(0xFFC25FDA);
  @override
  late Color kSecondaryColorDark = const Color(0xFF9B3505);
  @override
  late Color kSecondaryColor = const Color(0xFFD26333);
  @override
  late Color kSecondaryColorLight = const Color(0xFFFF935F);
  @override
  late Color kBackgroundColorDark = const Color(0xFFF0F0F0);
  @override
  late Color kBackgroundColor = const Color(0xFFF8F8F8);
  @override
  late Color kBackgroundColorLight = const Color(0xFFFFFFFF);

  @override
  late Color kNeutralBlackishColorDark = const Color(0xFF151515);
  @override
  late Color kNeutralBlackishColor = const Color(0xFF2A2A2A);
  @override
  late Color kNeutralBlackishColorLight = const Color(0xFF3D3D3D);

  @override
  late Color kNeutralGrayishColorDark = const Color(0xFF7D7D7D);

  @override
  late Color kNeutralGrayishColor = const Color(0xFFA0A0A0);
  @override
  late Color kNeutralGrayishColorLight = const Color(0xFFC2C2C2);
  @override
  late Color kNeutralWhiteishColorDark = const Color(0xFFF0F0F0);

  @override
  late Color kNeutralWhiteishColor = const Color(0xFFF8F8F8);
  @override
  late Color kNeutralWhiteishColorLight = const Color(0xFFFFFFFF);
  @override
  late Color kAlertSuccessColorDark = const Color(0xFF5C9A52);
  @override
  late Color kAlertSuccessColor = const Color(0xFF75C568);
  @override
  late Color kAlertSuccessColorLight = const Color(0xFF8DEB7E);

  @override
  late Color kAlertInfoColorDark = const Color(0xFF428BAA);

  @override
  late Color kAlertInfoColor = const Color(0xFF4A9FC3);
  @override
  late Color kAlertInfoColorLight = const Color(0xFF58BCE7);
  @override
  late Color kAlertWarningColorDark = const Color(0xFFC8AC1D);

  @override
  late Color kAlertWarningColor = const Color(0xFFF5D738);
  @override
  late Color kAlertWarningColorLight = const Color(0xFFFBE367);
  @override
  late Color kAlertDangerColorDark = const Color(0xFFC22828);
  @override
  late Color kAlertDangerColor = const Color(0xFFFF3636);
  @override
  late Color kAlertDangerColorLight = const Color(0xFFFF6868);
  @override
  late Color kTextPrimaryColor = kNeutralWhiteishColorLight;
  @override
  late Color kTextSecondaryColor = kNeutralWhiteishColorLight;
  @override
  late Color kTextAlertColor = kNeutralWhiteishColorLight;
  @override
  late Color kTextPrimaryColorDisabled = kNeutralBlackishColor;
  @override
  late Color kTextColor = kNeutralGrayishColorDark;
  @override
  late Color kTextBackgroundColor = kNeutralBlackishColorDark;

  @override
  late Color kDisabledColor = kNeutralGrayishColorLight;

  @override
  late Color kDividerColor = kNeutralGrayishColorLight;
  @override
  late Color appleButtonColor = Colors.black;
}
