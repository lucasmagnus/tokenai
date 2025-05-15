import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tokenai/app/auth/blocs/wallet/wallet_bloc.dart';
import 'package:tokenai/app/core/domain/models/request_status.dart';
import 'package:tokenai/components/atoms/button.dart';
import 'package:tokenai/components/molecules/text_link_footer.dart';
import 'package:tokenai/components/organisms/custom_form.dart';
import 'package:tokenai/components/templates/logo_header_template.dart';
import 'package:tokenai/constants/all.dart';

class SignInTemplate extends StatelessWidget {
  final void Function(String phrase) onSignInPressed;
  final VoidCallback onSignUpPressed;

  const SignInTemplate({
    required this.onSignInPressed,
    required this.onSignUpPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LogoHeaderTemplate(avoidHeaderPadding: true, child: _form(context));
  }

  Widget _form(BuildContext context) {
    return CustomForm(
      title: AppLocalizations.of(context)!.welcome_back_string,
      builder: (GlobalKey<FormState> key) {
        final List<String?> words = List<String?>.filled(12, null);

        return [
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).kBackgroundColorLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).kPrimaryColor),
            ),
            child: Column(
              children: [
                for (int i = 0; i < 12; i += 2)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: _WordInput(
                            index: i + 1,
                            onSaved: (value) => words[i] = value?.trim(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _WordInput(
                            index: i + 2,
                            onSaved: (value) => words[i + 1] = value?.trim(),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          BlocBuilder<WalletBloc, WalletState>(
            builder: (context, state) {
              return Button(
                label: AppLocalizations.of(context)!.access_wallet_string,
                type: ButtonType.PRIMARY,
                loading: state.accessWalletStatus is Loading,
                onPressed: () {
                  if (key.currentState?.validate() ?? false) {
                    key.currentState?.save();
                    final phrase = words.join(' ');
                    onSignInPressed(phrase);
                  }
                },
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: Theme.of(context).kTextColor.withOpacity(0.2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'OR',
                  style: TextStyle(
                    color: Theme.of(context).kTextColor.withOpacity(0.5),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: Theme.of(context).kTextColor.withOpacity(0.2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          BlocBuilder<WalletBloc, WalletState>(
            builder: (context, state) {
              return Button(
                label: AppLocalizations.of(context)!.create_wallet_string,
                type: ButtonType.TERTIARY,
                loading: state.createWalletStatus is Loading,
                onPressed: () {
                  onSignUpPressed();
                },
              );
            },
          ),
        ];
      },
    );
  }
}

class _WordInput extends StatelessWidget {
  final int index;
  final void Function(String?)? onSaved;

  const _WordInput({required this.index, required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).kBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            '$index.',
            style: TextStyle(color: Theme.of(context).kTextColor, fontSize: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              textInputAction: TextInputAction.next,
              style: TextStyle(
                color: Theme.of(context).kTextColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '';
                }
                return null;
              },
              onSaved: onSaved,
            ),
          ),
        ],
      ),
    );
  }
}
