import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tokenai/components/atoms/text/custom_text.dart';
import 'package:tokenai/constants/all.dart';
import 'package:tokenai/constants/assets.dart';

enum SocialProvider { GOOGLE, APPLE, FACEBOOK }

extension SocialProviderExtension on SocialProvider {
  String get title {
    switch (this) {
      case SocialProvider.APPLE:
        return 'CONTINUE WITH APPLE';
      case SocialProvider.GOOGLE:
        return 'CONTINUE WITH GOOGLE';
      case SocialProvider.FACEBOOK:
        return 'CONTINUE WITH FACEBOOK';
    }
  }

  String get icon {
    switch (this) {
      case SocialProvider.APPLE:
        return AppAssets.APPLE_ICON;
      case SocialProvider.GOOGLE:
        return AppAssets.GOOGLE_ICON;
      case SocialProvider.FACEBOOK:
        return AppAssets.FACEBOOK_ICON;
    }
  }
}

class SocialButton extends StatelessWidget {
  final SocialProvider socialProvider;
  final VoidCallback onPressed;
  final bool disabled;
  final bool loading;

  const SocialButton({
    required this.socialProvider,
    required this.onPressed,
    this.disabled = false,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    _ButtonStyle style = _ButtonStyle.buildStyle(socialProvider, disabled, context);
    Widget buttonWidget;
    buttonWidget = OutlinedButton(
      onPressed: disabled || loading ? null : () => onPressed(),
      style: ButtonStyle(
        shape: style.shape,
        side: MaterialStateProperty.all(
          BorderSide(
            width: borderWidth,
            color: style.borderColor!,
          ),
        ),
        overlayColor: style.overlayColor,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: _getButtonContent(style.contentColor!, context),
      ),
    );

    return SizedBox(
      height: buttonSize,
      child: buttonWidget,
    );
  }

  Widget _getButtonContent(Color contentColor, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        getIcon(context),
        Expanded(child: Container()),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: loading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    contentColor,
                  ),
                )
              : CustomText(
                  text: socialProvider.title,
                  style: TypographyStyle.L1,
                ),
        ),
        Expanded(child: Container()),
      ],
    );
  }

  Widget getIcon(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 24,
      child: SvgPicture.asset(
        socialProvider.icon,
        colorFilter: socialProvider == SocialProvider.APPLE
            ? ColorFilter.mode(
                Theme.of(context).appleButtonColor,
                BlendMode.srcIn,
              )
            : null,
      ),
    );
  }
}

class _ButtonStyle {
  final MaterialStateProperty<Color?>? backgroundColor;
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
    SocialProvider socialProvider,
    bool isDisabled,
    BuildContext context,
  ) {
    Color? backgroundColor;
    Color? borderColor =
        socialProvider == SocialProvider.APPLE ? Theme.of(context).appleButtonColor : Theme.of(context).kPrimaryColor;
    Color? contentColor = isDisabled
        ? Theme.of(context).kDisabledColor
        : socialProvider == SocialProvider.APPLE
            ? Theme.of(context).appleButtonColor
            : Theme.of(context).kPrimaryColor;
    Color? overlayColor = Theme.of(context).kNeutralGrayishColorDark.withAlpha(50);

    return _ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        isDisabled ? Theme.of(context).kDisabledColor : backgroundColor,
      ),
      borderColor: (isDisabled) ? Theme.of(context).kDisabledColor : borderColor,
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
