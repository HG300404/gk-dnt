import 'package:flutter/material.dart';
import 'package:gk_dnt/dbHelper/mongodb.dart';
import 'package:gk_dnt/screens/Add_Product.dart';
import 'package:gk_dnt/screens/LoginPage.dart';
import 'package:gk_dnt/screens/ProductScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDB.connect();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý sản phẩm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

