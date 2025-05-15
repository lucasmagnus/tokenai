import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokenai/app/auth/blocs/wallet/wallet_bloc.dart';
import 'package:tokenai/app/auth/screens/signin/sign_in_template.dart';
import 'package:tokenai/app/auth/screens/create_wallet/create_wallet_screen.dart';
import 'package:tokenai/app/core/screens/main/main_screen.dart';
import 'package:tokenai/services/snackbar.dart';

class SignInScreen extends StatelessWidget {
  static const ROUTE_NAME = 'sign-in';

  final WalletBloc _walletBloc;

  const SignInScreen(this._walletBloc, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _walletBloc,
      child: BlocListener<WalletBloc, WalletState>(
        bloc: _walletBloc,
        listener: signInBlocListener,
        child: SignInTemplate(
          onSignInPressed:
              (phrase) => _walletBloc.add(AccessWallet(phrase: phrase)),
          onSignUpPressed: () => _walletBloc.add(CreateWallet()),
        ),
      ),
    );
  }

  void signInBlocListener(context, state) {
    state.accessWalletStatus.when(
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

    state.createWalletStatus.when(
      success: (data) {
        Navigator.pushNamed(
          context,
          CreateWalletScreen.ROUTE_NAME,
          arguments: data,
        );
      },
      error: (code, message, exception) {
        SnackBarService.of(context).error(exception, message);
      },
    );
  }
}
