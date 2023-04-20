import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:splitify/screens/customer/expense_tracker.dart';

import '../../utils/colors.dart';

class CusHomePage extends StatefulWidget {
  const CusHomePage({super.key});

  @override
  State<CusHomePage> createState() => _CusHomePageState();
}

class _CusHomePageState extends State<CusHomePage> {
  var _currentIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    ExpenseTracker(),
    // Text('Expense Tracker Page',
    // style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Splitwise Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Bills Shopkeeper Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Profile Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_currentIndex),
      bottomNavigationBar: SalomonBottomBar(
        backgroundColor: secondaryLight,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Expenses"),
            selectedColor: purple,
            unselectedColor: Colors.white,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: Icon(Icons.favorite_border),
            title: Text("Bill Splits"),
            selectedColor: pink,
            unselectedColor: Colors.white,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: Icon(Icons.search),
            title: Text("Pay Shops"),
            selectedColor: orange,
            unselectedColor: Colors.white,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
            selectedColor: primary,
            unselectedColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
