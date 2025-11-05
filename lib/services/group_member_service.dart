import 'dart:convert';

import 'package:fang/classes.dart';
import 'package:http/http.dart' as http;

class GroupMemberService {
  final String uri = String.fromEnvironment('PUBLIC_API_URL');

  GroupMemberService();

  Future<List<GroupMemberData>> getAll() async {
    final res = await http.get(Uri.parse('$uri/groupMember'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
      return data.map((e) => GroupMemberData.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<GroupMemberData?> getById(String id) async {
    final res = await http.get(Uri.parse('$uri/groupMember/$id'));
    if (res.statusCode == 200) {
      return GroupMemberData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<GroupMemberData?> create(GroupMemberData data) async {
    final res = await http.post(
      Uri.parse('$uri/groupMember'),
      body: jsonEncode(data.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 201 || res.statusCode == 200) {
      return GroupMemberData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<GroupMemberData?> update(String id, GroupMemberData data) async {
    final res = await http.put(
      Uri.parse('$uri/groupMember/$id'),
      body: jsonEncode(data.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) {
      return GroupMemberData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<bool> delete(String id) async {
    final res = await http.delete(Uri.parse('$uri/groupMember/$id'));
    return res.statusCode == 200 || res.statusCode == 204;
  }
}
