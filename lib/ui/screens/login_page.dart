import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../utils/colors.dart';
import '../widgets/show_snackbar.dart';
import '../widgets/text_field_ui.dart';
import 'customer/home_page.dart';
import 'sign_up_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  bool _isLoading = false;

  loginUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      const storage = FlutterSecureStorage();
      var email = _emailTextController.text;
      var password = _passwordTextController.text;
      String endPoint = dotenv.env["URL"].toString();
      // print(endPoint);

      // var response = await http.post(Uri.parse(endPoint + '/'));

      var response = await http.post(Uri.parse("$endPoint/authApi/login"),
          body: {"email": email.toString(), "password": password.toString()});
      // print(response.body);
      var res = jsonDecode(response.body) as Map<String, dynamic>;
      // print(response);
      if (!res['flag']) {
        if (!mounted) return;
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          ctype: ContentType.failure,
          message: res['message'],
        ));
      } else {
        // print(res['message']);
        await storage.write(key: "authtoken", value: res['message']);
        // String? value = await storage.read(key: "authtoken");
        return gotoHome();
      }
    } catch (e) {
      // print("Login error: $e");
      setState(() {
        _isLoading = false;
      });
      return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
        ctype: ContentType.failure,
        message: "Error at registersation. Please contact admin to resolve",
      ));
    }
  }

  void gotoHome() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => HomePage(
              currentIndex: 0,
            )));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 100;
    // var _height = MediaQuery.of(context).size.height / 100;
    // return SafeArea(
    // child: Scaffold(
    return Scaffold(
      backgroundColor: secondary,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/signupbg1.png',
            ),
            fit: BoxFit.cover,
          ),
          color: secondary,
        ),
        child: Column(
          children: [
            Flexible(
              flex: 7,
              child: Container(),
            ),
            //login
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                left: width * 10,
              ),
              child: Text(
                "Login",
                // textScaleFactor: 3,
                textScaler: const TextScaler.linear(3),
                style: TextStyle(
                  color: primary,
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(),
            ),
            //customer/shopkeeper
            // Container(
            //   height: width * 15,
            //   padding: EdgeInsets.all(width * 2),
            //   margin: EdgeInsets.only(left: width * 4, right: width * 4),
            //   decoration: BoxDecoration(
            //     color: Colors.white.withOpacity(0.2),
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   child: Container(
            //     decoration:
            //         BoxDecoration(borderRadius: BorderRadius.circular(20)),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         Container(
            //           width: width * 40,
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(10),
            //             color: !isShopkeeper
            //                 ? primary.withOpacity(0.8)
            //                 : secondary.withOpacity(0),
            //           ),
            //           height: width * 9,
            //           child: InkWell(
            //             onTap: () {
            //               setState(() {
            //                 isShopkeeper = false;
            //               });
            //             },
            //             child: Center(
            //               child: Text(
            //                 'Customer',
            //                 textScaleFactor: !isShopkeeper ? 1.45 : 1.3,
            //                 style: TextStyle(
            //                   color: !isShopkeeper ? secondary : primary,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //         SizedBox(
            //           width: width * 1,
            //         ),
            //         Container(
            //           width: MediaQuery.of(context).size.width * 0.42,
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(10),
            //             color: isShopkeeper
            //                 ? primary.withOpacity(0.8)
            //                 : secondary.withOpacity(0),
            //           ),
            //           height: width * 9,
            //           child: InkWell(
            //             onTap: () {
            //               setState(() {
            //                 isShopkeeper = true;
            //               });
            //             },
            //             child: Center(
            //               child: Text(
            //                 'Shopkeeper',
            //                 textScaleFactor: isShopkeeper ? 1.45 : 1.3,
            //                 style: TextStyle(
            //                   color: isShopkeeper ? secondary : primary,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            // Flexible(
            //   flex: 1,
            //   child: Container(),
            // ),
            //email
            Container(
              margin: EdgeInsets.only(left: width * 4, right: width * 4),
              child: textFieldUi(
                  text: 'Email',
                  icon: FontAwesomeIcons.solidUser,
                  textColor: primary,
                  isPasswordType: false,
                  controller: _emailTextController,
                  inputType: TextInputType.emailAddress),
            ),
            Flexible(
              flex: 1,
              child: Container(),
            ),

            //password
            Container(
              margin: EdgeInsets.only(left: width * 4, right: width * 4),
              child: textFieldUi(
                  text: 'Password',
                  icon: FontAwesomeIcons.lock,
                  textColor: primary,
                  isPasswordType: true,
                  controller: _passwordTextController,
                  inputType: TextInputType.visiblePassword),
            ),
            Container(
              margin: EdgeInsets.only(left: width * 4, right: width * 4),
              child: TextButton(
                onPressed: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (_) => const ForgotPasswordPage(),
                  //   ),
                  // );
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(
                      color: primary,
                    ),
                  ),
                ),
              ),
            ),
            //forgotpassword
            Flexible(
              flex: 1,
              child: Container(),
            ),
            //login button
            Container(
              width: MediaQuery.of(context).size.width,
              height: width * 15,
              margin: EdgeInsets.only(left: width * 4, right: width * 4),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(90)),
              child: ElevatedButton(
                onPressed: () => loginUser(),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.pressed)) {
                      return secondary;
                    }
                    return primary.withOpacity(0.8);
                  }),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width * 28))),
                ),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: white,
                        ),
                      )
                    : const Text(
                        "Login",
                        style: TextStyle(
                          color: secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(),
            ),
            //signup
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(
                    fontSize: 18,
                    color: white,
                  ),
                ),
                TextButton(
                  // onPressed: openSignUp,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SignUpPage(),
                      ),
                    );
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 18,
                      color: primary,
                    ),
                  ),
                ),
              ],
            ),
            Flexible(
              flex: 1,
              child: Container(),
            ),
          ],
        ),
      ),
      // ),
    );
  }
}
