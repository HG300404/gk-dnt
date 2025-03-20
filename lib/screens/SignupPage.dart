import 'package:flutter/material.dart';
import 'package:gk_dnt/controllers/user_controller.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final UserController userController = UserController();

  String? emailError;
  String? passwordError;

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _signUp() async {
    setState(() {
      emailError = _isValidEmail(_emailController.text) ? null : "Email không hợp lệ!";
      passwordError = _passwordController.text.length < 4 ? "Mật khẩu phải có ít nhất 4 ký tự" : null;

      if (_passwordController.text != _confirmPasswordController.text) {
        passwordError = "Mật khẩu không khớp";
      }
    });

    if (emailError == null && passwordError == null) {
      await userController.signUp(_emailController.text, _passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đăng ký thành công')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purpleAccent.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Đăng ký", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    errorText: emailError,
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    errorText: passwordError,
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Xác nhận mật khẩu',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade800),
                  child: Text('Đăng ký', style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Quay lại đăng nhập", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
