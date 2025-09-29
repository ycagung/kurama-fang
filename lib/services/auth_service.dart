import 'dart:convert';

import 'package:fang/classes.dart';
import 'package:fang/storage/auth_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String uri = String.fromEnvironment('PUBLIC_API_URL');

  AuthService();

  Future<void> login(String email, String password) async {
    final Device device = await Device.getData();
    final res = await http.post(
      Uri.parse('$uri/auth/login'),
      body: jsonEncode({
        "email": email,
        "password": password,
        "device": device.toJson(),
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (res.statusCode == 200) {
      final authData = AuthData.fromJson(jsonDecode(res.body));

      await AuthStorage.saveToken(authData.accessToken);
      await AuthStorage.saveSession(authData.sessionId);

      // return authData;
    }

    // return null;
  }

  Future<void> refresh() async {
    final String token = (await AuthStorage.getToken())!;
    final String sessionId = (await AuthStorage.getSessionId())!;

    final res = await http.post(
      Uri.parse('$uri/auth/refresh'),
      body: jsonEncode({'token': token, 'sessionId': sessionId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (res.statusCode == 201) {
      final authData = AuthData.fromJson(jsonDecode(res.body));

      await AuthStorage.saveToken(authData.accessToken);
      await AuthStorage.saveSession(authData.sessionId);
    }
  }

  Future<void> logout() async {}
}
