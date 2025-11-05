import 'dart:convert';

import 'package:fang/classes.dart';
import 'package:http/http.dart' as http;

class ChatTypeService {
  final String uri = String.fromEnvironment('PUBLIC_API_URL');

  ChatTypeService();

  Future<List<ChatTypeData>> getAll() async {
    final res = await http.get(Uri.parse('$uri/chatType'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
      return data.map((e) => ChatTypeData.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<ChatTypeData?> getById(String id) async {
    final res = await http.get(Uri.parse('$uri/chatType/$id'));
    if (res.statusCode == 200) {
      return ChatTypeData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<ChatTypeData?> create(ChatTypeData data) async {
    final res = await http.post(
      Uri.parse('$uri/chatType'),
      body: jsonEncode(data.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 201 || res.statusCode == 200) {
      return ChatTypeData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<ChatTypeData?> update(String id, ChatTypeData data) async {
    final res = await http.put(
      Uri.parse('$uri/chatType/$id'),
      body: jsonEncode(data.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) {
      return ChatTypeData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<bool> delete(String id) async {
    final res = await http.delete(Uri.parse('$uri/chatType/$id'));
    return res.statusCode == 200 || res.statusCode == 204;
  }
}
