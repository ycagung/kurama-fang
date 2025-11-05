import 'dart:convert';

import 'package:fang/classes.dart';
import 'package:fang/services/api_service.dart';

class ProfileService extends ApiService {
  ProfileService();

  Future<List<ProfileData>> getAll() async {
    final res = await getRequest('/profile');
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
      return data
          .map((e) => ProfileData.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<ProfileData?> getById(String id) async {
    final res = await getRequest('/profile/$id');
    if (res.statusCode == 200) {
      return ProfileData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<ProfileData?> create(ProfileData data) async {
    final res = await postRequest('/profile', body: data.toJson());
    if (res.statusCode == 201 || res.statusCode == 200) {
      return ProfileData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<ProfileData?> update(String id, ProfileData data) async {
    final res = await putRequest('/profile/$id', body: data.toJson());
    if (res.statusCode == 200) {
      return ProfileData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<bool> delete(String id) async {
    final res = await deleteRequest('/profile/$id');
    return res.statusCode == 200 || res.statusCode == 204;
  }
}
