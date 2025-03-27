import 'package:gk_dnt/model/user.dart';

import '../dbHelper/mongodb.dart';

class UserController {
  Future<void> signUp(String email, String password) async {
    await MongoDB.signUp(email, password);
  }

  Future<bool> login(String email, String password) async {
    return await MongoDB.login(email, password);
  }

  // // Xóa người dùng
  // Future<void> deleteUser(String id) async {
  //   await MongoDB.deleteProduct(productId);
  // }

  // Cập nhật sản phẩm
  // Future<void> updateUser(User user) async {
  //   await MongoDB.updateUser(user);
  // }

}
