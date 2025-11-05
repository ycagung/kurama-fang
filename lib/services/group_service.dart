import 'dart:convert';

import 'package:fang/classes.dart';
import 'package:http/http.dart' as http;

class GroupService {
  final String uri = String.fromEnvironment('PUBLIC_API_URL');

  GroupService();

  Future<List<GroupData>> getAll() async {
    final res = await http.get(Uri.parse('$uri/group'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
      return data.map((e) => GroupData.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<GroupData?> getById(String id) async {
    final res = await http.get(Uri.parse('$uri/group/$id'));
    if (res.statusCode == 200) {
      return GroupData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<GroupData?> create(GroupData data) async {
    final res = await http.post(
      Uri.parse('$uri/group'),
      body: jsonEncode(data.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 201 || res.statusCode == 200) {
      return GroupData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<GroupData?> update(String id, GroupData data) async {
    final res = await http.put(
      Uri.parse('$uri/group/$id'),
      body: jsonEncode(data.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) {
      return GroupData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<bool> delete(String id) async {
    final res = await http.delete(Uri.parse('$uri/group/$id'));
    return res.statusCode == 200 || res.statusCode == 204;
  }
}
