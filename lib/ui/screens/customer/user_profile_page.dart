import 'package:dice_bear/dice_bear.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/colors.dart';
import '../../widgets/glassmorphic_container.dart';

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

  @override
  void initState() {
    super.initState();
  }
  String username = "Rahul Mokaria";
  Avatar _avatar = DiceBearBuilder(sprite: DiceBearSprite.initials, seed: "Rahul" ).build();
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
              _width * 10,
            ),
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.only(
              //   topLeft: Radius.circular(_width * 10),
              //   topRight: Radius.circular(_width * 10),
              // ),
              color: secondary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(_width * 5),
                  child: _avatar.toImage(
                    height: _width * 80,
                    width: _width * 80,
                    fit: BoxFit.fitWidth,
                  ),
                  // Image.network(
                  //   urlimg,
                  //   height: MediaQuery.of(context).size.width,
                  //   width: MediaQuery.of(context).size.width,
                  //   fit: BoxFit.cover,
                  // ),
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
                          FontAwesomeIcons.solidUser,
                          color: primary,
                        ),
                        SizedBox(
                          width: _width * 10,
                        ),
                        Text(
                          "Name",
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
                          "emailID@kuchbhi.com",
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
