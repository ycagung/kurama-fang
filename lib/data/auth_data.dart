import 'package:fang/classes.dart';
import 'package:fang/repos/auth_repo.dart';

class Auth implements AuthRepo {
  final String uri = String.fromEnvironment('PUBLIC_API_URL');

  Future<UserData?> login(String email, String password) async {}

  Future<void> logout() async {}

  Future<UserData?> getCurrentUser() async {}
}
