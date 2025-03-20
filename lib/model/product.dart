import 'dart:math';
class Product {
  String idsanpham;
  String loaisp;
  String name;
  double gia;
  String hinhanh;

  Product({
    required this.idsanpham,
    required this.loaisp,
    required this.name,
    required this.gia,
    required this.hinhanh,
  });

  // Phương thức copyWith giúp sao chép đối tượng và thay đổi các thuộc tính nếu cần
  Product copyWith({
    String? idsanpham,
    String? loaisp,
    String? name,
    double? gia,
    String? hinhanh,
  }) {
    return Product(
      idsanpham: idsanpham ?? this.idsanpham,
      loaisp: loaisp ?? this.loaisp,
      name: name ?? this.name,
      gia: gia ?? this.gia,
      hinhanh: hinhanh ?? this.hinhanh,
    );
  }

  // Tạo từ Map (chuyển dữ liệu từ MongoDB)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      idsanpham: map['_id'],
      loaisp: map['loaisp'],
      name: map['name'],
      gia: map['gia'],
      hinhanh: map['hinhanh'],
    );
  }

  // Chuyển thành Map để lưu vào MongoDB
  Map<String, dynamic> toMap() {
    return {
      '_id': idsanpham,
      'loaisp': loaisp,
      'name': name,
      'gia': gia,
      'hinhanh': hinhanh,
    };
  }

  // Hàm tạo ID ngẫu nhiên dài 10 ký tự
  static String generateRandomId() {
    const _chars = '0123456789';
    Random _rnd = Random();
    return List.generate(10, (index) => _chars[_rnd.nextInt(_chars.length)]).join();
  }
}
