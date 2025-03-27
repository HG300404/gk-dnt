import 'dart:developer';

import 'package:gk_dnt/dbHelper/constant.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'dart:io';
import 'package:bcrypt/bcrypt.dart';
import '../model/product.dart';

class MongoDB {
  static late Db db;
  static late DbCollection productCollection, usersCollection;
  static late GridFS gridFS;


  static connect() async{
    db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    gridFS = GridFS(db);
    productCollection = db.collection("products");
    usersCollection = db.collection('users');
    print("MongoDB connected");
  }

  static Future<void> addProduct(Product product) async {
    await productCollection.insertOne(product.toMap());
    print("Product added");
  }


  static Future<List<Product>> getProducts({String? type}) async {
    var query = type != null
        ? productCollection.find({'loaisp': type})
        : productCollection.find();

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
    var result = await productCollection.distinct('loaisp');

    return List<String>.from(result['values'] as List);
  }


  static Future<void> signUp(String email, String password) async {
    String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

    await usersCollection.insertOne({
      'email': email,
      'password': hashedPassword,
    });
    print("User registered");
  }

  static Future<bool> login(String email, String password) async {
    var user = await usersCollection.findOne(where.eq('email', email));

    if (user != null) {
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


  static Future<List<Product>> searchProducts(String searchQuery) async {
    var query = productCollection.find({
      '\$or': [
        {'name': {'\$regex': searchQuery, '\$options': 'i'}},
        {'loaisp': {'\$regex': searchQuery, '\$options': 'i'}},
      ]
    });

    var result = await query.toList();
    return result.map((e) => Product.fromMap(e)).toList();
  }


  // static Future<GridFSFile?> getImageById(String imageId) async {
  //   final gridFS = GridFS(db);
  //   try {
  //     final file = await gridFS.findFile(where.eq('_id', ObjectId.fromHexString(imageId)));
  //     if (file != null) {
  //       return file;
  //     } else {
  //       print("File not found!");
  //       return null;
  //     }
  //   } catch (e) {
  //     print("Error retrieving file: $e");
  //     return null;
  //   }
  // }

}