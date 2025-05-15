import 'package:flutter/material.dart';
import 'package:tokenai/components/atoms/button.dart';
import 'package:tokenai/components/atoms/text/custom_text.dart';
import 'package:tokenai/constants/all.dart';

class SubmittedForm extends StatelessWidget {
  final String? title;
  final String? description;
  final String buttonLabel;
  final String? buttonHelperText;
  final bool buttonDisabled;
  final bool buttonLoading;
  final VoidCallback onPressed;

  const SubmittedForm({
    Key? key,
    required this.buttonLabel,
    required this.onPressed,
    this.title,
    this.description,
    this.buttonHelperText,
    this.buttonDisabled = false,
    this.buttonLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _formHeader(),
        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
          width: double.infinity,
          child: Button(
            label: buttonLabel,
            type: ButtonType.PRIMARY,
            onPressed: onPressed,
            disabled: buttonDisabled,
            loading: buttonLoading,
          ),
        ),
        if (buttonHelperText != null) ...[
          const SizedBox(
            height: 12,
          ),
          CustomText(
            text: buttonHelperText!,
            style: TypographyStyle.L2,
            color: Theme.of(context).kNeutralGrayishColor,
          ),
        ]
      ],
    );
  }

  Widget _formHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null)
          CustomText(
            text: title!,
            style: TypographyStyle.H5,
          ),
        if (description != null)
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: CustomText(
              text: description!,
              style: TypographyStyle.P2,
              wrap: true,
            ),
          ),
      ],
    );
  }
}
