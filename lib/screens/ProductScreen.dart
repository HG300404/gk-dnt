import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gk_dnt/screens/LoginPage.dart';
import 'package:gk_dnt/screens/Add_Product.dart'; // Để tạo mới sản phẩm
import 'package:gk_dnt/controllers/product_controller.dart'; // Để tương tác với controller
import 'package:gk_dnt/model/product.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductController productController = ProductController();
  String? selectedCategory;
  List<String> categories = [];
  TextEditingController searchController = TextEditingController();
  String searchQuery = ''; // Lưu từ khóa tìm kiếm

  List<Product> products = [];

  final ImagePicker _picker = ImagePicker();
  late File _imageFile;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadProducts();
  }

  // Hàm tải các loại sản phẩm
  Future<void> _loadCategories() async {
    categories = await productController.getCategories();
    setState(() {});
  }

  // Hàm xử lý tìm kiếm theo từ khóa
  void _searchProducts(String query) {
    setState(() {
      searchQuery = query.toLowerCase(); // Lưu từ khóa tìm kiếm
    });
  }

  // Hàm load dữ liệu sản phẩm
  Future<void> _loadProducts() async {
    // Giả sử bạn có hàm getProducts() để lấy tất cả sản phẩm
    products = await productController.getProducts();
    setState(() {});
  }

  // Hàm logout
  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Danh Sách Sản Phẩm',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 5,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              onChanged: _searchProducts,
              decoration: InputDecoration(
                labelText: 'Tìm kiếm sản phẩm...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          // Dropdown chọn loại sản phẩm
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Lọc:',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                DropdownButton<String>(
                  dropdownColor: Colors.white,
                  value: selectedCategory,
                  hint: Text('Tất cả',
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                  items: ['Tất cả', ...categories].map((category) {
                    return DropdownMenuItem<String>(
                      value: category == 'Tất cả' ? null : category,
                      child: Text(
                        category,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newCategory) {
                    setState(() {
                      selectedCategory = newCategory;
                    });
                  },
                ),
              ],
            ),
          ),
          // Danh sách sản phẩm
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: productController.getProducts(type: selectedCategory),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                      child: Text('Có lỗi xảy ra',
                          style: TextStyle(fontSize: 18, color: Colors.red)));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text('Không có sản phẩm',
                          style: TextStyle(
                              fontSize: 18, fontStyle: FontStyle.italic)));
                }

                final products = snapshot.data!
                    .where((product) =>
                        product.name
                            .toLowerCase()
                            .contains(searchQuery) || // Tìm kiếm theo tên
                        product.loaisp
                            .toLowerCase()
                            .contains(searchQuery)) // Tìm kiếm theo loại
                    .toList();

                return ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          radius: 25,
                          child: product.hinhanh.isEmpty
                              ? Icon(
                                  Icons
                                      .shopping_bag, // Hiển thị icon sản phẩm nếu không có ảnh
                                  color: Colors.white,
                                  size: 30,
                                )
                              : Image.file(
                                  File(product
                                      .hinhanh), // Hiển thị ảnh từ tệp cục bộ nếu là đường dẫn tệp
                                  fit: BoxFit.cover,
                                  width: 50,
                                  height: 50,
                                ),
                        ),
                        title: Text(
                          product.name,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Text('Loại: ${product.loaisp}',
                                style: TextStyle(
                                    fontSize: 16, fontStyle: FontStyle.italic)),
                            Text(
                              'Giá: ${NumberFormat('#,###', 'vi_VN').format(product.gia)}đ',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                bool? result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductForm(product: product),
                                  ),
                                );
                                if (result == true) _loadCategories();
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text(
                                      "Xác nhận",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: Text(
                                        "Bạn có chắc chắn muốn xóa sản phẩm này?",
                                        style: TextStyle(fontSize: 16)),
                                    actions: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey),
                                        onPressed: () => Navigator.pop(ctx),
                                        child: Text("Hủy",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        onPressed: () {
                                          productController
                                              .deleteProduct(product.idsanpham);
                                          Navigator.pop(ctx);
                                          _loadCategories();
                                        },
                                        child: Text("Xóa",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // Nút thêm sản phẩm
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductForm(),
            ),
          );

          if (result == true) {
            _loadCategories();
          }
        },
        child: Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }
}
