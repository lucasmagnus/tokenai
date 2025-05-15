part of 'asset_bloc.dart';

abstract class AssetEvent extends Equatable {
  const AssetEvent();

  @override
  List<Object> get props => [];
}

class CreateAsset extends AssetEvent {
  final String code;
  final Map<String, bool> flags;

  const CreateAsset({required this.code, required this.flags});

  @override
  List<Object> get props => [code];
}

class ListAssets extends AssetEvent {
  const ListAssets();

  @override
  List<Object> get props => [];
}

class ListTransactions extends AssetEvent {
  const ListTransactions();

  @override
  List<Object> get props => [];
}

class MintAsset extends AssetEvent {
  final String code;
  final double amount;

  const MintAsset({
    required this.code,
    required this.amount,
  });

  @override
  List<Object> get props => [code, amount];
}

class BurnAsset extends AssetEvent {
  final String code;
  final double amount;

  const BurnAsset({
    required this.code,
    required this.amount,
  });

  @override
  List<Object> get props => [code, amount];
}

class Payment extends AssetEvent {
  final String userWallet;
  final String contactWallet;
  final String amount;
  final String issuer;
  final String code;

  const Payment({
    required this.userWallet,
    required this.contactWallet,
    required this.amount,
    required this.issuer,
    required this.code,
  });

  @override
  List<Object> get props => [userWallet, contactWallet, amount, issuer, code];
}
