import 'package:mongo_dart/mongo_dart.dart';

import '../dbHelper/mongodb.dart';
import '../model/product.dart';

class ProductController {
  // Thêm sản phẩm
  Future<void> addProduct(Product product) async {
    await MongoDB.addProduct(product);
  }

  // Cập nhật sản phẩm
  Future<void> updateProduct(Product product) async {
    await MongoDB.updateProduct(product);
  }

  // Lấy danh sách sản phẩm từ MongoDB
  Future<List<Product>> getProducts({String? type}) async {
    return await MongoDB.getProducts(type: type); // Truyền type nếu có
  }

  // Xóa sản phẩm
  Future<void> deleteProduct(String productId) async {
    await MongoDB.deleteProduct(productId);
  }

  // Lấy danh sách loại sản phẩm (được lấy từ CSDL)
  Future<List<String>> getCategories() async {
    return await MongoDB.getCategories();
  }

  // Tìm kiếm sản phẩm
  Future<List<Product>> searchProducts(String searchQuery) async {
    return await MongoDB.searchProducts(searchQuery); // Gọi hàm tìm kiếm từ MongoDB
  }

}
