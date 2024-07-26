import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../utils/colors.dart';
import '../../../widgets/glassmorphic_container.dart';
import '../../../widgets/show_snackbar.dart';
import 'add_group_page.dart';
import 'group_details.dart';

class GroupSplits extends StatefulWidget {
  const GroupSplits({super.key});

  @override
  State<GroupSplits> createState() => _GroupSplitsState();
}

class _GroupSplitsState extends State<GroupSplits> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  List<Group> groupList = [];

  getGroupList() async {
    try {
      String endPoint = dotenv.env["URL"].toString();
      const storage = FlutterSecureStorage();
      String? value = await storage.read(key: "authtoken");
      var response = await http
          .post(Uri.parse("$endPoint/groupSplitApi/getUserGroups"), body: {
        "token": value,
      });

      // print(response.body);

      var res = jsonDecode(response.body) as Map<String, dynamic>;
      // print(1);
      // print(res);
      if (res['flag']) {
        // print(3);
        // var userId = res['userId'];
        // print(4);
        var resList = res['groupListDetails'] as List<dynamic>;
        List<Group> tempGroup = [];
        // print(5);
        for (var groupJson in resList) {
          // // print(6);
          // double amt = double.parse(groupJson['amount'].toString());
          String grpName = groupJson['groupName'].toString();
          String grpId = groupJson['groupId'].toString();
          // print(8);
          // print(groupJson['members'].runtimeType);
          List<Member> grpMembers = [];
          for (var entry in groupJson['members']) {
            grpMembers.add(
              Member(
                  userName: entry['userName'].toString(),
                  userId: entry['userId'].toString()),
            );
          }
          // print(7);
          List<Balances> balances = [];
          for (Map<String, dynamic> entry in groupJson['borrowings']) {
            balances.add(Balances(
                amount: entry['amount'],
                friendId: entry['friendId'],
                friendName: entry['friendName']));
          }
          // print(6);
          tempGroup.add(Group(
            groupId: grpId,
            groupName: grpName,
            profilePicUrl: 'https://picsum.photos/200',
            members: grpMembers,
            borrowings: balances,
          ));
        }
        groupList = tempGroup;
      }
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      // print("e=" + e.toString());
      return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
        ctype: ContentType.failure,
        message: "$e. Please contact admin to resolve",
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    getGroupList();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.01;

    return Scaffold(
      backgroundColor: secondary,
      appBar: AppBar(
        leading: const InkWell(child: Icon(FontAwesomeIcons.userGroup)),
        title: const Text(
          'Group Expenses',
        ),
        backgroundColor: orange,
      ),
      body: Container(
        width: width * 100,
        color: secondary,
        padding: EdgeInsets.all(width * 5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //friend or group

              Column(
                children: [
                  TextField(
                    cursorColor: white,
                    controller: _searchController,
                    focusNode: _searchFocus,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      prefixIcon: Icon(
                        FontAwesomeIcons.magnifyingGlass,
                        color:
                            _searchFocus.hasFocus ? Colors.white : Colors.grey,
                      ),
                      // suffixIcon: IconButton(
                      //   icon: Icon(
                      //     Icons.clear,
                      //     color: _searchFocus.hasFocus
                      //         ? Colors.white
                      //         : Colors.transparent,
                      //   ),
                      //   onPressed: () {
                      //     _searchController.clear();
                      //   },
                      // ),
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color:
                            _searchFocus.hasFocus ? Colors.white : Colors.grey,
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
                  if (groupList.isEmpty)
                    const Center(
                      child: Text(
                        'No Group created',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  else
                    ...groupList
                        .map((group) => Column(
                              children: [
                                GroupViewBox(group: group),
                                SizedBox(
                                  height: width * 5,
                                ),
                              ],
                            ))
                        .toList(),
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: InkWell(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const AddGroupPage()));
          },
          child: SizedBox(
            height: width * 15,
            width: width * 40,
            child: GlassMorphism(
              end: 0,
              start: 0.25,
              accent: orange,
              borderRadius: 20,
              child: const Center(
                child: Text(
                  "Create Group",
                  // textScaleFactor: 1.2,
                  textScaler: TextScaler.linear(1.2),
                  style: TextStyle(color: white),
                ),
              ),
            ),
          )),
      // ),
    );
  }
}

class Balances {
  double amount;
  String friendId;
  String friendName;

  Balances(
      {required this.amount, required this.friendId, required this.friendName});
}

class Member {
  String userId;
  String userName;
  Member({required this.userId, required this.userName});
}

class Group {
  String groupName;
  String profilePicUrl;
  List<Balances> borrowings;
  String groupId;
  List<Member> members;

  Group(
      {required this.groupName,
      required this.profilePicUrl,
      required this.groupId,
      required this.members,
      required this.borrowings});
}

class GroupViewBox extends StatelessWidget {
  final Group group;
  const GroupViewBox({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    // Avatar _avatar =
    // DiceBearBuilder(sprite: DiceBearSprite.initials, seed: group.groupName)
    // .build();
    // String urlimg = _avatar.svgUri.toString();
    // print(urlimg);
    double width = MediaQuery.of(context).size.width * 0.01;
    // double _height = MediaQuery.of(context).size.height * 0.01;
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => GroupDetails(groupId: group.groupId))),
      child: Container(
          width: width * 100,
          height: width * 40,
          decoration: BoxDecoration(
              color: white.withOpacity(0.1),
              border: Border.all(color: orange.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              SizedBox(
                width: width * 5,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: secondary,
                  height: width * 30,
                  width: width * 30,
                  child:
                      //  _avatar.toImage(fit: BoxFit.cover),
                      Image.network(
                    group.profilePicUrl,
                    // _avatar.svgUri.toString(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: width * 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.groupName,
                    // textScaleFactor: 1.2,
                    textScaler: const TextScaler.linear(1.2),
                    style: const TextStyle(color: white),
                  ),
                  SizedBox(
                    height: width * 2,
                  ),
                  // Text(
                  //   group.totalBalance >= 0
                  //       ? 'you are owed ${group.totalBalance}'
                  //       : "you owe ${-group.totalBalance}",
                  //   style: TextStyle(
                  //     color: group.totalBalance >= 0 ? green : red,
                  //   ),
                  // ),
                  group.borrowings.isEmpty
                      ? Text(
                          "All Settled Up.",
                          style: TextStyle(
                            color: white,
                          ),
                          textScaler: TextScaler.linear(0.8),
                        )
                      : Column(
                          children: [
                            for (var entry in group.borrowings) ...{
                              Text(
                                entry.amount >= 0
                                    ? '${entry.friendName} owes ${entry.amount} to you.'
                                    : "you owe ${-entry.amount} to ${entry.friendName}.",
                                style: TextStyle(
                                  color: entry.amount >= 0 ? green : red,
                                ),
                                textScaler: TextScaler.linear(0.8),
                              ),
                            }
                          ],
                        )
                ],
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       group.totalBalance >= 0
              //           ? 'you are owed ' + group.totalBalance.toString()
              //           : "you owe " + group.totalBalance.toString(),
              //       style: TextStyle(
              //         color: group.totalBalance >= 0 ? green : red,
              //       ),
              //     ),
              //     SizedBox(
              //       height: width * 2,
              //     ),
              //     Text(
              //       group.totalBalance.toStringAsFixed(2),
              //       style: TextStyle(
              //         color: group.totalBalance >= 0 ? green : red,
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(
                width: width * 5,
              ),
            ],
          )),
    );
  }
}
