// import 'package:fang/classes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    final expiry = DateTime.now()
        .add(Duration(minutes: 15))
        .millisecondsSinceEpoch;

    await _storage.write(key: 'accessToken', value: token);
    await _storage.write(key: 'accesTokenExpiry', value: expiry.toString());
  }

  static Future<void> saveSession(String sessionId) async {
    final expiry = DateTime.now().add(Duration(days: 7)).millisecondsSinceEpoch;

    await _storage.write(key: 'SessionId', value: sessionId);
    await _storage.write(key: 'sessionIdExpiry', value: expiry.toString());
  }

  static Future<String?> getToken() async {
    final accessToken = await _storage.read(key: 'accessToken');
    final accessTokenExpiry = await _storage.read(key: 'accessTokenExpiry');

    if (accessTokenExpiry != null) {
      final expiry = DateTime.fromMillisecondsSinceEpoch(
        int.parse(accessTokenExpiry),
      );

      if (DateTime.now().isAfter(expiry)) {
        await _storage.delete(key: 'accessToken');
        await _storage.delete(key: 'accessTokenExpiry');
        return null;
      }
    }

    return accessToken;
  }

  static Future<String?> getSessionId() async {
    final sessionId = await _storage.read(key: 'sessionId');
    final sessionIdExpiry = await _storage.read(key: 'sessionIdExpiry');

    if (sessionIdExpiry != null) {
      final expiry = DateTime.fromMillisecondsSinceEpoch(
        int.parse(sessionIdExpiry),
      );

      if (DateTime.now().isAfter(expiry)) {
        await _storage.delete(key: 'sessionId');
        await _storage.delete(key: 'sessionIdExpiry');
        return null;
      }
    }

    return sessionId;
  }

  static Future<void> saveAccountId(String accountId) async {
    await _storage.write(key: 'accountId', value: accountId);
  }

  static Future<String?> getAccountId() async {
    return await _storage.read(key: 'accountId');
  }

  static Future<void> saveProfileId(String profileId) async {
    await _storage.write(key: 'profileId', value: profileId);
  }

  static Future<String?> getProfileId() async {
    return await _storage.read(key: 'profileId');
  }

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
