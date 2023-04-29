import 'package:dice_bear/dice_bear.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/colors.dart';
import '../../widgets/glassmorphic_container.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../widgets/show_snackbar.dart';
import 'package:intl/intl.dart';

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
  bool _isLoading = false;
  int _selectedCategory = 1;

  Avatar _avatar =
      DiceBearBuilder(sprite: DiceBearSprite.identicon, seed: "user").build();
  getprofile() async {
    try {
      String endPoint = dotenv.env["URL"].toString();
      final storage = new FlutterSecureStorage();
      String? value = await storage.read(key: "authtoken");
      var response =
          await http.post(Uri.parse(endPoint + "/api/user/getdetails"), body: {
        "token": value,
      });
      var res = jsonDecode(response.body) as Map<String, dynamic>;
      if (res['flag']) {
        setState(() {
          username = res['message']['name'];
          useremail = res['message']['email'];
          _avatar =
              DiceBearBuilder(sprite: DiceBearSprite.identicon, seed: username)
                  .build();
        });
      } else {
        setState(() {
          username = "user";
          useremail = "user@gmail.com";
        });
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
            "Please contact admin to resolve",
            res['message'],
            pink,
            Icons.close));
      }
    } catch (e) {
      return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          "Please contact admin to resolve", e.toString(), pink, Icons.close));
    }
  }

  @override
  void initState() {
    super.initState();
    getprofile();
  }
  logout()async{
    try {
      final storage = new FlutterSecureStorage();
      String? value = await storage.read(key: "authtoken");
      await storage.delete(key: "authtoken");
       Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    LoginPage()), (Route<dynamic> route) => false);
    } catch (e) {
      return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          "Smething went wrong", "Please try after sometime", pink, Icons.close)); 
    }
  }
  String username = "";
  String useremail = "";

  String urlimg = "";

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;
    print(_width);
    urlimg = _avatar.svgUri.toString();
    print(urlimg);
    // model.User cUser = model.User.fromMap(userData);
    return SafeArea(
      child: Scaffold(
        backgroundColor: secondary,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(
              _width * 2,
            ),
            decoration: const BoxDecoration(
              // borderRadius: BorderRadius.only(
              //   topLeft: Radius.circular(_width * 10),
              //   topRight: Radius.circular(_width * 10),
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
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                MediaQuery.of(context).size.width * 0.1),
                            topRight: Radius.circular(
                                MediaQuery.of(context).size.width * 0.1),
                            // bottomLeft: Radius.circular(
                            // MediaQuery.of(context).size.width * 0.1),
                            // bottomRight: Radius.circular(
                            // MediaQuery.of(context).size.width * 0.1),
                          ),
                          child: Image.asset(
                            // widget.cUser.backCoverImg
                            'assets/greenbg.jpg',
                            height: _width * 50,
                            width: _width * 100,
                            fit: BoxFit.cover,
                          ),
                          // Image.network(
                          // widget.cUser.backCoverImg
                          // 'https://www.google.com/url?sa=i&url=https%3A%2F%2Funsplash.com%2Fs%2Fphotos%2Fgreen-pattern&psig=AOvVaw3AJls4ZmJ5xErylYVzwYPx&ust=1682516876441000&source=images&cd=vfe&ved=0CBEQjRxqFwoTCPjhkfiVxf4CFQAAAAAdAAAAABAJ',
                          // height: _width * 50,
                          // width: _width * 100,
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
                          child: _avatar.toImage(
                            // height: _width * 80,
                            // width: _width * 80,
                            fit: BoxFit.cover,
                          ),
                          //  Image.network(
                          //   widget.friend.photoUrl,
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                      ),
                    ),
                  ],
                ),
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(_width * 5),
                //   child: _avatar.toImage(
                //     height: _width * 80,
                //     width: _width * 80,
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
                  height: _width * 10,
                ),
                Container(
                  height: _width * 15,
                  width: _width * 80,
                  child: GlassMorphism(
                    end: 0,
                    start: 0.25,
                    borderRadius: 20,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: _width * 5,
                        ),
                        Icon(
                          FontAwesomeIcons.solidUser,
                          color: primary,
                        ),
                        SizedBox(
                          width: _width * 10,
                        ),
                        Text(
                          username,
                          textScaleFactor: 1.2,
                          style: TextStyle(color: primary),
                        ),
                        Flexible(flex: 1, child: Container()),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => EditUsernameCard(
                                    username: username,
                                  ),
                                ),
                              );
                            },
                            child: Icon(FontAwesomeIcons.solidPenToSquare,
                                color: primary)),
                        SizedBox(
                          width: _width * 10,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: _width * 10,
                ),
                Container(
                  height: _width * 15,
                  width: _width * 80,
                  child: GlassMorphism(
                    end: 0,
                    start: 0.25,
                    borderRadius: 20,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: _width * 5,
                        ),
                        Icon(
                          FontAwesomeIcons.solidEnvelope,
                          color: primary,
                        ),
                        SizedBox(
                          width: _width * 10,
                        ),
                        Text(
                          useremail,
                          textScaleFactor: 1.2,
                          style: TextStyle(color: primary),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: _width * 10,
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ChangePasswordCard())),
                  child: Container(
                    height: _width * 15,
                    width: _width * 80,
                    child: GlassMorphism(
                      end: 0,
                      start: 0.25,
                      borderRadius: 20,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: _width * 5,
                          ),
                          Icon(
                            FontAwesomeIcons.key,
                            color: primary,
                          ),
                          SizedBox(
                            width: _width * 10,
                          ),
                          Text(
                            "Change password",
                            textScaleFactor: 1.2,
                            style: TextStyle(color: primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: _width * 10,
                ),
                InkWell(
                  onTap: ()=>
                    logout()

                  ,
                  child: Container(
                    height: _width * 15,
                    width: _width * 80,
                    child: GlassMorphism(
                      end: 0,
                      start: 0.25,
                      borderRadius: 20,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: _width * 5,
                          ),
                          Icon(
                            FontAwesomeIcons.rightFromBracket,
                            color: primary,
                          ),
                          SizedBox(
                            width: _width * 10,
                          ),
                          Text(
                            "Logout",
                            textScaleFactor: 1.2,
                            style: TextStyle(color: primary),
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
      ),
    );
  }
}

class EditUsernameCard extends StatefulWidget {
  String username;
  EditUsernameCard({
    required this.username,
    Key? key,
  }) : super(key: key);

  @override
  _EditUsernameCardState createState() => _EditUsernameCardState();
}

class _EditUsernameCardState extends State<EditUsernameCard> {
  TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.username;
  }

  editusername() async {
    try {
      String endPoint = dotenv.env["URL"].toString();
      final storage = new FlutterSecureStorage();
      String? value = await storage.read(key: "authtoken");
      var response = await http.post(
          Uri.parse(endPoint + "/api/user/changeusername"),
          body: {"token": value, "username": _usernameController.text});
      var res = jsonDecode(response.body) as Map<String, dynamic>;
      if (res['flag']) {
        setState(() {
          username:
          _usernameController.text;
        });
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
            "Successfully changed", "keep using", green, Icons.close));
      } else {
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
            "Please contact admin to resolve",
            res['message'],
            pink,
            Icons.close));
      }
    } catch (e) {
      return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          "Please contact admin to resolve", e.toString(), pink, Icons.close));
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
    double height = MediaQuery.of(context).size.height * 0.01;
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
                  color: purple,
                ),
              ),
              SizedBox(height: width * 5),
              Container(
                // padding: EdgeInsets.only(left: width * 4, right: width * 4),
                child: textFieldUi(
                    text: 'New Username',
                    icon: Icons.wallet,
                    textColor: purple,
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
                    child: Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      primary: white.withOpacity(0.2),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(width: width * 2.5),
                  ElevatedButton(
                    onPressed: () {
                      //TODO: implement edit transaction functionality
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
                    child: Text('Save'),
                    style: ElevatedButton.styleFrom(
                      primary: white.withOpacity(0.2),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
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
  ChangePasswordCard({
    Key? key,
  }) : super(key: key);

  @override
  _ChangePasswordCardState createState() => _ChangePasswordCardState();
}

class _ChangePasswordCardState extends State<ChangePasswordCard> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  changepassword() async {
    try {
      String endPoint = dotenv.env["URL"].toString();
      final storage = new FlutterSecureStorage();
      String? value = await storage.read(key: "authtoken");
      var response = await http.post(
          Uri.parse(endPoint + "/api/user/changepassword"),
          body: {"token": value, "password": _passwordController.text});
      var res = jsonDecode(response.body) as Map<String, dynamic>;
      if (res['flag']) {
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
            "Password changed Successfully", "keep using", green, Icons.close));
      } else {
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
            "Please contact admin to resolve",
            res['message'],
            pink,
            Icons.close));
      }
    } catch (e) {
      return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          "Please contact admin to resolve", e.toString(), pink, Icons.close));
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
    double height = MediaQuery.of(context).size.height * 0.01;
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
                  color: purple,
                ),
              ),
              SizedBox(height: width * 5),
              Container(
                // padding: EdgeInsets.only(left: width * 4, right: width * 4),
                child: textFieldUi(
                    text: 'New Password',
                    icon: Icons.wallet,
                    textColor: purple,
                    isPasswordType: false,
                    controller: _passwordController,
                    inputType: TextInputType.name),
              ),
              SizedBox(height: width * 5),
              Container(
                // padding: EdgeInsets.only(left: width * 4, right: width * 4),
                child: textFieldUi(
                    text: 'Confirm Password',
                    icon: Icons.wallet,
                    textColor: purple,
                    isPasswordType: false,
                    controller: _passwordController,
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
                    child: Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      primary: white.withOpacity(0.2),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(width: width * 2.5),
                  ElevatedButton(
                    onPressed: () {
                      //TODO: implement edit transaction functionality
                      // editdata();
                      // Navigator.of(context).popUntil(( context, MaterialPageRout));
                      // if(Navigator.canPop(context)) {
                      //   // Navigator.canPop return true if can pop
                      //   Navigator.pop(context);
                      // }
                      // Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=>TransactionPage()));
                      changepassword();
                      Navigator.of(context).pop();
                    },
                    child: Text('Save'),
                    style: ElevatedButton.styleFrom(
                      primary: white.withOpacity(0.2),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
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
