import 'dart:convert';
import 'dart:typed_data';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';
import 'package:tokenai/app/core/domain/services/secure_storage_service.dart';

class StellarService {
  final SecureStorageService _secureStorageService;
  final StellarSDK _sdk;

  StellarService(this._secureStorageService) : _sdk = StellarSDK.TESTNET;

  Future<bool> signTransaction(String operationXdrBase64) async {
    try {
      final secretKey = await _secureStorageService.getSecretKey();
      if (secretKey == null) {
        throw Exception("Secret key not found");
      }

      final keyPair = KeyPair.fromSecretSeed(secretKey);

      Uint8List bytes = base64Decode(operationXdrBase64);
      XdrTransactionEnvelope transactionEnvelope =
      XdrTransactionEnvelope.decode(XdrDataInputStream(bytes));

      final transaction = Transaction.fromV1EnvelopeXdr(transactionEnvelope.v1!);
      transaction.sign(keyPair, Network.TESTNET);
      final response = await _sdk.submitTransaction(transaction);

      return response.success;
    } catch (e) {
      throw Exception("Failed to sign transaction: $e");
    }
  }
}