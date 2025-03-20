import '../dbHelper/mongodb.dart';

class UserController {
  // Đăng ký người dùng
  Future<void> signUp(String email, String password) async {
    await MongoDB.signUp(email, password);
  }

  // Đăng nhập người dùng
  Future<bool> login(String email, String password) async {
    return await MongoDB.login(email, password);
  }
}
