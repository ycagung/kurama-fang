import 'dart:convert';

import 'package:fang/classes.dart';
import 'package:http/http.dart' as http;

class ContactService {
  final String uri = String.fromEnvironment('PUBLIC_API_URL');

  ContactService();

  Future<List<ContactData>> getAll() async {
    final res = await http.get(Uri.parse('$uri/contact'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
      return data.map((e) => ContactData.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<ContactData?> getById(String id) async {
    final res = await http.get(Uri.parse('$uri/contact/$id'));
    if (res.statusCode == 200) {
      return ContactData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<ContactData?> create(ContactData data) async {
    final res = await http.post(
      Uri.parse('$uri/contact'),
      body: jsonEncode(data.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 201 || res.statusCode == 200) {
      return ContactData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<ContactData?> update(String id, ContactData data) async {
    final res = await http.put(
      Uri.parse('$uri/contact/$id'),
      body: jsonEncode(data.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) {
      return ContactData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<bool> delete(String id) async {
    final res = await http.delete(Uri.parse('$uri/contact/$id'));
    return res.statusCode == 200 || res.statusCode == 204;
  }
}
