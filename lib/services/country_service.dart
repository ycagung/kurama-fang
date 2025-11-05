import 'dart:convert';

import 'package:fang/classes.dart';
import 'package:http/http.dart' as http;

class CountryService {
  final String uri = String.fromEnvironment('PUBLIC_API_URL');

  CountryService();

  Future<List<CountryData>> getAll() async {
    final res = await http.get(Uri.parse('$uri/country'));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
      return data.map((e) => CountryData.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<CountryData?> getById(dynamic id) async {
    final res = await http.get(Uri.parse('$uri/country/$id'));
    if (res.statusCode == 200) {
      return CountryData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<CountryData?> create(CountryData data) async {
    final res = await http.post(
      Uri.parse('$uri/country'),
      body: jsonEncode(data.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 201 || res.statusCode == 200) {
      return CountryData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<CountryData?> update(dynamic id, CountryData data) async {
    final res = await http.put(
      Uri.parse('$uri/country/$id'),
      body: jsonEncode(data.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) {
      return CountryData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<bool> delete(dynamic id) async {
    final res = await http.delete(Uri.parse('$uri/country/$id'));
    return res.statusCode == 200 || res.statusCode == 204;
  }
}
