import 'dart:convert';

import 'package:fang/classes.dart';
import 'package:http/http.dart' as http;

class DeviceService {
  final String uri = String.fromEnvironment('PUBLIC_API_URL');

  DeviceService();

  Future<List<Device>> getAll() async {
    final res = await http.get(Uri.parse('$uri/device'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
      return data.map((e) => Device.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<Device?> getById(String id) async {
    final res = await http.get(Uri.parse('$uri/device/$id'));
    if (res.statusCode == 200) {
      return Device.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<Device?> create(Device data) async {
    final res = await http.post(
      Uri.parse('$uri/device'),
      body: jsonEncode(data.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 201 || res.statusCode == 200) {
      return Device.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<Device?> update(String id, Device data) async {
    final res = await http.put(
      Uri.parse('$uri/device/$id'),
      body: jsonEncode(data.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) {
      return Device.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<bool> delete(String id) async {
    final res = await http.delete(Uri.parse('$uri/device/$id'));
    return res.statusCode == 200 || res.statusCode == 204;
  }
}
