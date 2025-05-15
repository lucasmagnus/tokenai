import 'package:tokenai/app/core/domain/models/authorization.dart';
import 'package:tokenai/app/core/domain/models/request_status.dart';

abstract interface class AuthRepository {
  Future<RequestStatus> createWallet();

  Future<RequestStatus> accessWallet({required String phrase});

  Future<RequestStatus> confirmWalletCreation({required List<String> mnemonicWords});
}
