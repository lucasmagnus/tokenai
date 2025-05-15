import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tokenai/app/auth/blocs/wallet/wallet_bloc.dart';

import 'screens/signin/sign_in_screen.dart';
import 'screens/create_wallet/create_wallet_screen.dart';

final Map<String, Widget Function(BuildContext)> authRoutes = {
  SignInScreen.ROUTE_NAME: (context) => SignInScreen(GetIt.I.get<WalletBloc>()),
  CreateWalletScreen.ROUTE_NAME: (context) => CreateWalletScreen(
        GetIt.I.get<WalletBloc>(),
        mnemonicWords: ModalRoute.of(context)!.settings.arguments as List<String>,
      ),
};
