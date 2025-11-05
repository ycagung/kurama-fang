import 'dart:convert';

import 'package:fang/classes.dart';
import 'package:http/http.dart' as http;

class ChatParticipantsService {
  final String uri = String.fromEnvironment('PUBLIC_API_URL');

  ChatParticipantsService();

  Future<List<ChatParticipantData>> getAll() async {
    final res = await http.get(Uri.parse('$uri/chatParticipants'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
      return data.map((e) => ChatParticipantData.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<ChatParticipantData?> getById(String id) async {
    final res = await http.get(Uri.parse('$uri/chatParticipants/$id'));
    if (res.statusCode == 200) {
      return ChatParticipantData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<ChatParticipantData?> create(ChatParticipantData data) async {
    final res = await http.post(
      Uri.parse('$uri/chatParticipants'),
      body: jsonEncode(data.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 201 || res.statusCode == 200) {
      return ChatParticipantData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<ChatParticipantData?> update(String id, ChatParticipantData data) async {
    final res = await http.put(
      Uri.parse('$uri/chatParticipants/$id'),
      body: jsonEncode(data.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) {
      return ChatParticipantData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<bool> delete(String id) async {
    final res = await http.delete(Uri.parse('$uri/chatParticipants/$id'));
    return res.statusCode == 200 || res.statusCode == 204;
  }
}
