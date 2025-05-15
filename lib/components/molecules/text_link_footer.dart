import 'package:flutter/material.dart';
import 'package:tokenai/components/atoms/custom_divider.dart';
import 'package:tokenai/components/atoms/text/custom_text.dart';
import 'package:tokenai/constants/all.dart';

class TextLinkFooter extends StatelessWidget {
  final String text;
  final String textLink;
  final void Function() onPressed;

  const TextLinkFooter({
    required this.text,
    required this.textLink,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomDivider(
          width: 16,
          color: Theme.of(context).kDividerColor,
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: text,
              style: TypographyStyle.P2,
            ),
            const SizedBox(
              width: 4,
            ),
            GestureDetector(
              onTap: onPressed,
              child: CustomText(
                text: textLink,
                style: TypographyStyle.A1,
                color: Theme.of(context).kSecondaryColor,
              ),
            )
          ],
        )
      ],
    );
  }
}
