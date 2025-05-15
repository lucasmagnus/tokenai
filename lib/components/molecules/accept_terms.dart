import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tokenai/components/atoms/custom_checkbox.dart';
import 'package:tokenai/components/atoms/text/custom_text.dart';
import 'package:tokenai/constants/all.dart';

class AcceptTerms extends StatelessWidget {
  final void Function(bool) onChanged;
  final void Function() onTermsPressed;

  const AcceptTerms({
    required this.onChanged,
    required this.onTermsPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomCheckbox(
          onChanged: onChanged,
          color: Theme.of(context).kSecondaryColor,
        ),
        const SizedBox(width: 8),
        RichText(
          text: TextSpan(
            text: AppLocalizations.of(context)!.agree_with_terms_string,
            style: TypographyStyle.P2.value.copyWith(
              color: Theme.of(context).kTextColor,
            ),
            children: [
              TextSpan(
                text: AppLocalizations.of(context)!.terms_and_conditions_string,
                style: TypographyStyle.A1.value.copyWith(
                  color: Theme.of(context).kSecondaryColor,
                ),
                recognizer: TapGestureRecognizer()..onTap = onTermsPressed,
              )
            ],
          ),
        ),
      ],
    );
  }
}
