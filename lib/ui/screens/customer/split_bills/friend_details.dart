import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../models/transaction.dart';
import '../../../utils/colors.dart';
import '../../../widgets/bill_split_transaction.dart';
import '../../../widgets/glassmorphic_container.dart';
import 'split_bills.dart';

class FriendDetails extends StatefulWidget {
  Friend friend;
  FriendDetails({
    Key? key,
    required this.friend,
  }) : super(key: key);

  @override
  State<FriendDetails> createState() => _FriendDetailsState();
}

class _FriendDetailsState extends State<FriendDetails> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;

    List<BillSplitTransaction> transactions = [
      BillSplitTransaction(
        id: "1",
        fromFriend: "Alice",
        toFriend: "Bob",
        amount: 20.0,
        remark: "Lunch at Cafe",
        transactionDate: DateTime(2022, 4, 28),
      ),
      BillSplitTransaction(
        id: "2",
        fromFriend: "Bob",
        toFriend: "Alice",
        amount: 15.0,
        remark: "Dinner at Restaurant",
        transactionDate: DateTime(2022, 4, 29),
      ),
      BillSplitTransaction(
        id: "3",
        fromFriend: "Alice",
        toFriend: "Bob",
        amount: 10.0,
        remark: "Movie tickets",
        transactionDate: DateTime(2022, 5, 1),
      ),
      BillSplitTransaction(
        id: "4",
        fromFriend: "Bob",
        toFriend: "Alice",
        amount: 5.0,
        remark: "Snacks at Cinema",
        transactionDate: DateTime(2022, 5, 2),
      ),
      BillSplitTransaction(
        id: "5",
        fromFriend: "Alice",
        toFriend: "Bob",
        amount: 25.0,
        remark: "Shopping at Mall",
        transactionDate: DateTime(2022, 5, 3),
      ),
      BillSplitTransaction(
        id: "6",
        fromFriend: "Bob",
        toFriend: "Alice",
        amount: 12.0,
        remark: "Coffee at Starbucks",
        transactionDate: DateTime(2022, 5, 4),
      ),
      BillSplitTransaction(
        id: "7",
        fromFriend: "Alice",
        toFriend: "Bob",
        amount: 18.0,
        remark: "Dinner at Home",
        transactionDate: DateTime(2022, 5, 5),
      ),
      BillSplitTransaction(
        id: "8",
        fromFriend: "Bob",
        toFriend: "Alice",
        amount: 6.0,
        remark: "Ice Cream at Parlor",
        transactionDate: DateTime(2022, 5, 6),
      ),
      BillSplitTransaction(
        id: "9",
        fromFriend: "Alice",
        toFriend: "Bob",
        amount: 22.0,
        remark: "Concert tickets",
        transactionDate: DateTime(2022, 5, 7),
      ),
      BillSplitTransaction(
        id: "10",
        fromFriend: "Bob",
        toFriend: "Alice",
        amount: 8.0,
        remark: "Donuts at Bakery",
        transactionDate: DateTime(2022, 5, 8),
      ),
      BillSplitTransaction(
        id: "11",
        fromFriend: "Alice",
        toFriend: "Bob",
        amount: 30.0,
        remark: "Weekend getaway",
        transactionDate: DateTime(2022, 5, 9),
      ),
      BillSplitTransaction(
        id: "12",
        fromFriend: "Bob",
        toFriend: "Alice",
        amount: 15.0,
        remark: "Gas for Road trip",
        transactionDate: DateTime(2022, 5, 10),
      ),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width * 0.02,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_width * 10),
              topRight:
                  Radius.circular(MediaQuery.of(context).size.width * 0.1),
            ),
            color: secondary,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        child: Image.network(
                          widget.friend.photoUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                widget.friend.name,
                textScaleFactor: 1.5,
                style: const TextStyle(
                  color: white,
                ),
              ),
              Text(
                (widget.friend.totalBalance >= 0)
                    ? 'You owe ${widget.friend.name} ${widget.friend.totalBalance.toStringAsFixed(2)}'
                    : '${widget.friend.name} owes you ${widget.friend.totalBalance.toStringAsFixed(2)}',
                textScaleFactor: 1.2,
                style: TextStyle(
                  color: (widget.friend.totalBalance >= 0) ? green : red,
                ),
              ),
              SizedBox(
                height: _width * 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    // onTap: () {
                    //   Navigator.of(context).push(MaterialPageRoute(
                    //       builder: (_) => CreateNewExpense(
                    //             isExpense: false,
                    //           )));
                    // },
                    child: Container(
                      height: _width * 15,
                      width: _width * 40,
                      child: const GlassMorphism(
                        end: 0,
                        start: 0.25,
                        borderRadius: 20,
                        child: Center(
                          child: Text(
                            "New Expense",
                            textScaleFactor: 1.2,
                            style: TextStyle(color: white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    // onTap: () {
                    //   Navigator.of(context).push(MaterialPageRoute(
                    //       builder: (_) => CreateNewExpense(
                    //             isExpense: true,
                    //           )));
                    // },
                    child: Container(
                      height: _width * 15,
                      width: _width * 40,
                      child: const GlassMorphism(
                        end: 0,
                        start: 0.25,
                        borderRadius: 20,
                        child: Center(
                          child: Text(
                            "Settle Up",
                            textScaleFactor: 1.2,
                            style: TextStyle(color: white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              for (var t in transactions) ...{
                BillSplitTransactionBox(
                  transaction: t,
                ),
              }
            ],
          ),
        ),
      ),
    );
  }
}
