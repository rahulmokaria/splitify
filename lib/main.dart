import 'package:flutter/material.dart';

import 'package:splitify/ui/screens/customer/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'ui/screens/login_page.dart';

void main() async {
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
        primarySwatch: Colors.purple,
      ),
      home: const CusHomePage(),
      // home: const LoginPage(),
    );
  }
}
