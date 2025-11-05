import 'dart:convert';

import 'package:fang/classes.dart';
import 'package:fang/services/api_service.dart';

class MessageService extends ApiService {
  MessageService();

  /// Send a message via REST API
  /// Returns list of recipient profileIds if successful
  Future<List<String>?> sendMessage({
    required String id,
    required String chatId,
    required String senderId,
    required String content,
    required String statusId,
  }) async {
    final body = {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'statusId': statusId,
    };

    final res = await postRequest('/message/send', body: body);
    if (res.statusCode == 201) {
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      final parties = json['parties'] as List<dynamic>?;
      return parties?.map((e) => e.toString()).toList();
    }
    return null;
  }

  /// Get the last message in a chat
  Future<Map<String, dynamic>?> getLastMessage(String chatId) async {
    final res = await getRequest('/message/last/$chatId');
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    return null;
  }

  // Legacy methods for compatibility
  Future<List<MessageData>> getAll() async {
    final res = await getRequest('/message');
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
      return data.map((e) => MessageData.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<MessageData?> getById(String id) async {
    final res = await getRequest('/message/$id');
    if (res.statusCode == 200) {
      return MessageData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<MessageData?> create(MessageData data) async {
    final res = await postRequest('/message', body: data.toJson());
    if (res.statusCode == 201 || res.statusCode == 200) {
      return MessageData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<MessageData?> update(String id, MessageData data) async {
    final res = await putRequest('/message/$id', body: data.toJson());
    if (res.statusCode == 200) {
      return MessageData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<bool> delete(String id) async {
    final res = await deleteRequest('/message/$id');
    return res.statusCode == 200 || res.statusCode == 204;
  }
}
