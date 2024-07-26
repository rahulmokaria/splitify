import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../models/friend.dart';
import '../../../utils/colors.dart';
import '../../../widgets/glassmorphic_container.dart';
import '../../../widgets/show_snackbar.dart';
import 'add_new_friend_from_contact.dart';
import 'friend_details.dart';

class SplitBillsPage extends StatefulWidget {
  const SplitBillsPage({super.key});

  @override
  State<SplitBillsPage> createState() => _SplitBillsPageState();
}

class _SplitBillsPageState extends State<SplitBillsPage> {
  TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  List<Friend> friendList = [];
  List<Friend> filteredFriends = [];

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
      filteredFriends = friendList;
      // print(friendList);
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

  void filterFriends() {
    final searchText = _searchController.text.toLowerCase();

    setState(() {
      filteredFriends = friendList.where((friend) {
        final name = friend.friendName.toLowerCase();
        return name.contains(searchText);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getFriendList();
    _searchController = TextEditingController();
    _searchController.addListener(filterFriends);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.01;
    // double _height = MediaQuery.of(context).size.height * 0.01;
    // return SafeArea(
    // child: Scaffold(
    return Scaffold(
      backgroundColor: secondary,
      appBar: AppBar(
        leading:
            const InkWell(child: Icon(FontAwesomeIcons.circleDollarToSlot)),
        title: const Text(
          'Friend Expenses',
        ),
        backgroundColor: green,
      ),
      body: Container(
        width: width * 100,
        color: secondary,
        padding: EdgeInsets.all(width * 5),
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    TextField(
                      cursorColor: white,
                      controller: _searchController,
                      focusNode: _searchFocus,
                      style: const TextStyle(color: white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        prefixIcon: Icon(
                          FontAwesomeIcons.magnifyingGlass,
                          color: _searchFocus.hasFocus
                              ? Colors.white
                              : Colors.grey,
                        ),
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: _searchFocus.hasFocus
                              ? Colors.white
                              : Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: width * 5,
                    ),
                    if (filteredFriends.isEmpty)
                      const Center(
                        child: Text(
                          "No friend found",
                          style: TextStyle(color: white),
                        ),
                      )
                    else
                      Column(
                        children: [
                          for (var friend in filteredFriends) ...{
                            FriendViewBox(friend: friend),
                            SizedBox(height: width * 5),
                          }
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const AddFriendFromContactsPage()));
        },
        child: SizedBox(
          height: width * 15,
          width: width * 40,
          child: GlassMorphism(
            end: 0,
            start: 0.25,
            accent: green,
            borderRadius: 20,
            child: const Center(
              child: Text(
                "Add Friend",
                // textScaleFactor: 1.2,
                textScaler: TextScaler.linear(1.2),
                style: TextStyle(color: white),
              ),
            ),
          ),
        ),
      ),
      // ),
    );
  }
}

class FriendViewBox extends StatelessWidget {
  final Friend friend;
  const FriendViewBox({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.01;

    return InkWell(
      onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => FriendDetails(friend: friend))),
      child: Container(
          width: width * 100,
          height: width * 23,
          decoration: BoxDecoration(
              color: green.withOpacity(0.1),
              border: Border.all(color: green.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(20)),
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
                    friend.photoUrl,
                    // _avatar.svgUri.toString(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: width * 5,
              ),
              Text(
                friend.friendName,
                // textScaleFactor: 1.2,
                textScaler: const TextScaler.linear(1.2),
                style: const TextStyle(color: white),
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    friend.totalBalance == 0
                        ? 'Settled'
                        : (friend.totalBalance > 0)
                            ? 'owes you'
                            : "you owe",
                    style: TextStyle(
                      color: friend.totalBalance >= 0 ? green : red,
                    ),
                  ),
                  SizedBox(
                    height: width * 2,
                  ),
                  Text(
                    friend.totalBalance.toStringAsFixed(2),
                    style: TextStyle(
                      color: friend.totalBalance >= 0 ? green : red,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: width * 5,
              ),
            ],
          )),
    );
  }
}
