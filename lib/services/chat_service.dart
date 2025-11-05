import 'dart:convert';

import 'package:fang/classes.dart';
import 'package:fang/services/api_service.dart';

class ChatService extends ApiService {
  ChatService();

  /// Get all personal chats for a profile
  Future<List<DisplayChatData>> getPersonalChats(String profileId) async {
    final res = await getRequest('/chat/personal?profileId=$profileId');
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      final chatRooms = json['chatRooms'] as List<dynamic>? ?? [];
      return chatRooms
          .map((e) => DisplayChatData.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Get a specific chat room with messages and partner info
  Future<Map<String, dynamic>?> getChatById(
    String profileId,
    String chatId,
  ) async {
    final res = await getRequest('/chat/personal/$profileId/$chatId');
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    return null;
  }

  /// Create a new chat room
  /// Returns the chatId if successful, null otherwise
  Future<String?> createChat({
    required String chatType, // 'p' for personal, 'g' for group
    String? partyAId,
    String? partyBId,
    String? groupId,
  }) async {
    final body = {
      'chatType': chatType,
      if (chatType == 'p') ...{
        'partyAId': partyAId,
        'partyBId': partyBId,
      },
      if (chatType == 'g') ...{
        'groupId': groupId,
      },
    };

    final res = await postRequest('/chat/insert', body: body);
    if (res.statusCode == 201) {
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      return json['chatId'] as String?;
    } else if (res.statusCode == 406) {
      // Chat room already exists
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      return json['chatId'] as String?;
    }
    return null;
  }

  // Legacy methods for compatibility
  Future<List<ChatData>> getAll() async {
    final res = await getRequest('/chat');
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
      return data.map((e) => ChatData.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<ChatData?> getById(String id) async {
    final res = await getRequest('/chat/$id');
    if (res.statusCode == 200) {
      return ChatData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<ChatData?> create(ChatData data) async {
    final res = await postRequest('/chat', body: data.toJson());
    if (res.statusCode == 201 || res.statusCode == 200) {
      return ChatData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<ChatData?> update(String id, ChatData data) async {
    final res = await putRequest('/chat/$id', body: data.toJson());
    if (res.statusCode == 200) {
      return ChatData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<bool> delete(String id) async {
    final res = await deleteRequest('/chat/$id');
    return res.statusCode == 200 || res.statusCode == 204;
  }
}
