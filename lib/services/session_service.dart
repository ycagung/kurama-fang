import 'dart:convert';

import 'package:fang/classes.dart';
import 'package:http/http.dart' as http;

class SessionService {
  final String uri = String.fromEnvironment('PUBLIC_API_URL');

  SessionService();

  Future<List<SessionData>> getAll() async {
    final res = await http.get(Uri.parse('$uri/session'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
      return data
          .map((e) => SessionData.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<SessionData?> getById(String id) async {
    final res = await http.get(Uri.parse('$uri/session/$id'));
    if (res.statusCode == 200) {
      return SessionData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<SessionData?> create(SessionData data) async {
    final res = await http.post(
      Uri.parse('$uri/session'),
      body: jsonEncode(data.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 201 || res.statusCode == 200) {
      return SessionData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<SessionData?> update(String id, SessionData data) async {
    final res = await http.put(
      Uri.parse('$uri/session/$id'),
      body: jsonEncode(data.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) {
      return SessionData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<bool> delete(String id) async {
    final res = await http.delete(Uri.parse('$uri/session/$id'));
    return res.statusCode == 200 || res.statusCode == 204;
  }
}
