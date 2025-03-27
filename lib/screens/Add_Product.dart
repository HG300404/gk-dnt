import 'package:flutter/material.dart';
import '../controllers/product_controller.dart';
import '../model/product.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProductForm extends StatefulWidget {
  final Product? product;

  ProductForm({this.product});

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _priceController = TextEditingController();

  final ProductController productController = ProductController();

  File? _image;
  String hinhanh = '';

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _typeController.text = widget.product!.loaisp;
      _priceController.text = widget.product!.gia.toString();
      hinhanh = widget.product!.hinhanh;
    }
  }

  void _submit() async {
    if (_nameController.text.isNotEmpty &&
        _typeController.text.isNotEmpty &&
        _priceController.text.isNotEmpty) {
      String name = _nameController.text;
      String type = _typeController.text;
      double price = double.parse(_priceController.text);

      if (widget.product == null) {
        Product newProduct = Product(
          idsanpham: Product.generateRandomId(),
          name: name,
          loaisp: type,
          gia: price,
          hinhanh: hinhanh,
        );
        print("add");
        productController.addProduct(newProduct);
      } else {
        Product updatedProduct = widget.product!.copyWith(
          name: name,
          loaisp: type,
          gia: price,
          hinhanh: hinhanh,
        );
        productController.updateProduct(updatedProduct);
      }

      Navigator.pop(context, true);
    }
  }

  // Hàm chọn hình ảnh từ thiết bị
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // Chọn hình ảnh từ thư viện

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Lưu đường dẫn hình ảnh
        hinhanh = _image!.path; // Lưu đường dẫn vào biến hinhanh
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          widget.product == null ? 'Tạo Sản Phẩm' : 'Sửa Sản Phẩm',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Tên sản phẩm',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _typeController,
                  decoration: InputDecoration(
                    labelText: 'Loại sản phẩm',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Giá sản phẩm',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                // Chọn hình ảnh sản phẩm
                ElevatedButton(
                  onPressed: _pickImage,  // Gọi hàm chọn hình ảnh từ thiết bị
                  child: Text('Chọn Hình Ảnh'),
                ),
                hinhanh.isNotEmpty
                    ? Image.file(File(hinhanh))  // Hiển thị hình ảnh đã chọn hoặc hình ảnh đã có trong product
                    : Text('Chưa chọn hình ảnh'),  // Nếu không có hình ảnh, hiển thị thông báo


                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _submit,
                    child: Text(
                      'Lưu sản phẩm',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
