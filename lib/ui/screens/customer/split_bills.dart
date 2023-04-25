import 'dart:math';

import 'package:dice_bear/dice_bear.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:splitify/ui/screens/customer/friend_details.dart';
import 'package:splitify/ui/utils/colors.dart';

import '../../widgets/glassmorphic_container.dart';
import 'group_details.dart';

class SplitBillsPage extends StatefulWidget {
  const SplitBillsPage({super.key});

  @override
  State<SplitBillsPage> createState() => _SplitBillsPageState();
}

class _SplitBillsPageState extends State<SplitBillsPage> {
  bool isTabFriend = true;
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> imageUrls = [
      'https://i.pravatar.cc/150?img=1',
      'https://i.pravatar.cc/150?img=2',
      'https://i.pravatar.cc/150?img=3',
      'https://i.pravatar.cc/150?img=4',
      'https://i.pravatar.cc/150?img=5',
      'https://i.pravatar.cc/150?img=6',
      'https://i.pravatar.cc/150?img=7',
      'https://i.pravatar.cc/150?img=8',
      'https://i.pravatar.cc/150?img=9',
      'https://i.pravatar.cc/150?img=10',
    ];

    List<Group> groupList = [
      Group(
        groupName: 'Group 1',
        profilePicUrl: 'https://picsum.photos/200',
        totalBalance: 1000.0,
      ),
      Group(
        groupName: 'Group 2',
        profilePicUrl: 'https://picsum.photos/200',
        totalBalance: -2000.0,
      ),
      Group(
        groupName: 'Group 3',
        profilePicUrl: 'https://picsum.photos/200',
        totalBalance: 3000.0,
      ),
      Group(
        groupName: 'Group 4',
        profilePicUrl: 'https://picsum.photos/200',
        totalBalance: 4000.0,
      ),
      Group(
        groupName: 'Group 5',
        profilePicUrl: 'https://picsum.photos/200',
        totalBalance: -5000.0,
      ),
      Group(
        groupName: 'Group 6',
        profilePicUrl: 'https://picsum.photos/200',
        totalBalance: 6000.0,
      ),
      Group(
        groupName: 'Group 7',
        profilePicUrl: 'https://picsum.photos/200',
        totalBalance: 7000.0,
      ),
      Group(
        groupName: 'Group 8',
        profilePicUrl: 'https://picsum.photos/200',
        totalBalance: 8000.0,
      ),
      Group(
        groupName: 'Group 9',
        profilePicUrl: 'https://picsum.photos/200',
        totalBalance: 9000.0,
      ),
      Group(
        groupName: 'Group 10',
        profilePicUrl: 'https://picsum.photos/200',
        totalBalance: 10000.0,
      ),
    ];

    List<Friend> friendList = List.generate(10, (index) {
      String randomImageUrl = imageUrls[Random().nextInt(imageUrls.length)];
      String randomName = 'Friend ${index + 1}';
      double randomBalance = Random().nextDouble() * 500.0;
      if (randomBalance < 250) randomBalance = -randomBalance;
      return Friend(
        name: randomName,
        photoUrl: randomImageUrl,
        totalBalance: randomBalance,
      );
    });
    // _tabController = TabController(length: 3, vsync: this);
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: _width * 100,
          color: secondary,
          padding: EdgeInsets.all(_width * 5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //friend or group
                Container(
                  height: _width * 15,
                  width: _width * 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: white.withOpacity(0.2)),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => setState(() {
                          isTabFriend = true;
                        }),
                        child: Container(
                          width: _width * 45,
                          height: _width * 15,
                          decoration: BoxDecoration(
                            color: isTabFriend ? green : white.withOpacity(0),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: Text(
                              "Friends",
                              textScaleFactor: 1.2,
                              style: TextStyle(
                                  color: isTabFriend ? secondary : green),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() {
                          isTabFriend = false;
                        }),
                        child: Container(
                          width: _width * 45,
                          height: _width * 15,
                          decoration: BoxDecoration(
                            color: isTabFriend ? white.withOpacity(0) : green,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: Text(
                              "Groups",
                              textScaleFactor: 1.2,
                              style: TextStyle(
                                  color: isTabFriend ? green : secondary),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: _width * 5,
                ),
                isTabFriend
                    ? Container(
                        child: Column(
                        children: [
                          TextField(
                            cursorColor: white,
                            controller: _searchController,
                            focusNode: _searchFocus,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              prefixIcon: Icon(
                                Icons.search,
                                color: _searchFocus.hasFocus
                                    ? Colors.white
                                    : Colors.grey,
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
                            height: _width * 5,
                          ),
                          for (var friend in friendList) ...{
                            FriendViewBox(friend: friend),
                            SizedBox(
                              height: _width * 5,
                            )
                          }
                        ],
                      )
                        //  Icon(
                        //   FontAwesomeIcons.accessibleIcon,
                        //   color: white,
                        // ),
                        )
                    : Container(
                        child: Column(
                        children: [
                          TextField(
                            cursorColor: white,
                            controller: _searchController,
                            focusNode: _searchFocus,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              prefixIcon: Icon(
                                Icons.search,
                                color: _searchFocus.hasFocus
                                    ? Colors.white
                                    : Colors.grey,
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
                            height: _width * 5,
                          ),
                          for (var group in groupList) ...{
                            GroupViewBox(group: group),
                            SizedBox(
                              height: _width * 5,
                            )
                          }
                        ],
                      )
                        //  Icon(
                        //   FontAwesomeIcons.accessibleIcon,
                        //   color: white,
                        // ),
                        )
              ],
            ),
          ),
        ),
        floatingActionButton: InkWell(
            onTap: () {},
            child: Container(
              height: _width * 15,
              width: _width * 40,
              child: GlassMorphism(
                end: 0,
                start: 0.25,
                borderRadius: 20,
                child: Center(
                  child: Text(
                    isTabFriend ? "Add Friend" : "Create Group",
                    textScaleFactor: 1.2,
                    style: const TextStyle(color: white),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}

class Friend {
  String name;
  String photoUrl;
  double totalBalance;

  Friend(
      {required this.name, required this.photoUrl, required this.totalBalance});
}

class FriendViewBox extends StatelessWidget {
  Friend friend;
  FriendViewBox({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    Avatar _avatar =
        DiceBearBuilder(sprite: DiceBearSprite.initials, seed: friend.name)
            .build();
    String urlimg = _avatar.svgUri.toString();
    print(urlimg);
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;
    return InkWell(
      onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => FriendDetails(friend: friend))),
      child: Container(
          width: _width * 100,
          height: _width * 23,
          decoration: BoxDecoration(
              color: white.withOpacity(0.1),
              border: Border.all(color: green.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              SizedBox(
                width: _width * 5,
              ),
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    color: secondary,
                    height: _width * 18,
                    width: _width * 18,
                    child: Image.network(
                      friend.photoUrl,
                      // _avatar.svgUri.toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: _width * 5,
              ),
              Text(
                friend.name,
                textScaleFactor: 1.2,
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
                    friend.totalBalance >= 0 ? 'owes you' : "you owe",
                    style: TextStyle(
                      color: friend.totalBalance >= 0 ? green : red,
                    ),
                  ),
                  SizedBox(
                    height: _width * 2,
                  ),
                  Text(
                    '${friend.totalBalance.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: friend.totalBalance >= 0 ? green : red,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: _width * 5,
              ),
            ],
          )),
    );
  }
}

class Group {
  final String groupName;
  final String profilePicUrl;
  final double totalBalance;

  Group({
    required this.groupName,
    required this.profilePicUrl,
    required this.totalBalance,
  });
}

class GroupViewBox extends StatelessWidget {
  Group group;
  GroupViewBox({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    Avatar _avatar =
        DiceBearBuilder(sprite: DiceBearSprite.initials, seed: group.groupName)
            .build();
    String urlimg = _avatar.svgUri.toString();
    print(urlimg);
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;
    return InkWell(
      onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (_)=>GroupDetails(group:group))),
      child: Container(
          width: _width * 100,
          height: _width * 40,
          decoration: BoxDecoration(
              color: white.withOpacity(0.1),
              border: Border.all(color: green.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              SizedBox(
                width: _width * 5,
              ),
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: secondary,
                    height: _width * 30,
                    width: _width * 30,
                    child: Image.network(
                      group.profilePicUrl,
                      // _avatar.svgUri.toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: _width * 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.groupName,
                    textScaleFactor: 1.2,
                    style: const TextStyle(color: white),
                  ),
                  SizedBox(
                    height: _width * 2,
                  ),
                  Text(
                    group.totalBalance >= 0
                        ? 'you are owed ${group.totalBalance}'
                        : "you owe ${-group.totalBalance}",
                    style: TextStyle(
                      color: group.totalBalance >= 0 ? green : red,
                    ),
                  ),
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
              //       height: _width * 2,
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
                width: _width * 5,
              ),
            ],
          )),
    );
  }
}
