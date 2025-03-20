import 'package:flutter/material.dart';
import 'package:gk_dnt/controllers/user_controller.dart';
import 'package:gk_dnt/screens/ProductScreen.dart';
import 'package:gk_dnt/screens/SignUpPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final UserController userController = UserController();
  String? emailError;

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _login() async {
    setState(() {
      emailError = _isValidEmail(_emailController.text) ? null : "Email không hợp lệ!";
    });

    if (emailError == null) {
      bool result = await userController.login(
        _emailController.text,
        _passwordController.text,
      );

      if (result) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProductScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đăng nhập thất bại')));
      }
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
                Text("Đăng nhập", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
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
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade800),
                  child: Text('Đăng nhập', style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                  child: Text("Chưa có tài khoản? Đăng ký ngay", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
