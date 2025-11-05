import 'dart:convert';

import 'package:fang/classes.dart';
import 'package:http/http.dart' as http;

class ProfileFlagService {
  final String uri = String.fromEnvironment('PUBLIC_API_URL');

  ProfileFlagService();

  Future<List<ProfileFlagData>> getAll() async {
    final res = await http.get(Uri.parse('$uri/profileFlag'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
      return data
          .map((e) => ProfileFlagData.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<ProfileFlagData?> getById(String id) async {
    final res = await http.get(Uri.parse('$uri/profileFlag/$id'));
    if (res.statusCode == 200) {
      return ProfileFlagData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<ProfileFlagData?> create(ProfileFlagData data) async {
    final res = await http.post(
      Uri.parse('$uri/profileFlag'),
      body: jsonEncode(data.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 201 || res.statusCode == 200) {
      return ProfileFlagData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<ProfileFlagData?> update(String id, ProfileFlagData data) async {
    final res = await http.put(
      Uri.parse('$uri/profileFlag/$id'),
      body: jsonEncode(data.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) {
      return ProfileFlagData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<bool> delete(String id) async {
    final res = await http.delete(Uri.parse('$uri/profileFlag/$id'));
    return res.statusCode == 200 || res.statusCode == 204;
  }
}
