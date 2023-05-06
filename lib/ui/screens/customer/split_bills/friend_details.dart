import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../models/transaction.dart';
import '../../../utils/colors.dart';
import '../../../widgets/bill_split_transaction.dart';
import '../../../widgets/glassmorphic_container.dart';
import 'friend_settle_up.dart';
import 'new_bill_split_page.dart';
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
        id: '1',
        shareOfPayer: 10.0,
        shareOfBorrower: 20.0,
        paidBy: 'Alice',
        amount: 30.0,
        transactionDate: DateTime.now(),
        remark: 'Lunch at the new restaurant',
      ),
      BillSplitTransaction(
        id: '2',
        shareOfPayer: 15.0,
        shareOfBorrower: 15.0,
        paidBy: 'Bob',
        amount: 30.0,
        transactionDate: DateTime.now(),
        remark: 'Movie tickets',
      ),
      BillSplitTransaction(
        id: '3',
        shareOfPayer: 5.0,
        shareOfBorrower: 25.0,
        paidBy: 'Alice',
        amount: 30.0,
        transactionDate: DateTime.now(),
        remark: 'Coffee and snacks',
      ),
      BillSplitTransaction(
        id: '4',
        shareOfPayer: 12.5,
        shareOfBorrower: 12.5,
        paidBy: 'Bob',
        amount: 25.0,
        transactionDate: DateTime.now(),
        remark: 'Dinner at the Italian restaurant',
      ),
      BillSplitTransaction(
        id: '5',
        shareOfPayer: 20.0,
        shareOfBorrower: 10.0,
        paidBy: 'Alice',
        amount: 30.0,
        transactionDate: DateTime.now(),
        remark: 'Drinks at the rooftop bar',
      ),
      BillSplitTransaction(
        id: '6',
        shareOfPayer: 7.0,
        shareOfBorrower: 23.0,
        paidBy: 'Bob',
        amount: 30.0,
        transactionDate: DateTime.now(),
        remark: 'Shopping at the mall',
      ),
      BillSplitTransaction(
        id: '7',
        shareOfPayer: 15.0,
        shareOfBorrower: 15.0,
        paidBy: 'Alice',
        amount: 30.0,
        transactionDate: DateTime.now(),
        remark: 'Concert tickets',
      ),
      BillSplitTransaction(
        id: '8',
        shareOfPayer: 10.0,
        shareOfBorrower: 20.0,
        paidBy: 'Bob',
        amount: 30.0,
        transactionDate: DateTime.now(),
        remark: 'Brunch at the cafe',
      ),
      BillSplitTransaction(
        id: '9',
        shareOfPayer: 18.0,
        shareOfBorrower: 12.0,
        paidBy: 'Alice',
        amount: 30.0,
        transactionDate: DateTime.now(),
        remark: 'Spa session',
      ),
      BillSplitTransaction(
        id: '10',
        shareOfPayer: 25.0,
        shareOfBorrower: 5.0,
        paidBy: 'Bob',
        amount: 30.0,
        transactionDate: DateTime.now(),
        remark: 'Skydiving experience',
      ),
      BillSplitTransaction(
        id: '11',
        shareOfPayer: 10.0,
        shareOfBorrower: 20.0,
        paidBy: 'Alice',
        amount: 30.0,
        transactionDate: DateTime.now(),
        remark: 'Visiting the art museum',
      ),
      BillSplitTransaction(
        id: '12',
        shareOfPayer: 22.0,
        shareOfBorrower: 8.0,
        paidBy: 'Bob',
        amount: 30.0,
        transactionDate: DateTime.now(),
        remark: 'Kuchbhi',
      )
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
                          'assets/greenbg.png',
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
              Container(
                padding: EdgeInsets.only(left: _width * 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.friend.name,
                      textScaleFactor: 1.5,
                      style: const TextStyle(
                        color: white,
                      ),
                    ),
                    Text(
                      (widget.friend.totalBalance == 0)
                          ? 'All settled up'
                          : (widget.friend.totalBalance < 0)
                              ? 'You owe ${widget.friend.name} ${widget.friend.totalBalance.toStringAsFixed(2)}'
                              : '${widget.friend.name} owes you ${widget.friend.totalBalance.toStringAsFixed(2)}',
                      textScaleFactor: 1.2,
                      style: TextStyle(
                        color: (widget.friend.totalBalance >= 0) ? green : red,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: _width * 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const NewBillSplitPage()));
                    },
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
                    onTap: () => showDialog(
                        context: context, builder: (_) => const SettleUpWithFriend()),
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
              SizedBox(
                height: _width * 5,
              ),
              for (var t in transactions) ...{
                BillSplitTransactionBox(
                  transaction: t,
                  friendName: widget.friend.name,
                ),
                SizedBox(
                  height: _width * 5,
                ),
              }
            ],
          ),
        ),
      ),
    );
  }
}
