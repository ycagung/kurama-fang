import 'dart:convert';

import 'package:fang/classes.dart';
import 'package:fang/services/api_service.dart';

class AccountService extends ApiService {
  AccountService();

  /// Get current authenticated account
  Future<AccountData?> getCurrent(String accountId) async {
    final res = await getRequest('/account/$accountId');
    if (res.statusCode == 200) {
      // Response might be a list with one item or a single object
      final data = jsonDecode(res.body);
      if (data is List && data.isNotEmpty) {
        return AccountData.fromJson(data[0] as Map<String, dynamic>);
      } else if (data is Map) {
        return AccountData.fromJson(data as Map<String, dynamic>);
      }
    }
    return null;
  }

  Future<List<AccountData>> getAll() async {
    final res = await getRequest('/account');
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
      return data
          .map((e) => AccountData.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<AccountData?> getById(String id) async {
    final res = await getRequest('/account/$id');
    if (res.statusCode == 200) {
      return AccountData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<AccountData?> create(AccountData data) async {
    final res = await postRequest('/account', body: data.toJson());
    if (res.statusCode == 201 || res.statusCode == 200) {
      return AccountData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<AccountData?> update(String id, AccountData data) async {
    final res = await putRequest('/account/$id', body: data.toJson());
    if (res.statusCode == 200) {
      return AccountData.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  Future<bool> delete(String id) async {
    final res = await deleteRequest('/account/$id');
    return res.statusCode == 200 || res.statusCode == 204;
  }
}
