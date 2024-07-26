import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../models/friend.dart';
import '../../../utils/colors.dart';
import '../../../widgets/show_snackbar.dart';
import '../home_page.dart';

class SettleUpWithFriend extends StatefulWidget {
  final Friend friend;

  const SettleUpWithFriend({super.key, required this.friend});

  @override
  State<SettleUpWithFriend> createState() => _SettleUpWithFriendState();
}

class _SettleUpWithFriendState extends State<SettleUpWithFriend> {
  DateTime date = DateTime.now();
  // String paidBy = 'You';

  var paidByOptions = ['You'];
  @override
  void initState() {
    super.initState();
    // paidByOptions.add(widget.friend.name);
  }

  friendSettleUpTransaction() async {
    try {
      String endPoint = dotenv.env["URL"].toString();
      const storage = FlutterSecureStorage();

      String? value = await storage.read(key: "authtoken");
      date = DateTime.parse(date.toString());
      var formattedDate = "${date.day}/${date.month}/${date.year}";
      String paidByUser =
          (widget.friend.totalBalance < 0 ? "You" : widget.friend.friendName);
      String userShare = (widget.friend.totalBalance < 0)
          ? '0'
          : widget.friend.totalBalance.abs().toString();
      String friendShare = widget.friend.totalBalance < 0
          ? widget.friend.totalBalance.abs().toString()
          : '0';
      var response = await http.post(
          Uri.parse("$endPoint/friendSplitApi/addNewFriendSplitTransaction"),
          body: {
            "token": value,
            "amount": widget.friend.totalBalance.abs().toString(),
            "paidByUser": paidByUser,
            "userShare": userShare,
            "friendShare": friendShare,
            "date": formattedDate,
            "friendDebtId": widget.friend.id,
            "description": "Settle Up",
          });
      var res = jsonDecode(response.body) as Map<String, dynamic>;
      if (res['flag']) {
        if (!mounted) return;
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => HomePage(
                  currentIndex: 1,
                )));
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          ctype: ContentType.success,
          message: res['message'] + ". Keep Adding 😀😀",
        ));
      } else {
        print("add transaction error: ${res['message']}");
        if (!mounted) return;
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          ctype: ContentType.failure,
          message: res['message'],
        ));
      }
    } catch (e) {
      print("transaction error: $e");
      return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
        ctype: ContentType.failure,
        message: "$e  Please contact admin to resolve",
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    double width = MediaQuery.of(context).size.width * 0.01;
    // double height = MediaQuery.of(context).size.height * 0.01;
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(width * 5),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: secondary,
            border: Border.all(width: 1, color: green),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Record a payment',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: green,
                ),
              ),
              SizedBox(height: width * 5),
              Text(
                'Record a payment between you and ${widget.friend.friendName} of amount ${widget.friend.totalBalance.abs().toStringAsFixed(2)}',
                style: const TextStyle(color: white),
              ),
              SizedBox(height: width * 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      // primary: white.withOpacity(0.2),
                      // onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: width * 2.5),
                  ElevatedButton(
                    onPressed: friendSettleUpTransaction,
                    // implement edit transaction functionality
                    // ed/itdata();
                    // Navigator.of(context).popUntil(( context, MaterialPageRout));
                    // if(Navigator.canPop(context)) {
                    //   // Navigator.canPop return true if can pop
                    //   Navigator.pop(context);
                    // }
                    // Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=>TransactionPage()));

                    style: ElevatedButton.styleFrom(
                      backgroundColor: white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      // primary: white.withOpacity(0.2),
                      // onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Confirm'),
                  ),
                  SizedBox(width: width * 2.5),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
