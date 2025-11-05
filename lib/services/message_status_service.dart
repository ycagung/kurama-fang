import 'dart:convert';

import 'package:fang/classes.dart';
import 'package:http/http.dart' as http;

class MessageStatusService {
  final String uri = String.fromEnvironment('PUBLIC_API_URL');

  MessageStatusService();

  Future<List<MessageStatusData>> getAll() async {
    final res = await http.get(Uri.parse('$uri/messageStatus'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
      return data.map((e) => MessageStatusData.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<MessageStatusData?> getById(String id) async {
    final res = await http.get(Uri.parse('$uri/messageStatus/$id'));
    if (res.statusCode == 200) {
      return MessageStatusData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<MessageStatusData?> create(MessageStatusData data) async {
    final res = await http.post(
      Uri.parse('$uri/messageStatus'),
      body: jsonEncode(data.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 201 || res.statusCode == 200) {
      return MessageStatusData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<MessageStatusData?> update(String id, MessageStatusData data) async {
    final res = await http.put(
      Uri.parse('$uri/messageStatus/$id'),
      body: jsonEncode(data.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) {
      return MessageStatusData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<bool> delete(String id) async {
    final res = await http.delete(Uri.parse('$uri/messageStatus/$id'));
    return res.statusCode == 200 || res.statusCode == 204;
  }
}
