import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:skeletons/skeletons.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'ui/screens/customer/home_page.dart';
import 'ui/screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  // print("loaded");

  HttpOverrides.global =
      MyHttpOverrides(); //remove when releasing the app https://stackoverflow.com/questions/54285172/how-to-solve-flutter-certificate-verify-failed-error-while-performing-a-post-req/61312927#61312927
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Future<Widget> checkIfLoggedIn() async {
      const storage = FlutterSecureStorage();
      String? value = await storage.read(key: "authtoken");
      if (value == null) {
        return const LoginPage();
      }
      return HomePage(
     
          );
    }

    return MaterialApp(
      title: 'Splitify',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<Widget>(
        future: checkIfLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text('Error loading app')),
            );
          } else {
            return snapshot.data!;
          }
        },
      ),
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
