import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../utils/colors.dart';
import '../widgets/text_field_ui.dart';
import 'login_page.dart';

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

  bool isShopkeeper = false;
  bool _isLoading = false;
  @override
  dispose() {
    super.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _confirmPasswordTextController.dispose();
    _nameTextController.dispose();
  }

  signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    // String res = await AuthMethods().signUpUser(
    //     email: _emailTextController.text,
    //     password: _passwordTextController.text,
    //     );
    setState(() {
      _isLoading = false;
    });

    // if (res == 'success') {
    //   // gotoHome();
    // } else {
    //   // showSnackBar(res, context);
    // }
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
                  left: _width * 10,
                ),
                child: Text(
                  "Sign Up",
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
              Container(
                margin: EdgeInsets.only(left: _width * 4, right: _width * 4),
                child: textFieldUi('Name', Icons.person, false,
                    _nameTextController, TextInputType.name),
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              //password
              Container(
                margin: EdgeInsets.only(left: _width * 4, right: _width * 4),
                child: textFieldUi('New Password', Icons.lock_outline, true,
                    _passwordTextController, TextInputType.visiblePassword),
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Container(
                margin: EdgeInsets.only(left: _width * 4, right: _width * 4),
                child: textFieldUi(
                    'Confirm Password',
                    Icons.lock_outline,
                    true,
                    _confirmPasswordTextController,
                    TextInputType.visiblePassword),
              ),
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
                  // onPressed: () => loginUser(),
                  onPressed: () {},

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
      ),
    );
  }
}
