abstract class SecureStorageService {
  Future<void> saveSecretKey(String secretKey);
  Future<void> savePublicKey(String publicKey);
  Future<void> saveMnemonic(String mnemonic);
  Future<String?> getSecretKey();
  Future<String?> getPublicKey();
  Future<String?> getMnemonic();
  Future<Map<String, String?>> getAllKeys();
  Future<void> clearAllKeys();
} 