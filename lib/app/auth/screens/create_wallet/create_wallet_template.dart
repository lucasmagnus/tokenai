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
import 'package:flutter/services.dart';

class CreateWalletTemplate extends StatelessWidget {
  final List<String> mnemonicWords;
  final VoidCallback onConfirmPressed;

  const CreateWalletTemplate({
    required this.mnemonicWords,
    required this.onConfirmPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LogoHeaderTemplate(
      avoidHeaderPadding: true,
      child: _form(context),
    );
  }

  Widget _form(BuildContext context) {
    return CustomForm(
      title: AppLocalizations.of(context)!.backup_your_wallet,
      builder: (GlobalKey<FormState> key) {
        return [
          Text(
            AppLocalizations.of(context)!.write_down_words,
            style: TextStyle(
              color: Theme.of(context).kTextColor,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
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
                for (int i = 0; i < mnemonicWords.length; i += 2)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: _WordTile(
                            index: i + 1,
                            word: mnemonicWords[i],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _WordTile(
                            index: i + 2,
                            word: mnemonicWords[i + 1],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          IconButton(
            icon: Icon(Icons.copy, color: Theme.of(context).kTextColor),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: mnemonicWords.join(' ')));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.phrase_copied),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.never_share_warning,
            style: TextStyle(
              color: Theme.of(context).kAlertDangerColor,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          BlocBuilder<WalletBloc, WalletState>(
            builder: (context, state) {
              return Button(
                label: AppLocalizations.of(context)!.confirm_recovery_phrase,
                type: ButtonType.PRIMARY,
                loading: state.confirmWalletStatus is Loading,
                onPressed: onConfirmPressed,
              );
            },
          ),
        ];
      },
    );
  }
}

class _WordTile extends StatelessWidget {
  final int index;
  final String word;

  const _WordTile({
    required this.index,
    required this.word,
  });

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
            style: TextStyle(
              color: Theme.of(context).kTextColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            word,
            style: TextStyle(
              color: Theme.of(context).kTextColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
} 