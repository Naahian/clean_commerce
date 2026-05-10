import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage storage;

  SecureStorageService(this.storage);

  static final kAccessToken = "accessToken";
  static final kRefreshToken = "refreshToken";

  // Auth
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await storage.write(key: kAccessToken, value: accessToken);
    await storage.write(key: kRefreshToken, value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: kAccessToken);
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: kRefreshToken);
  }

  Future<void> clearTokens() async {
    await storage.delete(key: kAccessToken);
    await storage.delete(key: kRefreshToken);
  }

  // global
  Future<void> clearAll() async {
    await storage.deleteAll();
  }
}
