import 'dart:convert';

import 'package:fang/classes.dart';
import 'package:http/http.dart' as http;

class ScheduleMemberService {
  final String uri = String.fromEnvironment('PUBLIC_API_URL');

  ScheduleMemberService();

  Future<List<ScheduleMemberData>> getAll() async {
    final res = await http.get(Uri.parse('$uri/scheduleMember'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
      return data.map((e) => ScheduleMemberData.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<ScheduleMemberData?> getById(dynamic id) async {
    final res = await http.get(Uri.parse('$uri/scheduleMember/$id'));
    if (res.statusCode == 200) {
      return ScheduleMemberData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<ScheduleMemberData?> create(ScheduleMemberData data) async {
    final res = await http.post(
      Uri.parse('$uri/scheduleMember'),
      body: jsonEncode(data.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 201 || res.statusCode == 200) {
      return ScheduleMemberData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<ScheduleMemberData?> update(dynamic id, ScheduleMemberData data) async {
    final res = await http.put(
      Uri.parse('$uri/scheduleMember/$id'),
      body: jsonEncode(data.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) {
      return ScheduleMemberData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<bool> delete(dynamic id) async {
    final res = await http.delete(Uri.parse('$uri/scheduleMember/$id'));
    return res.statusCode == 200 || res.statusCode == 204;
  }
}
