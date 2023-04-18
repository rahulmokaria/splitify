import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../widgets/show_snackbar.dart';
import '../widgets/text_field_ui.dart';
import 'sign_up_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  bool isShopkeeper = false;
  bool _isLoading = false;
  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    // String res = await AuthMethods().loginUser(
    //   email: _emailTextController.text,
    //   password: _passwordTextController.text,
    // );

    // if (res == 'success' || res == 'Success') {
    //   gotoHome();
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
    //       "Oh Snap!", res, pink, CupertinoIcons.exclamationmark_circle));
    // }
    setState(() {
      _isLoading = false;
    });
  }

  void gotoHome() {
    // Navigator.of(context)
    // .pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width / 100;
    var _height = MediaQuery.of(context).size.height / 100;
    return SafeArea(
      child: Scaffold(
        backgroundColor: secondary,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/signupbg1.png',
              ),
              fit: BoxFit.cover,
            ),
            // color: secondary,
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
                  left: _width * 10,
                ),
                child: Text(
                  "Login",
                  textScaleFactor: 3,
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
              Container(
                padding: EdgeInsets.all(_width * 2),
                margin: EdgeInsets.only(left: _width * 4, right: _width * 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: _width * 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: !isShopkeeper
                              ? primary.withOpacity(0.8)
                              : secondary.withOpacity(0),
                        ),
                        height: _width * 9,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isShopkeeper = false;
                            });
                          },
                          child: Center(
                            child: Text(
                              'Customer',
                              textScaleFactor: !isShopkeeper ? 1.45 : 1.3,
                              style: TextStyle(
                                color: !isShopkeeper ? secondary : primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: _width * 1,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isShopkeeper
                              ? primary.withOpacity(0.8)
                              : secondary.withOpacity(0),
                        ),
                        height: _width * 9,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isShopkeeper = true;
                            });
                          },
                          child: Center(
                            child: Text(
                              'Shopkeeper',
                              textScaleFactor: isShopkeeper ? 1.45 : 1.3,
                              style: TextStyle(
                                color: isShopkeeper ? secondary : primary,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              //email
              Container(
                margin: EdgeInsets.only(left: _width * 4, right: _width * 4),
                child: textFieldUi('Email', Icons.person, false,
                    _emailTextController, TextInputType.emailAddress),
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),

              //password
              Container(
                margin: EdgeInsets.only(left: _width * 4, right: _width * 4),
                child: textFieldUi('Password', Icons.lock_outline, true,
                    _passwordTextController, TextInputType.visiblePassword),
              ),
              Container(
                margin: EdgeInsets.only(left: _width * 4, right: _width * 4),
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
                height: _width * 10,
                margin: EdgeInsets.only(left: _width * 4, right: _width * 4),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(90)),
                child: ElevatedButton(
                  onPressed: () => loginUser(),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return secondary;
                      }
                      return primary.withOpacity(0.8);
                    }),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(_width * 28))),
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
                  Text(
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
      ),
    );
  }
}
