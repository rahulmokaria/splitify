import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../utils/colors.dart';
import '../widgets/show_snackbar.dart';
import '../widgets/text_field_ui.dart';
import 'login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Color primary = const Color(0xfffe2479);
// const Color secondary = Color(0xff0e0b16);
// const Color secondaryLight = Color(0xff231539);

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController =
      TextEditingController();
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _contactNumberTextController =
      TextEditingController();

  bool _isLoading = false;
  @override
  dispose() {
    super.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _confirmPasswordTextController.dispose();
    _nameTextController.dispose();
    _confirmPasswordTextController.dispose();
  }

  signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    void gotoLogin() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginPage()));
    }

    try {
      var email = _emailTextController.text;
      var name = _nameTextController.text;
      var password = _passwordTextController.text;
      var confirmpassword = _confirmPasswordTextController.text;
      var contactNumber = _contactNumberTextController.text;

      if (password != confirmpassword) {
        setState(() {
          _isLoading = false;
        });
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
            ctype: ContentType.failure,
            message: "Password and confirm password is not matching"));
      }
      String endPoint = dotenv.env["URL"].toString();
      // print('tryint to register a new user');
      var response =
          await http.post(Uri.parse("$endPoint/authApi/register"), body: {
        "email": email.toString(),
        "name": name.toString(),
        "password": password.toString(),
        "contactNo": contactNumber.toString()
      });
      // print(response.body);
      var res = jsonDecode(response.body) as Map<String, dynamic>;
      if (!res['flag']) {
        if (!mounted) return;
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
            ctype: ContentType.failure, message: res['message']));
      } else {
        setState(() {
          _isLoading = false;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          ctype: ContentType.success,
          message: "Successfully registered. You can login now",
        ));
        return gotoLogin();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // print("Sign up error: " + e.toString());
      return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
        ctype: ContentType.failure,
        message: "Error at registersation. Please contact admin to resolve",
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 100;
    // return SafeArea(
      // child: Scaffold(
      return Scaffold(
        backgroundColor: secondary,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/signupbg1.png'),
              fit: BoxFit.cover,
            ),
            color: secondary,
          ),
          child: Column(
            children: [
              Flexible(
                flex: 5,
                child: Container(),
              ),
              //login
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                  left: width * 10,
                ),
                child: Text(
                  "Sign Up",
                  // textScaleFactor: 3,
                  textScaler: const TextScaler.linear(3),
                  style: TextStyle(
                    color: primary,
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Container(),
              ),
              //customer/shopkeeper

              //email
              Container(
                margin: EdgeInsets.only(left: width * 4, right: width * 4),
                child: textFieldUi(
                    text: 'Email',
                    icon: FontAwesomeIcons.solidEnvelope,
                    textColor: primary,
                    isPasswordType: false,
                    controller: _emailTextController,
                    inputType: TextInputType.emailAddress),
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Container(
                margin: EdgeInsets.only(left: width * 4, right: width * 4),
                child: textFieldUi(
                    text: 'Name',
                    icon: FontAwesomeIcons.solidUser,
                    textColor: primary,
                    isPasswordType: false,
                    controller: _nameTextController,
                    inputType: TextInputType.name),
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Container(
                margin: EdgeInsets.only(left: width * 4, right: width * 4),
                child: textFieldUi(
                    text: 'Contact No.',
                    icon: FontAwesomeIcons.phone,
                    textColor: primary,
                    isPasswordType: false,
                    controller: _contactNumberTextController,
                    inputType: TextInputType.number),
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              //password
              Container(
                margin: EdgeInsets.only(left: width * 4, right: width * 4),
                child: textFieldUi(
                    text: 'New Password',
                    icon: FontAwesomeIcons.lock,
                    textColor: primary,
                    isPasswordType: true,
                    controller: _passwordTextController,
                    inputType: TextInputType.visiblePassword),
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Container(
                margin: EdgeInsets.only(left: width * 4, right: width * 4),
                child: textFieldUi(
                    text: 'Confirm Password',
                    icon: FontAwesomeIcons.lock,
                    textColor: primary,
                    isPasswordType: true,
                    controller: _confirmPasswordTextController,
                    inputType: TextInputType.visiblePassword),
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              //login button
              Container(
                width: MediaQuery.of(context).size.width,
                height: width * 10,
                margin: EdgeInsets.only(left: width * 4, right: width * 4),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(90)),
                child: ElevatedButton(
                  onPressed: () => signUpUser(),
                  // onPressed: () {},

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
                          "Sign Up",
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
                    "Already have an account?",
                    style: TextStyle(
                      fontSize: 18,
                      color: white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const LoginPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Login",
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
