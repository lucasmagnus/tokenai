import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tokenai/components/atoms/button.dart';
import 'package:tokenai/components/molecules/input/text_input.dart';
import 'package:tokenai/components/molecules/text_link_footer.dart';
import 'package:tokenai/components/organisms/custom_form.dart';
import 'package:tokenai/components/templates/logo_header_template.dart';
import 'package:tokenai/utils/validator_utils.dart';

class SignUpTemplate extends StatelessWidget {
  final VoidCallback onSignInPressed;
  final void Function(String name, String email) onNextPressed;

  const SignUpTemplate({
    required this.onSignInPressed,
    required this.onNextPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LogoHeaderTemplate(
      footer: _footer(context),
      child: _form(context),
    );
  }

  Widget _form(BuildContext context) {
    return CustomForm(
      title: AppLocalizations.of(context)!.create_an_account_string,
      builder: (GlobalKey<FormState> key) {
        String? name;
        String? email;
        return [
          TextInput(
            label: AppLocalizations.of(context)!.full_name_string,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: (String? value) =>
                value == null || value.isEmpty ? AppLocalizations.of(context)!.empty_name_error : null,
            onSaved: (String? value) => name = value,
          ),
          const SizedBox(
            height: 32,
          ),
          TextInput(
            label: AppLocalizations.of(context)!.email_string,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            validator: (String? value) => emailValidator(value, context),
            onSaved: (String? value) => email = value,
          ),
          const SizedBox(
            height: 48,
          ),
          Button(
            label: AppLocalizations.of(context)!.next_string,
            type: ButtonType.PRIMARY,
            onPressed: () {
              if (key.currentState?.validate() ?? false) {
                key.currentState?.save();
                onNextPressed(name!, email!);
              }
            },
          ),
          const SizedBox(
            height: 16,
          ),
        ];
      },
    );
  }

  Widget _footer(BuildContext context) {
    return TextLinkFooter(
      text: AppLocalizations.of(context)!.already_a_member_question,
      textLink: AppLocalizations.of(context)!.sign_in_string,
      onPressed: onSignInPressed,
    );
  }
}
