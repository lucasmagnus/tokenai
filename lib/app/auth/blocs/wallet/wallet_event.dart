part of 'wallet_bloc.dart';

abstract class WalletEvent {
  const WalletEvent();
}

class AccessWallet extends WalletEvent {
  final String phrase;

  const AccessWallet({
    required this.phrase,
  });
}

class CreateWallet extends WalletEvent {
  const CreateWallet();
}

class ConfirmWalletCreation extends WalletEvent {
  final List<String> mnemonicWords;

  const ConfirmWalletCreation({
    required this.mnemonicWords,
  });
}
