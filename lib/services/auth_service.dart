import 'dart:convert';

import 'package:fang/classes.dart';
import 'package:fang/services/account_service.dart';
import 'package:fang/services/api_service.dart';
import 'package:fang/services/socket_service.dart';
import 'package:fang/storage/auth_storage.dart';
import 'package:fang/utils/jwt_decoder.dart';

class AuthService extends ApiService {
  final AccountService _accountService = AccountService();

  AuthService();

  /// Login with email and password
  /// Returns true if successful, false otherwise
  Future<bool> login(String email, String password) async {
    try {
      final Device device = await Device.getData();
      final res = await postRequest(
        '/auth/login',
        body: {'email': email, 'password': password, 'device': device.toJson()},
        includeAuth: false, // Don't include auth for login
      );

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        final authData = AuthData.fromJson(json);

        // Save tokens
        await AuthStorage.saveToken(authData.accessToken);
        await AuthStorage.saveSession(authData.sessionId);

        // Decode JWT to get accountId
        final payload = JwtDecoder.decode(authData.accessToken);
        if (payload != null && payload['id'] != null) {
          final accountId = payload['id'] as String;
          await AuthStorage.saveAccountId(accountId);

          // Fetch account to get profileId
          final account = await _accountService.getCurrent(accountId);
          if (account != null && account.activeProfileId != null) {
            await AuthStorage.saveProfileId(account.activeProfileId!);
          }

          // Connect socket after successful login
          await SocketService.instance.connect();

          return true;
        }
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  /// Register a new account
  Future<bool> register({
    required String email,
    required String password,
    String? phoneNumber,
    String? countryId,
    required String firstName,
    String? lastName,
    String? flag,
  }) async {
    try {
      final res = await postRequest(
        '/auth/register',
        body: {
          'email': email,
          'password': password,
          if (phoneNumber != null) 'phoneNumber': phoneNumber,
          if (countryId != null) 'countryId': countryId,
          'firstName': firstName,
          if (lastName != null) 'lastName': lastName,
          if (flag != null) 'flag': flag,
        },
        includeAuth: false,
      );

      return res.statusCode == 201;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  /// Refresh access token
  Future<bool> refresh() async {
    try {
      final token = await AuthStorage.getToken();
      final sessionId = await AuthStorage.getSessionId();

      if (token == null || sessionId == null) {
        return false;
      }

      final res = await postRequest(
        '/auth/refresh',
        body: {'token': token, 'sessionId': sessionId},
        includeAuth: false,
      );

      if (res.statusCode == 201) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        final authData = AuthData.fromJson(json);

        await AuthStorage.saveToken(authData.accessToken);
        await AuthStorage.saveSession(authData.sessionId);
        return true;
      }
      return false;
    } catch (e) {
      print('Refresh error: $e');
      return false;
    }
  }

  /// Logout and clear all stored data
  Future<void> logout() async {
    try {
      final sessionId = await AuthStorage.getSessionId();
      if (sessionId != null) {
        await postRequest('/auth/logout', body: {'sessionId': sessionId});
      }
    } catch (e) {
      print('Logout error: $e');
    } finally {
      // Disconnect socket
      SocketService.instance.disconnect();

      // Clear all stored data
      await AuthStorage.clear();
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await AuthStorage.getToken();
    final sessionId = await AuthStorage.getSessionId();
    return token != null && sessionId != null;
  }
}
