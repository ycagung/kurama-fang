import 'package:fang/classes.dart';

abstract class AuthRepo {
  Future<UserData?> login(String email, String password);
  Future<void> logout();
  Future<UserData?> getCurrentUser();
}
