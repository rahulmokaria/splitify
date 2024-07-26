import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../models/friend.dart';
import '../../../models/transaction.dart';
import '../../../utils/colors.dart';
import '../../../widgets/bill_split_transaction.dart';
import '../../../widgets/glassmorphic_container.dart';
import '../../../widgets/show_snackbar.dart';
import 'friend_settle_up.dart';
import 'new_bill_split_page.dart';
// import 'split_bills.dart';

class FriendDetails extends StatefulWidget {
  final Friend friend;
  const FriendDetails({
    Key? key,
    required this.friend,
  }) : super(key: key);

  @override
  State<FriendDetails> createState() => _FriendDetailsState();
}

class _FriendDetailsState extends State<FriendDetails> {
  // bool _isLoading = false;
  List<BillSplitTransaction> transactions = [];

  getTransactions() async {
    try {
      String endPoint = dotenv.env["URL"].toString();
      const storage = FlutterSecureStorage();
      String? value = await storage.read(key: "authtoken");
      var response = await http.post(
          Uri.parse("$endPoint/friendSplitApi/getFriendSplitTransactions"),
          body: {
            "token": value,
            "friendDebtId": widget.friend.id,
          });

      var res = jsonDecode(response.body) as Map<String, dynamic>;
      if (res['flag']) {
        var ResList = res['message'] as List<dynamic>;

        for (var tranJson in ResList) {
          var tran = tranJson;
          double amt = double.parse(tran['amount'].toString());
          DateTime tDate;
          tDate = DateFormat('d/M/yyyy').parse(tran['date'].toString());
          transactions.add(BillSplitTransaction(
              shareOfBorrower: double.parse(tran['otherUserShare'].toString()),
              shareOfPayer: double.parse(tran['paidByShare'].toString()),
              paidBy: tran['paidByUserName'],
              amount: amt,
              remark: tran['description'],
              friendDebtId: tran['friendDebtId'],
              transactionId: tran['_id'],
              transactionDate: tDate));
        }
        setState(() {});
      }
    } catch (e) {
      // print(e);
      print("Get All Friends transactions error: " + e.toString());
      if (!mounted) return;
      return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
        ctype: ContentType.failure,
        message: "$e. Please contact admin to resolve",
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.01;
    // double _height = MediaQuery.of(context).size.height * 0.01;

    // = [
    //   BillSplitTransaction(
    //     id: '1',
    //     shareOfPayer: 10.0,
    //     shareOfBorrower: 20.0,
    //     paidBy: 'Alice',
    //     amount: 30.0,
    //     transactionDate: DateTime.now(),
    //     remark: 'Lunch at the new restaurant',
    //   ),
    //   BillSplitTransaction(
    //     id: '2',
    //     shareOfPayer: 15.0,
    //     shareOfBorrower: 15.0,
    //     paidBy: 'Bob',
    //     amount: 30.0,
    //     transactionDate: DateTime.now(),
    //     remark: 'Movie tickets',
    //   ),
    //   BillSplitTransaction(
    //     id: '3',
    //     shareOfPayer: 5.0,
    //     shareOfBorrower: 25.0,
    //     paidBy: 'Alice',
    //     amount: 30.0,
    //     transactionDate: DateTime.now(),
    //     remark: 'Coffee and snacks',
    //   ),
    //   BillSplitTransaction(
    //     id: '4',
    //     shareOfPayer: 12.5,
    //     shareOfBorrower: 12.5,
    //     paidBy: 'Bob',
    //     amount: 25.0,
    //     transactionDate: DateTime.now(),
    //     remark: 'Dinner at the Italian restaurant',
    //   ),
    //   BillSplitTransaction(
    //     id: '5',
    //     shareOfPayer: 20.0,
    //     shareOfBorrower: 10.0,
    //     paidBy: 'Alice',
    //     amount: 30.0,
    //     transactionDate: DateTime.now(),
    //     remark: 'Drinks at the rooftop bar',
    //   ),
    //   BillSplitTransaction(
    //     id: '6',
    //     shareOfPayer: 7.0,
    //     shareOfBorrower: 23.0,
    //     paidBy: 'Bob',
    //     amount: 30.0,
    //     transactionDate: DateTime.now(),
    //     remark: 'Shopping at the mall',
    //   ),
    //   BillSplitTransaction(
    //     id: '7',
    //     shareOfPayer: 15.0,
    //     shareOfBorrower: 15.0,
    //     paidBy: 'Alice',
    //     amount: 30.0,
    //     transactionDate: DateTime.now(),
    //     remark: 'Concert tickets',
    //   ),
    //   BillSplitTransaction(
    //     id: '8',
    //     shareOfPayer: 10.0,
    //     shareOfBorrower: 20.0,
    //     paidBy: 'Bob',
    //     amount: 30.0,
    //     transactionDate: DateTime.now(),
    //     remark: 'Brunch at the cafe',
    //   ),
    //   BillSplitTransaction(
    //     id: '9',
    //     shareOfPayer: 18.0,
    //     shareOfBorrower: 12.0,
    //     paidBy: 'Alice',
    //     amount: 30.0,
    //     transactionDate: DateTime.now(),
    //     remark: 'Spa session',
    //   ),
    //   BillSplitTransaction(
    //     id: '10',
    //     shareOfPayer: 25.0,
    //     shareOfBorrower: 5.0,
    //     paidBy: 'Bob',
    //     amount: 30.0,
    //     transactionDate: DateTime.now(),
    //     remark: 'Skydiving experience',
    //   ),
    //   BillSplitTransaction(
    //     id: '11',
    //     shareOfPayer: 10.0,
    //     shareOfBorrower: 20.0,
    //     paidBy: 'Alice',
    //     amount: 30.0,
    //     transactionDate: DateTime.now(),
    //     remark: 'Visiting the art museum',
    //   ),
    //   BillSplitTransaction(
    //     id: '12',
    //     shareOfPayer: 22.0,
    //     shareOfBorrower: 8.0,
    //     paidBy: 'Bob',
    //     amount: 30.0,
    //     transactionDate: DateTime.now(),
    //     remark: 'Kuchbhi',
    //   )
    // ];

    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: Container(
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.width * 0.02,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(width * 10),
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
                            height: width * 50,
                            width: width * 100,
                            fit: BoxFit.cover,
                          ),
                          // Image.network(
                          // widget.cUser.backCoverImg
                          // 'https://www.google.com/url?sa=i&url=https%3A%2F%2Funsplash.com%2Fs%2Fphotos%2Fgreen-pattern&psig=AOvVaw3AJls4ZmJ5xErylYVzwYPx&ust=1682516876441000&source=images&cd=vfe&ved=0CBEQjRxqFwoTCPjhkfiVxf4CFQAAAAAdAAAAABAJ',
                          // height: width * 50,
                          // width: width * 100,
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
                  padding: EdgeInsets.only(left: width * 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.friend.friendName,
                        // textScaleFactor: 1.5,
                        textScaler: const TextScaler.linear(1.5),
                        style: const TextStyle(
                          color: white,
                        ),
                      ),
                      Text(
                        (widget.friend.totalBalance == 0)
                            ? 'All settled up'
                            : (widget.friend.totalBalance < 0)
                                ? 'You owe ${widget.friend.friendName} ${widget.friend.totalBalance.toStringAsFixed(2)}'
                                : '${widget.friend.friendName} owes you ${widget.friend.totalBalance.toStringAsFixed(2)}',
                        // textScaleFactor: 1.2,
                        textScaler: const TextScaler.linear(1.2),
                        style: TextStyle(
                          color:
                              (widget.friend.totalBalance >= 0) ? green : red,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: width * 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => NewBillSplitPage(
                                  friend: widget.friend,
                                )));
                      },
                      child: SizedBox(
                        height: width * 15,
                        width: width * 40,
                        child: GlassMorphism(
                          end: 0,
                          accent: green,
                          start: 0.25,
                          borderRadius: 20,
                          child: const Center(
                            child: Text(
                              "New Expense",
                              // textScaleFactor: 1.2,
                              textScaler: TextScaler.linear(1.2),
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
                          context: context,
                          builder: (_) => SettleUpWithFriend(
                                friend: widget.friend,
                              )),
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
                              "Settle Up",
                              // textScaleFactor: 1.2,
                              textScaler: TextScaler.linear(1.2),
                              style: TextStyle(color: white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: width * 5,
                ),
                if (transactions.isEmpty) ...{
                  const Text("No transaction done."),
                } else
                  for (var t in transactions) ...{
                    BillSplitTransactionBox(
                      transaction: t,
                      friend: widget.friend,
                    ),
                    SizedBox(
                      height: width * 5,
                    ),
                  }
              ],
            ),
          ),
        ),
      ),
    );
  }
}
