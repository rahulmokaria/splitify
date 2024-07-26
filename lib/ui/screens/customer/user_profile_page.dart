// import 'package:dice_bear/dice_bear.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';

import '../../utils/colors.dart';
import '../../widgets/glassmorphic_container.dart';
import '../../widgets/show_snackbar.dart';

import '../../widgets/text_field_ui.dart';
import '../login_page.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({
    Key? key,
  }) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  // final bool _isLoading = false;
  // final int _selectedCategory = 1;
  // String svg = RandomAvatarString(
  //   DateTime.now().toIso8601String(),
  //   trBackground: false,
  // );

  // Avatar _avatar =
  // DiceBearBuilder(sprite: DiceBearSprite.identicon, seed: "user").build();
  getprofile() async {
    try {
      String endPoint = dotenv.env["URL"].toString();
      const storage = FlutterSecureStorage();
      String? value = await storage.read(key: "authtoken");
      var response = await http
          .post(Uri.parse("$endPoint/userApi/getUserCompleteDetails"), body: {
        "token": value,
      });
      var res = jsonDecode(response.body) as Map<String, dynamic>;
      if (res['flag']) {
        setState(() {
          username = res['message']['name'];
          useremail = res['message']['email'];
          // _avatar =
          // DiceBearBuilder(sprite: DiceBearSprite.identicon, seed: username)
          // .build();
        });
      } else {
        setState(() {
          username = "user";
          useremail = "user@gmail.com";
        });
        if (!mounted) return;
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          ctype: ContentType.failure,
          message: "${res['message']}. Please contact admin to resolve",
        ));
      }
    } catch (e) {
      // print("Get Profile error: $e");
      if (!mounted) return;
      return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
        ctype: ContentType.failure,
        message: "$e. Please contact admin to resolve",
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    getprofile();
  }

  logout() async {
    try {
      const storage = FlutterSecureStorage();
      // String? value = await storage.read(key: "authtoken");
      await storage.delete(key: "authtoken");
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false);
    } catch (e) {
      // print("Logout error: $e");
      return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
        ctype: ContentType.failure,
        message: "Smething went wrong. Please try after sometime",
      ));
    }
  }

  String username = "";
  String useremail = "";

  String urlimg = "";

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.01;
    // double _height = MediaQuery.of(context).size.height * 0.01;

    // print();
    // urlimg = _avatar.svgUri.toString();
    // print(svg);
    // model.User cUser = model.User.fromMap(userData);
    // return SafeArea(
    // child: Scaffold(
    return Scaffold(
      backgroundColor: secondary,
      appBar: AppBar(
        leading: InkWell(child: const Icon(FontAwesomeIcons.solidUser)),
        title: Text(
          'User Profile',
        ),
        backgroundColor: blue,
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(
            width * 2,
          ),
          decoration: const BoxDecoration(
            // borderRadius: BorderRadius.only(
            //   topLeft: Radius.circular(width * 10),
            //   topRight: Radius.circular(width * 10),
            // ),
            color: secondary,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      ClipRRect(
                        // borderRadius: BorderRadius.only(
                        //     // topLeft: Radius.circular(
                        //     // MediaQuery.of(context).size.width * 0.1),
                        //     // topRight: Radius.circular(
                        //     // MediaQuery.of(context).size.width * 0.1),
                        //     // bottomLeft: Radius.circular(
                        //     // MediaQuery.of(context).size.width * 0.1),
                        //     // bottomRight: Radius.circular(
                        //     // MediaQuery.of(context).size.width * 0.1),
                        //     ),
                        child: Image.asset(
                          // widget.cUser.backCoverImg
                          'assets/greenbg.png',
                          height: width * 50,
                          width: width * 100,
                          fit: BoxFit.cover,
                        ),
                        // Image.network(
                        // widget.cUser.backCoverImg
                        // 'https://www.google.com/url?sa=i&url=https%3A%2F%2Funsplash.com%2Fs%2Fphotos%2Fgreen-pattern&psig=AOvVaw3AJls4ZmJ5xErylYVzwYPx&ust=1682516876441000&source=images&cd=vfe&ved=0CBEQjRxqFwoTCPjhkfiVxf4CFQAAAAAdAAAAABAJ',
                        // height: width * 50,
                        // width: width * 100,
                        // fit: BoxFit.cover,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.width * 0.25,
                      ),
                    ],
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.3,
                    left: MediaQuery.of(context).size.width * 0.05,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.25),
                      child: Container(
                        color: secondary,
                        height: MediaQuery.of(context).size.width * 0.44,
                        width: MediaQuery.of(context).size.width * 0.44,
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.32,
                    left: MediaQuery.of(context).size.width * 0.07,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.2),
                      child: Container(
                        color: secondary,
                        height: MediaQuery.of(context).size.width * 0.4,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child:
                            // _avatar.toImage(
                            // height: width * 80,
                            // width: width * 80,
                            // fit: BoxFit.cover,
                            // ),
                            Image.network(
                          // svg.toString(),
                          // 'https://picsum.photos/200',
                          'https://source.boringavatars.com/bauhaus',
                          // widget.friend.photoUrl,
                          height: width * 80,
                          width: width * 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(width * 5),
              //   child: _avatar.toImage(
              //     height: width * 80,
              //     width: width * 80,
              //     fit: BoxFit.fitWidth,
              //   ),
              //   // Image.network(
              //   //   urlimg,
              //   //   height: MediaQuery.of(context).size.width,
              //   //   width: MediaQuery.of(context).size.width,
              //   //   fit: BoxFit.cover,
              //   // ),
              // ),
              SizedBox(
                height: width * 10,
              ),
              SizedBox(
                height: width * 15,
                width: width * 80,
                child: GlassMorphism(
                  end: 0,
                  accent: primary,
                  start: 0.25,
                  borderRadius: 20,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: width * 5,
                      ),
                      const Icon(
                        FontAwesomeIcons.solidUser,
                        color: white,
                      ),
                      SizedBox(
                        width: width * 10,
                      ),
                      Text(
                        username,
                        // textScaleFactor: 1.2,
                        textScaler: const TextScaler.linear(1.2),
                        style: const TextStyle(color: white),
                      ),
                      Flexible(flex: 1, child: Container()),
                      InkWell(
                          onTap: () {
                            // Navigator.of(context).push(
                            // MaterialPageRoute(
                            showDialog(
                              context: context,
                              builder: (_) => EditUsernameCard(
                                username: username,
                              ),
                              // ),
                            );
                          },
                          child: const Icon(FontAwesomeIcons.solidPenToSquare,
                              color: white)),
                      SizedBox(
                        width: width * 10,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: width * 10,
              ),
              SizedBox(
                height: width * 15,
                width: width * 80,
                child: GlassMorphism(
                  end: 0,
                  accent: primary,
                  start: 0.25,
                  borderRadius: 20,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: width * 5,
                      ),
                      const Icon(
                        FontAwesomeIcons.solidEnvelope,
                        color: white,
                      ),
                      SizedBox(
                        width: width * 10,
                      ),
                      Text(
                        useremail,
                        // textScaleFactor: 1.2,
                        textScaler: const TextScaler.linear(1.2),
                        style: const TextStyle(color: white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: width * 10,
              ),
              InkWell(
                onTap: () => showDialog(
                    context: context,
                    builder: (_) => const ChangePasswordCard()),
                // Navigator.of(context).push(
                // MaterialPageRoute(builder: (_) => ChangePasswordCard())),
                child: SizedBox(
                  height: width * 15,
                  width: width * 80,
                  child: GlassMorphism(
                    end: 0,
                    start: 0.25,
                    accent: primary,
                    borderRadius: 20,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: width * 5,
                        ),
                        const Icon(
                          FontAwesomeIcons.key,
                          color: white,
                        ),
                        SizedBox(
                          width: width * 10,
                        ),
                        const Text(
                          "Change password",
                          // textScaleFactor: 1.2,
                          textScaler: TextScaler.linear(1.2),
                          style: TextStyle(color: white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: width * 10,
              ),
              InkWell(
                onTap: () => logout(),
                child: SizedBox(
                  height: width * 15,
                  width: width * 80,
                  child: GlassMorphism(
                    end: 0,
                    start: 0.25,
                    accent: primary,
                    borderRadius: 20,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: width * 5,
                        ),
                        const Icon(
                          FontAwesomeIcons.rightFromBracket,
                          color: white,
                        ),
                        SizedBox(
                          width: width * 10,
                        ),
                        const Text(
                          "Logout",
                          // textScaleFactor: 1.2,
                          textScaler: TextScaler.linear(1.2),
                          style: TextStyle(color: white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}

class EditUsernameCard extends StatefulWidget {
  final String username;
  const EditUsernameCard({
    required this.username,
    Key? key,
  }) : super(key: key);

  @override
  EditUsernameCardState createState() => EditUsernameCardState();
}

class EditUsernameCardState extends State<EditUsernameCard> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.username;
  }

  editusername() async {
    try {
      String endPoint = dotenv.env["URL"].toString();
      const storage = FlutterSecureStorage();
      String? value = await storage.read(key: "authtoken");
      var response = await http.post(
          Uri.parse("$endPoint/userApi/changeUserName"),
          body: {"token": value, "newUserName": _usernameController.text});
      var res = jsonDecode(response.body) as Map<String, dynamic>;
      if (res['flag']) {
        setState(() {
          // username:
          // _usernameController.text;
        });
        if (!mounted) return;
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          ctype: ContentType.success,
          message: "Successfully changed",
        ));
      } else {
        if (!mounted) return;
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          ctype: ContentType.failure,
          message: res['message'] + "Please contact admin to resolve",
        ));
      }
    } catch (e) {
      // print("Edit username error: $e");
      return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
        ctype: ContentType.failure,
        message: "${e}Please contact admin to resolve",
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    double width = MediaQuery.of(context).size.width * 0.01;
    // double height = MediaQuery.of(context).size.height * 0.01;
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(width * 5),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: secondary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Edit username',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: blue,
                ),
              ),
              SizedBox(height: width * 5),
              Container(
                // padding: EdgeInsets.only(left: width * 4, right: width * 4),
                child: textFieldUi(
                    text: 'New Username',
                    icon: FontAwesomeIcons.solidUser,
                    textColor: blue,
                    isPasswordType: false,
                    controller: _usernameController,
                    inputType: TextInputType.name),
              ),
              SizedBox(height: width * 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      // white: white.withOpacity(0.2),
                      // onwhite: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: width * 2.5),
                  ElevatedButton(
                    onPressed: () {
                      // implement edit transaction functionality
                      // editdata();
                      // Navigator.of(context).popUntil(( context, MaterialPageRout));
                      // if(Navigator.canPop(context)) {
                      //   // Navigator.canPop return true if can pop
                      //   Navigator.pop(context);
                      // }
                      // Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=>TransactionPage()));
                      editusername();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      // white: white.withOpacity(0.2),
                      // onwhite: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ChangePasswordCard extends StatefulWidget {
  const ChangePasswordCard({
    Key? key,
  }) : super(key: key);

  @override
  ChangePasswordCardState createState() => ChangePasswordCardState();
}

class ChangePasswordCardState extends State<ChangePasswordCard> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _currPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  changepassword() async {
    try {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        // print(_confirmPasswordController.text);
        // print(_newPasswordController.text);
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          ctype: ContentType.failure,
          message: "new password does not match confirm password",
        ));
      }
      String endPoint = dotenv.env["URL"].toString();
      const storage = FlutterSecureStorage();
      String? value = await storage.read(key: "authtoken");
      var response =
          await http.post(Uri.parse("$endPoint/authApi/changePassword"), body: {
        "token": value,
        "currPassword": _currPasswordController.text,
        "newPassword": _newPasswordController.text
      });
      var res = jsonDecode(response.body) as Map<String, dynamic>;
      if (res['flag']) {
        if (!mounted) return;
        Navigator.of(context).pop();
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          ctype: ContentType.success,
          message: "Password changed Successfully",
        ));
      } else {
        if (!mounted) return;
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          ctype: ContentType.failure,
          message: res['message'] + "Please contact admin to resolve",
        ));
      }
    } catch (e) {
      // print("Change password error: $e");
      return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
        ctype: ContentType.failure,
        message: "${e}Please contact admin to resolve",
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    double width = MediaQuery.of(context).size.width * 0.01;
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(width * 5),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: secondary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Change Password',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: blue,
                ),
              ),
              SizedBox(height: width * 5),
              Container(
                // padding: EdgeInsets.only(left: width * 4, right: width * 4),
                child: textFieldUi(
                    text: 'Current Password',
                    icon: FontAwesomeIcons.lock,
                    textColor: blue,
                    isPasswordType: false,
                    controller: _currPasswordController,
                    inputType: TextInputType.name),
              ),
              SizedBox(height: width * 5),
              Container(
                // padding: EdgeInsets.only(left: width * 4, right: width * 4),
                child: textFieldUi(
                    text: 'New Password',
                    icon: FontAwesomeIcons.lock,
                    textColor: blue,
                    isPasswordType: false,
                    controller: _newPasswordController,
                    inputType: TextInputType.name),
              ),
              SizedBox(height: width * 5),
              Container(
                // padding: EdgeInsets.only(left: width * 4, right: width * 4),
                child: textFieldUi(
                    text: 'Confirm Password',
                    icon: FontAwesomeIcons.lock,
                    textColor: blue,
                    isPasswordType: false,
                    controller: _confirmPasswordController,
                    inputType: TextInputType.name),
              ),
              SizedBox(height: width * 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      // white: white.withOpacity(0.2),
                      // onwhite: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: width * 2.5),
                  ElevatedButton(
                    onPressed: () {
                      // implement edit transaction functionality
                      // editdata();
                      // Navigator.of(context).popUntil(( context, MaterialPageRout));
                      // if(Navigator.canPop(context)) {
                      //   // Navigator.canPop return true if can pop
                      //   Navigator.pop(context);
                      // }
                      // Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=>TransactionPage()));
                      changepassword();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      // white: white.withOpacity(0.2),
                      // onwhite: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
