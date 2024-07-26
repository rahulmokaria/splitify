import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../utils/colors.dart';
import '../../widgets/show_snackbar.dart';
import 'expense_tracker/expense_tracker.dart';
import 'group_splits/group_splits.dart';
import 'split_bills/split_bills.dart';
import 'user_profile_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, this.currentIndex = 0});
  int currentIndex = 0;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  initState() {
    super.initState();
    getContactsPermission();
  }

  getContactsPermission() async {
    if (await Permission.contacts.request().isGranted) {
      // Permission to access contacts is granted
    } else {
      // Permission to access contacts is denied
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          ctype: ContentType.failure,
          message:
              "Contact access denied. Please allow the app to access the contact list."));
    }
  }

  static final List<Widget> _widgetOptions = <Widget>[
    const ExpenseTracker(),
    const SplitBillsPage(),
    // Text('Expense Tracker Page',
    // style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    // Text('Splitwise Page',
    // style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    // GameWidget(
    //   game: NeonSphereGame(),
    // ),
    const GroupSplits(),
    // const Text('Bills Shopkeeper Page',
    //     style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    // Text('Notification Page',
    // style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    const UserProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _widgetOptions,
        onPageChanged: (index) {
          setState(() {
            widget.currentIndex = index;
          });
        },
      ),
      //  _widgetOptions.elementAt(_currentIndex),
      bottomNavigationBar: SalomonBottomBar(
        backgroundColor: secondaryLight,
        currentIndex: widget.currentIndex,
        onTap: (i) => setState(() {
          widget.currentIndex = i;
          _pageController.animateToPage(i,
              duration: const Duration(milliseconds: 500), curve: Curves.ease);
        }),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(FontAwesomeIcons.house),
            title: const Text("Expenses"),
            selectedColor: purple,
            unselectedColor: Colors.white,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: const Icon(FontAwesomeIcons.circleDollarToSlot),
            title: const Text("Friends"),
            selectedColor: green,
            unselectedColor: Colors.white,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: const Icon(FontAwesomeIcons.userGroup),
            title: const Text("Groups"),
            selectedColor: orange,
            unselectedColor: Colors.white,
          ),
          //Notification
          // SalomonBottomBarItem(
          //   icon: const Icon(FontAwesomeIcons.solidBell),
          //   title: const Text("Notifications"),
          //   selectedColor: pink,
          //   unselectedColor: Colors.white,
          // ),

          /// Profile
          SalomonBottomBarItem(
            icon: const Icon(FontAwesomeIcons.solidUser),
            title: const Text("Profile"),
            selectedColor: primary,
            unselectedColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
