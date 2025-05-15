import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokenai/app/auth/domain/repositories/auth_repository.dart';
import 'package:tokenai/app/core/domain/models/request_status.dart';

part 'wallet_event.dart';

part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final AuthRepository _authRepository;

  WalletBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(WalletState.initial()) {
    on<AccessWallet>(_accessWallet);
    on<CreateWallet>(_createWallet);
    on<ConfirmWalletCreation>(_confirmWalletCreation);
  }

  Future<void> _accessWallet(AccessWallet event, Emitter emit) async {
    emit(state.copyWith(accessWalletStatus: const Loading()));

    final response = await _authRepository.accessWallet(phrase: event.phrase);

    response.when(success: ((data) async {}));

    emit(state.copyWith(accessWalletStatus: response));
  }

  void _createWallet(CreateWallet event, Emitter emit) async {
    emit(state.copyWith(createWalletStatus: const Loading()));

    final response = await _authRepository.createWallet();
    emit(state.copyWith(createWalletStatus: response));
  }

  Future<void> _confirmWalletCreation(ConfirmWalletCreation event, Emitter emit) async {
    emit(state.copyWith(confirmWalletStatus: const Loading()));

    final response = await _authRepository.confirmWalletCreation(mnemonicWords: event.mnemonicWords);
    emit(state.copyWith(confirmWalletStatus: response));
  }
}
