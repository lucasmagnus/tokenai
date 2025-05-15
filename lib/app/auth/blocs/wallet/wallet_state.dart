part of 'wallet_bloc.dart';

class WalletState extends Equatable {
  final RequestStatus accessWalletStatus;
  final RequestStatus createWalletStatus;
  final RequestStatus confirmWalletStatus;

  const WalletState({
    required this.accessWalletStatus,
    required this.createWalletStatus,
    required this.confirmWalletStatus,
  });

  @override
  List<Object> get props => [accessWalletStatus, createWalletStatus, confirmWalletStatus];

  factory WalletState.initial() => const WalletState(
    accessWalletStatus: Idle(),
    createWalletStatus: Idle(),
    confirmWalletStatus: Idle(),
  );

  WalletState copyWith({
    RequestStatus? accessWalletStatus,
    RequestStatus? createWalletStatus,
    RequestStatus? confirmWalletStatus,
  }) {
    return WalletState(
      accessWalletStatus: accessWalletStatus ?? this.accessWalletStatus,
      createWalletStatus: createWalletStatus ?? this.createWalletStatus,
      confirmWalletStatus: confirmWalletStatus ?? this.confirmWalletStatus,
    );
  }
}
