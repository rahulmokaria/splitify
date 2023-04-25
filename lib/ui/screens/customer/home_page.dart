import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:splitify/ui/screens/customer/expense_tracker.dart';
import 'package:splitify/ui/screens/customer/split_bills.dart';

import '../../utils/colors.dart';
import '../../widgets/bg.dart';
import 'user_profile_page.dart';

class CusHomePage extends StatefulWidget {
  const CusHomePage({super.key});

  @override
  State<CusHomePage> createState() => _CusHomePageState();
}

class _CusHomePageState extends State<CusHomePage> {
  var _currentIndex = 0;

  PageController _pageController = PageController(initialPage: 0);

  static List<Widget> _widgetOptions = <Widget>[
    const ExpenseTracker(),
    const SplitBillsPage(),
    // Text('Expense Tracker Page',
    // style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    // Text('Splitwise Page',
    // style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    // GameWidget(
    //   game: NeonSphereGame(),
    // ),
    const Text('Bills Shopkeeper Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    const UserProfile(),
    // Text('Profile Page',
    // style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _widgetOptions,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      //  _widgetOptions.elementAt(_currentIndex),
      bottomNavigationBar: SalomonBottomBar(
        backgroundColor: secondaryLight,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() {
          _currentIndex = i;
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
            title: const Text("Bill Splits"),
            selectedColor: green,
            unselectedColor: Colors.white,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: const Icon(FontAwesomeIcons.shop),
            title: const Text("Pay Shops"),
            selectedColor: orange,
            unselectedColor: Colors.white,
          ),

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
