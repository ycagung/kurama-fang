import 'dart:convert';

import 'package:fang/classes.dart';
import 'package:fang/services/api_service.dart';

class GroupMemberRoleService extends ApiService {
  GroupMemberRoleService();

  Future<List<GroupMemberRoleData>> getAll() async {
    final res = await getRequest('/groupMemberRole');
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
      return data
          .map((e) => GroupMemberRoleData.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<GroupMemberRoleData?> getById(String id) async {
    final res = await getRequest('/groupMemberRole/$id');
    if (res.statusCode == 200) {
      return GroupMemberRoleData.fromJson(
        jsonDecode(res.body) as Map<String, dynamic>,
      );
    }
    return null;
  }

  Future<GroupMemberRoleData?> create(GroupMemberRoleData data) async {
    final res = await postRequest('/groupMemberRole', body: data.toJson());
    if (res.statusCode == 201 || res.statusCode == 200) {
      return GroupMemberRoleData.fromJson(
        jsonDecode(res.body) as Map<String, dynamic>,
      );
    }
    return null;
  }

  Future<GroupMemberRoleData?> update(
    String id,
    GroupMemberRoleData data,
  ) async {
    final res = await putRequest('/groupMemberRole/$id', body: data.toJson());
    if (res.statusCode == 200) {
      return GroupMemberRoleData.fromJson(
        jsonDecode(res.body) as Map<String, dynamic>,
      );
    }
    return null;
  }

  Future<bool> delete(String id) async {
    final res = await deleteRequest('/groupMemberRole/$id');
    return res.statusCode == 200 || res.statusCode == 204;
  }
}
