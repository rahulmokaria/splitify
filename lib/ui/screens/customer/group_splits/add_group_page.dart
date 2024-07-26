import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:splitify/ui/screens/customer/home_page.dart';

import '../../../models/friend.dart';
import '../../../utils/colors.dart';
import '../../../widgets/show_snackbar.dart';

class AddGroupPage extends StatefulWidget {
  const AddGroupPage({super.key});

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  final TextEditingController _groupNameController = TextEditingController();
  bool _isLoading = false;
  List<Friend> friendList = [];
  final List<Friend> selectedFriends = [];

  getFriendList() async {
    try {
      String endPoint = dotenv.env["URL"].toString();
      const storage = FlutterSecureStorage();
      String? value = await storage.read(key: "authtoken");
      var response = await http
          .post(Uri.parse("$endPoint/friendSplitApi/getUserFriends"), body: {
        "token": value,
      });
      // print(1);
      var res = jsonDecode(response.body) as Map<String, dynamic>;
      // print(2);
      if (res['flag']) {
        // print(3);
        var userId = res['message']['userId'];
        // print(4);
        var resList = res['message']['friendList'] as List<dynamic>;
        // print(5);
        for (var friendJson in resList) {
          var friend = friendJson;
          // print(6);
          double amt = double.parse(friend['amount'].toString());
          // print(amt);
          if (friend['giverId'] != null && friend['giverId'] != userId) {
            amt = -amt;
          }
          friendList.add(Friend(
            friendName: friend['friendName'],
            friendId: friend['friendId'],
            totalBalance: amt,
            photoUrl: 'https://i.pravatar.cc/150?img=4',
            id: friend['friendDebtId'],
          ));
        }
      }
      setState(() {});
    } catch (e) {
      // print("Get All Friends error: " + e.toString());
      if (!mounted) return;
      return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
        ctype: ContentType.failure,
        message: "$e. Please contact admin to resolve",
      ));
    }
  }

  createGroup() async {
    print(selectedFriends);
    try {
      setState(() {
        _isLoading = true;
      });
      String endPoint = dotenv.env["URL"].toString();
      const storage = FlutterSecureStorage();
      String? value = await storage.read(key: "authtoken");

      List<Map<String, String>> usersList = [];
      print(usersList);

      for (Friend friend in selectedFriends) {
        usersList.add({"userId": friend.friendId, "userName": friend.friendName});
      }
      print(usersList);
      String users = jsonEncode(usersList);

      var response = await http.post(
        Uri.parse("$endPoint/GroupSplitApi/createGroup"),
        body: {
          "token": value,
          // "contactNo": ,
          "groupName": _groupNameController.text,
          "users": users,
        },
      );
      print(users);
      
      var res = jsonDecode(response.body) as Map<String, dynamic>;
      // print(res);
      if (res['flag']) {
        if (res['message'] == "Success") {
          if (!mounted) return;
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => HomePage(
                    currentIndex: 2,
                  )));

          return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
            ctype: ContentType.success,
            message:
                "Group created successfully. Now you can easily split bills.",
          ));
        } else {
          throw res['message'];
        }
      }
    } catch (e) {
      print("create group error: $e");
      if (!mounted) return;
      Navigator.of(context).pop();
      return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
        ctype: ContentType.failure,
        message: "$e. Please contact admin to resolve",
      ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFriendList();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.01;
    // print(context);
    // print("dgbrsth");
    return Scaffold(
      backgroundColor: secondary,
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(FontAwesomeIcons.arrowLeft)),
        title: const Text(
          'Add new group',
        ),
        backgroundColor: orange,
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 2),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: width * 5,
              ),
              //groupname
              TextField(
                cursorColor: orange,
                controller: _groupNameController,
                decoration: InputDecoration(
                  labelText: 'Group Name',
                  labelStyle: const TextStyle(color: white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: orange),
                  ),
                ),
                style: const TextStyle(color: white),
              ),
              SizedBox(
                height: width * 5,
              ),
              //add friend from friends
              Text(
                "Select group members",
                textScaler: const TextScaler.linear(1.2),
                style: TextStyle(color: orange),
              ),
              Column(
                children: friendList.map((friend) {
                  final isSelected = selectedFriends.contains(friend);
                  return Container(
                    width: width * 90, // 75% of screen width
                    margin: const EdgeInsets.symmetric(
                        vertical: 4.0), // Optional spacing between items
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedFriends.remove(friend);
                          } else {
                            selectedFriends.add(friend);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: isSelected ? orange : white.withOpacity(0.2),
                          border: Border.all(
                              color:
                                  isSelected ? orange : white.withOpacity(0.2)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          friend.friendName,
                          style: TextStyle(
                            color: isSelected ? white : white.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              // if (friendList.isEmpty)
              //   const Center(
              //     child: Text(
              //       "No friend found",
              //       style: TextStyle(color: white),
              //     ),
              //   )
              // else
              //   Column(
              //     children: [
              //       for (var friend in friendList) ...{
              //         FriendSelectionBox(friend: friend,isSelected: ,),
              //         SizedBox(height: width * 5),
              //       }
              //     ],
              //   ),

              SizedBox(height: width * 0.05),
              //add someone from contants

              SizedBox(
                height: width * 5,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(width * 3, 0, width * 3, 0),
                child: Text(
                  "If you want to add friends from contacts, you need to add contact to your friend List.",
                  style: TextStyle(color: white.withOpacity(0.5)),
                ),
              ),
              SizedBox(
                height: width * 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: width * 15,
                // margin: EdgeInsets.only(left: width * 4, right: width * 4),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(90)),
                child: ElevatedButton(
                  onPressed: createGroup,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith(
                      (states) {
                        if (states.contains(WidgetState.pressed)) {
                          return secondary;
                        }
                        return orange;
                      },
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(width * 3))),
                  ),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: white,
                          ),
                        )
                      : const Text(
                          "Create Group",
                          style: TextStyle(
                            color: secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FriendSelectionBox extends StatelessWidget {
  final Friend friend;
  final bool isSelected;
  final VoidCallback onTap;

  const FriendSelectionBox({
    super.key,
    required this.friend,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.01;

    return InkWell(
      onTap: onTap, // Handle tap on friend selection box
      child: Container(
        width: width * 100,
        height: width * 23,
        decoration: BoxDecoration(
          color: isSelected ? green.withOpacity(0.3) : white.withOpacity(0.1),
          border: Border.all(color: green.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            SizedBox(
              width: width * 5,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                color: secondary,
                height: width * 18,
                width: width * 18,
                child: Image.network(
                  'https://picsum.photos/200',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: width * 5,
            ),
            SizedBox(
              width: width * 48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      friend.friendName,
                      overflow: TextOverflow.ellipsis,
                      // textScaleFactor: 1,
                      style: const TextStyle(color: white),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              FontAwesomeIcons.check,
              color: white,
            ),
            SizedBox(
              width: width * 5,
            ),
          ],
        ),
      ),
    );
  }
}
