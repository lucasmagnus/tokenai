import 'dart:typed_data';

import 'package:tokenai/app/auth/domain/repositories/auth_repository.dart';
import 'package:tokenai/app/core/domain/models/request_status.dart';
import 'package:tokenai/app/core/domain/services/secure_storage_service.dart';
import 'package:bip39_mnemonic/bip39_mnemonic.dart' as bip39;
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SecureStorageService _secureStorageService;

  AuthRepositoryImpl(this._secureStorageService);

  @override
  Future<RequestStatus> createWallet() async {
    try {
      final mnemonic = bip39.Mnemonic.generate(
        bip39.Language.english,
        entropyLength: 128,
      );
      final seed = mnemonic.seed;

      final keyData = await ED25519_HD_KEY.derivePath("m/44'/148'/0'", seed);
      final secretSeed = StrKey.encodeStellarSecretSeed(
        Uint8List.fromList(keyData.key),
      );
      final keyPair = KeyPair.fromSecretSeed(secretSeed);
      await FriendBot.fundTestAccount(keyPair.accountId);

      print('public Key: ${keyPair.accountId}');
      print('secret Key: ${keyPair.secretSeed}');

      return Success(mnemonic.sentence.split(' '));
    } on Exception catch (error) {
      return Error(exception: error);
    }
  }

  @override
  Future<RequestStatus> accessWallet({required String phrase}) async {
    try {
      final mnemonic = bip39.Mnemonic.fromSentence(
        phrase,
        bip39.Language.english,
      );

      final seed = mnemonic.seed;
      final keyData = await ED25519_HD_KEY.derivePath("m/44'/148'/0'", seed);

      final secretSeed = StrKey.encodeStellarSecretSeed(
        Uint8List.fromList(keyData.key),
      );

      final keyPair = KeyPair.fromSecretSeed(secretSeed);

      // Save the keys securely
      await _secureStorageService.saveSecretKey(keyPair.secretSeed);
      await _secureStorageService.savePublicKey(keyPair.accountId);
      await _secureStorageService.saveMnemonic(phrase);

      return Success({
        'accountId': keyPair.accountId,
        'secretKey': keyPair.secretSeed,
      });
    } catch (error) {
      return Error(
        exception: error is Exception ? error : Exception(error.toString()),
      );
    }
  }

  @override
  Future<RequestStatus> confirmWalletCreation({required List<String> mnemonicWords}) async {
    try {
      final mnemonic = bip39.Mnemonic.fromSentence(
        mnemonicWords.join(' '),
        bip39.Language.english,
      );

      final seed = mnemonic.seed;
      final keyData = await ED25519_HD_KEY.derivePath("m/44'/148'/0'", seed);

      final secretSeed = StrKey.encodeStellarSecretSeed(
        Uint8List.fromList(keyData.key),
      );

      final keyPair = KeyPair.fromSecretSeed(secretSeed);

      // Save the keys securely
      await _secureStorageService.saveSecretKey(keyPair.secretSeed);
      await _secureStorageService.savePublicKey(keyPair.accountId);
      await _secureStorageService.saveMnemonic(mnemonicWords.join(' '));

      return const Success(null);
    } catch (error) {
      return Error(
        exception: error is Exception ? error : Exception(error.toString()),
      );
    }
  }
}
