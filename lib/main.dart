import 'dart:io';

import 'package:flutter/material.dart';

import 'package:splitify/ui/screens/customer/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'ui/screens/login_page.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  HttpOverrides.global =
      MyHttpOverrides(); //remove when releasing the app https://stackoverflow.com/questions/54285172/how-to-solve-flutter-certificate-verify-failed-error-while-performing-a-post-req/61312927#61312927
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
      home: const CusHomePage(),
      // home: const LoginPage(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
