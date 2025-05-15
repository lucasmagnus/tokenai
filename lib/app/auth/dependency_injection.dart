import 'package:tokenai/app/auth/blocs/wallet/wallet_bloc.dart';
import 'package:tokenai/app/auth/data/repositories/auth_repository_impl.dart';
import 'package:tokenai/app/auth/domain/repositories/auth_repository.dart';
import 'package:tokenai/app/core/data/services/secure_storage_service_impl.dart';
import 'package:tokenai/app/core/di/modules.dart';

void startAuthModules() {
  _repositoryModules();
  _blocModules();
}

void _blocModules() {
  getIt.registerFactory<WalletBloc>(() => WalletBloc(authRepository: getIt()));
}

void _repositoryModules() {
  getIt.registerSingleton<AuthRepository>(AuthRepositoryImpl(SecureStorageServiceImpl()));
}
