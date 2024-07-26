import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:splitify/ui/screens/customer/group_splits/add_group_transaction.dart';
import 'package:splitify/ui/screens/customer/group_splits/group_bill_description_page.dart';
import 'package:splitify/ui/screens/customer/group_splits/group_splits.dart';
import 'package:http/http.dart' as http;

import '../../../models/transaction.dart';
import '../../../utils/colors.dart';
import '../../../utils/text_month.dart';
// import '../../../widgets/bill_split_transaction.dart';
import '../../../widgets/glassmorphic_container.dart';
import '../../../widgets/show_snackbar.dart';
// import '../split_bills/split_bills.dart';

class GroupDetails extends StatefulWidget {
  final String groupId;
  const GroupDetails({
    Key? key,
    required this.groupId,
  }) : super(key: key);

  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  // bool _isLoading = false;
  Group groupDetails = Group(
      groupId: "",
      groupName: "",
      borrowings: [],
      profilePicUrl: "https://picsum.photos/200",
      members: []);

  List<GroupTransaction> transactions = [];

  String userName = "";

  getGroupDetails() async {
    try {
      String endPoint = dotenv.env["URL"].toString();
      const storage = FlutterSecureStorage();
      String? value = await storage.read(key: "authtoken");
      var response = await http
          .post(Uri.parse("$endPoint/groupSplitApi/getGroupDetails"), body: {
        "token": value,
        "groupId": widget.groupId,
      });

      // print(response.body);

      var res = jsonDecode(response.body) as Map<String, dynamic>;
      // print(1);
      print(res);
      if (res['flag']) {
        // print(3);
        // var userId = res['userId'];
        // print(4);
        var resDetails = res['groupDetails'];
        userName = res["userName"];
        // print(5);

        // print(6);
        // double amt = double.parse(groupJson['amount'].toString());
        String grpName = resDetails['groupName'].toString();
        String grpId = resDetails['groupId'].toString();
        // print(8);
        // print(groupJson['members'].runtimeType);
        List<Member> grpMembers = [];
        for (var entry in resDetails['members']) {
          grpMembers.add(Member(
              userName: entry['userName'].toString(), userId: entry['userId']));
        }
        // print(7);
        List<Balances> balances = [];
        for (Map<String, dynamic> entry in resDetails['borrowings']) {
          balances.add(Balances(
              amount: entry['amount'],
              friendId: entry['friendId'],
              friendName: entry['friendName']));
        }
        // print(6);
        groupDetails.groupId = grpId;
        groupDetails.groupName = grpName;
        groupDetails.members = grpMembers;
        groupDetails.borrowings = balances;

        // groupDetails = tempGroup as Group;
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

  getGroupTransactions() async {
    try {
      String endPoint = dotenv.env["URL"].toString();
      const storage = FlutterSecureStorage();
      String? value = await storage.read(key: "authtoken");
      var response = await http.post(
          Uri.parse("$endPoint/GroupSplitApi/getGroupTransactions"),
          body: {
            "token": value,
            "groupId": widget.groupId,
          });

      var res = jsonDecode(response.body) as Map<String, dynamic>;
      if (res['flag']) {
        var ResList = res['transactions'] as List<dynamic>;

        for (var tranJson in ResList) {
          var tran = tranJson;
          double amt = double.parse(tran['amount'].toString());
          DateTime tDate;
          tDate = DateFormat('d/M/yyyy').parse(tran['date'].toString());
          transactions.add(
            GroupTransaction(
              paidByName: 'Alice',
              remark: 'Tarbuj',
              groupId: "group_1",
              transactionId: tranJson["transactionId"],
              participants: {
                "sgsdf": {"Alice": 20.0},
                "sgsddsfv": {"Bob": 15.0},
                "sgsdfsd": {"Charlie": 5.0},
              },
              // "Alice": 20.0, "Bob": 15.0, "Charlie": 5.0},
              totalAmount: 40.0,
              date: DateTime.now(),
              paidById: tranJson['paidById'],
            ),
          );
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
    getGroupDetails();
    getGroupTransactions();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.01;
    // double _height = MediaQuery.of(context).size.height * 0.01;
    // List<GroupTransaction> transactions = [
    //   GroupTransaction(
    //     paidBy: 'Alice',
    //     remark: 'Tarbuj',
    //     groupId: "group_1",
    //     participants: {"Alice": 20.0, "Bob": 15.0, "Charlie": 5.0},
    //     totalAmount: 40.0,
    //     date: DateTime.now(),
    //   ),
    //   GroupTransaction(
    //     paidBy: "Eve",
    //     date: DateTime.now(),
    //     remark: 'Tarbuj',
    //     groupId: "group_1",
    //     participants: {"David": 10.0, "Eve": 10.0},
    //     totalAmount: 20.0,
    //   ),
    //   GroupTransaction(
    //     paidBy: 'Grace',
    //     date: DateTime.now(),
    //     remark: 'Tarbuj',
    //     groupId: "group_1",
    //     participants: {"Alice": 25.0, "Grace": 15.0},
    //     totalAmount: 40.0,
    //   ),
    //   GroupTransaction(
    //     paidBy: 'Alice',
    //     date: DateTime.now(),
    //     remark: 'Tarbuj',
    //     groupId: "group_1",
    //     participants: {"Alice": 20.0, "Bob": 15.0, "Charlie": 5.0},
    //     totalAmount: 40.0,
    //   ),
    //   GroupTransaction(
    //     paidBy: "Eve",
    //     date: DateTime.now(),
    //     remark: 'Tarbuj',
    //     groupId: "group_1",
    //     participants: {"David": 10.0, "Eve": 10.0},
    //     totalAmount: 20.0,
    //   ),
    //   GroupTransaction(
    //     paidBy: 'Alice',
    //     date: DateTime.now(),
    //     remark: 'Tarbuj',
    //     groupId: "group_1",
    //     participants: {"Alice": 25.0, "Grace": 15.0},
    //     totalAmount: 40.0,
    //   ),
    //   GroupTransaction(
    //     paidBy: 'Alice',
    //     date: DateTime.now(),
    //     remark: 'Tarbuj',
    //     groupId: "group_1",
    //     participants: {"Alice": 20.0, "Bob": 15.0, "Charlie": 5.0},
    //     totalAmount: 40.0,
    //   ),
    //   GroupTransaction(
    //     paidBy: "Eve",
    //     date: DateTime.now(),
    //     remark: 'Tarbuj',
    //     groupId: "group_1",
    //     participants: {"David": 10.0, "Eve": 10.0},
    //     totalAmount: 20.0,
    //   ),
    //   GroupTransaction(
    //     paidBy: 'Grace',
    //     date: DateTime.now(),
    //     remark: 'Tarbuj',
    //     groupId: "group_1",
    //     participants: {"Alice": 25.0, "Grace": 15.0},
    //     totalAmount: 40.0,
    //   ),
    // ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width * 0.02,
          ),
          decoration: BoxDecoration(
            color: secondary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(width * 10),
              topRight:
                  Radius.circular(MediaQuery.of(context).size.width * 0.1),
            ),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
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
                            // 'assets/yellowbg.png',
                            'assets/orangebg.png',
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
                            MediaQuery.of(context).size.width * 0.125),
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
                            MediaQuery.of(context).size.width * 0.1),
                        child: Container(
                          color: secondary,
                          height: MediaQuery.of(context).size.width * 0.4,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Image.network(
                            groupDetails.profilePicUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: width * 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: width * 7),
                      child: Text(
                        groupDetails.groupName,
                        // textScaleFactor: 1.5,
                        textScaler: const TextScaler.linear(1.5),
                        style: TextStyle(
                          color: orange,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        // builder: (_) => NewBillSplitPage(
                        // friendName: widget.friend.name,
                        // )));
                      },
                      child: SizedBox(
                        height: width * 10,
                        width: width * 40,
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.plus,
                              color: orange.withOpacity(0.6),
                              size: width * 4,
                            ),
                            Center(
                              child: Text(
                                "Add Participant",
                                // textScaleFactor: 1.2,
                                textScaler: const TextScaler.linear(1.2),
                                style:
                                    TextStyle(color: orange.withOpacity(0.6)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: width * 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => AddGroupTransaction(
                                  groupDetails: groupDetails,
                                )));
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
                      // onTap: () => showDialog(
                      // context: context,
                      // builder: (_) => const ),
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
                if (transactions.isEmpty)
                  const Text(
                    "No transaction added.",
                    style: TextStyle(color: Colors.white),
                  )
                else
                  ...transactions.expand(
                    (t) => [
                      GroupTransactionBox(
                        transaction: t,
                        userName: userName,
                      ),
                      SizedBox(
                        height: width * 5,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GroupTransactionBox extends StatelessWidget {
  final GroupTransaction transaction;
  final String userName;
  const GroupTransactionBox({
    super.key,
    required this.transaction,
    required this.userName,
  });
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 100;
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => GroupBillDescription(transaction: transaction),
      )),
      child: SizedBox(
        // height: width * 27,
        child: GlassMorphism(
          start: .25,
          end: 0,
          accent: orange,
          borderRadius: 20,
          child: Container(
            padding: EdgeInsets.all(width * 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    //text
                    SizedBox(
                      width: width * 66,
                      child: Text(transaction.remark,
                          // textScaleFactor: 1.2,
                          textScaler: const TextScaler.linear(1.2),
                          style: const TextStyle(
                            color: white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                    SizedBox(
                      height: width * 1,
                    ),
                    //who paid how much
                    SizedBox(
                      width: width * 66,
                      child: Text(
                          "${transaction.paidByName == userName ? "You" : transaction.paidByName} paid ${transaction.totalAmount}",
                          // textScaleFactor: 1,
                          style: TextStyle(
                            color: white.withOpacity(0.8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),

                    //date
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: width * 66,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${transaction.date.day} ${textMonth(transaction.date.month)} ${transaction.date.year}",
                            style: TextStyle(
                              color: white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Column(
                //   children: [
                //     //you borrowed

                //     //amount
                //   ],
                // )
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: width * 3,
                    ),
                    Text(
                      (transaction.paidByName == userName)
                          ? "you lent"
                          : (transaction.participants.containsKey(userName))
                              ? "you borrowed"
                              : "not involved",
                      // textScaleFactor: 0.8,
                      textScaler: const TextScaler.linear(0.8),
                      style: TextStyle(
                        color: (transaction.paidByName == userName)
                            ? green
                            : (transaction.participants.containsKey(userName))
                                ? red
                                : white.withOpacity(0.5),
                      ),
                    ),
                    SizedBox(
                      height: width * 2,
                    ),
                    Text(
                      (transaction.participants[userName].toString() != "null")
                          ? transaction.participants[userName].toString()
                          : "",
                      // textScaleFactor: 1.2,
                      textScaler: const TextScaler.linear(1.2),
                      style: TextStyle(
                        color:
                            (transaction.paidByName == userName) ? green : red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
