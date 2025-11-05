import 'dart:convert';

import 'package:fang/classes.dart';
import 'package:http/http.dart' as http;

class AttachmentService {
  final String uri = String.fromEnvironment('PUBLIC_API_URL');

  AttachmentService();

  Future<List<AttachmentData>> getAll() async {
    final res = await http.get(Uri.parse('$uri/attachment'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
      return data.map((e) => AttachmentData.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<AttachmentData?> getById(dynamic id) async {
    final res = await http.get(Uri.parse('$uri/attachment/$id'));
    if (res.statusCode == 200) {
      return AttachmentData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<AttachmentData?> create(AttachmentData data) async {
    final res = await http.post(
      Uri.parse('$uri/attachment'),
      body: jsonEncode(data.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 201 || res.statusCode == 200) {
      return AttachmentData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<AttachmentData?> update(dynamic id, AttachmentData data) async {
    final res = await http.put(
      Uri.parse('$uri/attachment/$id'),
      body: jsonEncode(data.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) {
      return AttachmentData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<bool> delete(dynamic id) async {
    final res = await http.delete(Uri.parse('$uri/attachment/$id'));
    return res.statusCode == 200 || res.statusCode == 204;
  }
}
