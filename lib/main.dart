import 'package:flutter/material.dart';

import 'package:splitify/screens/customer/expense_tracker.dart';
import 'package:splitify/screens/customer/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:splitify/screens/login_page.dart';
import 'package:splitify/screens/sign_up_page.dart';

void main() async{
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const CusHomePage(),
      home: const LoginPage(),
    );
  }
}
