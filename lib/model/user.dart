class User {
  String email;
  String password;

  User({required this.email, required this.password});

  // Hàm tạo User từ Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'],
      password: map['password'],
    );
  }

  // Hàm chuyển User thành Map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }
}
