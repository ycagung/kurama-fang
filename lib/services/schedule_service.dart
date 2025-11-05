import 'dart:convert';

import 'package:fang/classes.dart';
import 'package:http/http.dart' as http;

class ScheduleService {
  final String uri = String.fromEnvironment('PUBLIC_API_URL');

  ScheduleService();

  Future<List<ScheduleData>> getAll() async {
    final res = await http.get(Uri.parse('$uri/schedule'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
      return data.map((e) => ScheduleData.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<ScheduleData?> getById(dynamic id) async {
    final res = await http.get(Uri.parse('$uri/schedule/$id'));
    if (res.statusCode == 200) {
      return ScheduleData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<ScheduleData?> create(ScheduleData data) async {
    final res = await http.post(
      Uri.parse('$uri/schedule'),
      body: jsonEncode(data.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 201 || res.statusCode == 200) {
      return ScheduleData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<ScheduleData?> update(dynamic id, ScheduleData data) async {
    final res = await http.put(
      Uri.parse('$uri/schedule/$id'),
      body: jsonEncode(data.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) {
      return ScheduleData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<bool> delete(dynamic id) async {
    final res = await http.delete(Uri.parse('$uri/schedule/$id'));
    return res.statusCode == 200 || res.statusCode == 204;
  }
}
