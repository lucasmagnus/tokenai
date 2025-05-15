import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokenai/app/auth/blocs/wallet/wallet_bloc.dart';
import 'package:tokenai/app/auth/screens/create_wallet/create_wallet_template.dart';
import 'package:tokenai/app/core/screens/main/main_screen.dart';
import 'package:tokenai/services/snackbar.dart';

class CreateWalletScreen extends StatelessWidget {
  static const ROUTE_NAME = 'create-wallet';

  final WalletBloc _walletBloc;
  final List<String> mnemonicWords;

  const CreateWalletScreen(
    this._walletBloc, {
    required this.mnemonicWords,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _walletBloc,
      child: BlocListener<WalletBloc, WalletState>(
        bloc: _walletBloc,
        listener: createWalletBlocListener,
        child: CreateWalletTemplate(
          mnemonicWords: mnemonicWords,
          onConfirmPressed: () => _walletBloc.add(ConfirmWalletCreation(mnemonicWords: mnemonicWords)),
        ),
      ),
    );
  }

  void createWalletBlocListener(context, state) {
    state.confirmWalletStatus.when(
      success: (data) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          MainScreen.ROUTE_NAME,
          (route) => false,
        );
      },
      error: (code, message, exception) {
        SnackBarService.of(context).error(exception, message);
      },
    );
  }
} 