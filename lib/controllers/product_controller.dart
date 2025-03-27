import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';

import '../dbHelper/mongodb.dart';
import '../model/product.dart';

class ProductController {
  Future<void> addProduct(Product product) async {
    await MongoDB.addProduct(product);
  }

  Future<void> updateProduct(Product product) async {
    await MongoDB.updateProduct(product);
  }

  Future<List<Product>> getProducts({String? type}) async {
    return await MongoDB.getProducts(type: type);
  }

  Future<void> deleteProduct(String productId) async {
    await MongoDB.deleteProduct(productId);
  }

  Future<List<String>> getCategories() async {
    return await MongoDB.getCategories();
  }

  Future<List<Product>> searchProducts(String searchQuery) async {
    return await MongoDB.searchProducts(searchQuery);
  }

  // Future<File> getProductImage(String imageId) async {
  //   final file = await MongoDB.getImageById(imageId);
  //   return File.fromRawPath(await file.read());
  // }


}
