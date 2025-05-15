import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tokenai/app/core/domain/services/secure_storage_service.dart';

class SecureStorageServiceImpl implements SecureStorageService {
  static const _secretKey = 'wallet_secret_key';
  static const _publicKey = 'wallet_public_key';
  static const _mnemonic = 'wallet_mnemonic';

  final FlutterSecureStorage _secureStorage;

  SecureStorageServiceImpl() : _secureStorage = const FlutterSecureStorage();

  @override
  Future<void> saveSecretKey(String secretKey) async {
    await _secureStorage.write(key: _secretKey, value: secretKey);
  }

  @override
  Future<void> savePublicKey(String publicKey) async {
    await _secureStorage.write(key: _publicKey, value: publicKey);
  }

  @override
  Future<void> saveMnemonic(String mnemonic) async {
    await _secureStorage.write(key: _mnemonic, value: mnemonic);
  }

  @override
  Future<String?> getSecretKey() async {
    return await _secureStorage.read(key: _secretKey);
  }

  @override
  Future<String?> getPublicKey() async {
    return await _secureStorage.read(key: _publicKey);
  }

  @override
  Future<String?> getMnemonic() async {
    return await _secureStorage.read(key: _mnemonic);
  }

  @override
  Future<Map<String, String?>> getAllKeys() async {
    final secretKey = await getSecretKey();
    final publicKey = await getPublicKey();
    final mnemonic = await getMnemonic();

    return {
      'secretKey': secretKey,
      'publicKey': publicKey,
      'mnemonic': mnemonic,
    };
  }

  @override
  Future<void> clearAllKeys() async {
    await _secureStorage.delete(key: _secretKey);
    await _secureStorage.delete(key: _publicKey);
    await _secureStorage.delete(key: _mnemonic);
  }
} 