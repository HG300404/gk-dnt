import 'dart:developer';

import 'package:gk_dnt/dbHelper/constant.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'dart:io';
import 'package:bcrypt/bcrypt.dart';

import '../model/product.dart';  // Import mongo_dart

class MongoDB {
  static late Db db;
  static late DbCollection productCollection, usersCollection;

  static connect() async{
    db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    productCollection = db.collection("products");
    usersCollection = db.collection('users');
    print("MongoDB connected");
  }

  static Future<void> addProduct(Product product) async {
    await productCollection.insertOne(product.toMap());
    print("Product added");
  }


  // Hàm lấy tất cả sản phẩm hoặc sản phẩm theo loại
  static Future<List<Product>> getProducts({String? type}) async {
    var query = type != null
        ? productCollection.find({'loaisp': type}) // Lọc theo loại sản phẩm
        : productCollection.find(); // Lấy tất cả sản phẩm nếu không có loại

    var result = await query.toList();
    return result.map((e) => Product.fromMap(e)).toList(); // Chuyển đổi dữ liệu sang Product
  }

  static Future<void> updateProduct(Product product) async {
    await productCollection.updateOne(
      where.eq('_id', product.idsanpham),
      modify.set('name', product.name)
          .set('loaisp', product.loaisp)
          .set('gia', product.gia)
          .set('hinhanh', product.hinhanh),
    );
    print("Product updated");
  }

  static Future<void> deleteProduct(String productId) async {
    await productCollection.deleteOne(where.eq('_id', productId));
    print("Product deleted");
  }

  static Future<List<String>> getCategories() async {
    // Truy vấn các loại sản phẩm khác nhau từ MongoDB
    var result = await productCollection.distinct('loaisp');

    // Lấy danh sách giá trị từ result['values']
    return List<String>.from(result['values'] as List);
  }


  // Đăng ký người dùng (lưu email và mật khẩu đã mã hóa)
  static Future<void> signUp(String email, String password) async {
    // Mã hóa mật khẩu
    String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

    // Lưu vào MongoDB
    await usersCollection.insertOne({
      'email': email,
      'password': hashedPassword,
    });
    print("User registered");
  }

  // Đăng nhập người dùng
  static Future<bool> login(String email, String password) async {
    // Lấy người dùng từ MongoDB
    var user = await usersCollection.findOne(where.eq('email', email));

    if (user != null) {
      // So sánh mật khẩu đã mã hóa
      if (BCrypt.checkpw(password, user['password'])) {
        print("Login successful");
        return true;
      } else {
        print("Incorrect password");
        return false;
      }
    } else {
      print("User not found");
      return false;
    }
  }


  // Hàm tìm kiếm sản phẩm theo tên hoặc loại
  static Future<List<Product>> searchProducts(String searchQuery) async {
    var query = productCollection.find({
      '\$or': [
        {'name': {'\$regex': searchQuery, '\$options': 'i'}},  // Tìm kiếm theo tên
        {'loaisp': {'\$regex': searchQuery, '\$options': 'i'}}, // Tìm kiếm theo loại sản phẩm
      ]
    });

    var result = await query.toList();
    return result.map((e) => Product.fromMap(e)).toList();
  }


}