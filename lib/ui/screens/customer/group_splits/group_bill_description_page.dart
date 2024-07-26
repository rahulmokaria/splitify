import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../models/transaction.dart';
import '../../../utils/colors.dart';
import '../../../utils/text_month.dart';
// import '../../../widgets/bill_split_transaction.dart';

class GroupBillDescription extends StatelessWidget {
  final GroupTransaction transaction;
  const GroupBillDescription({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 100;
    // return SafeArea(
    // child: Scaffold(
    return Scaffold(
      backgroundColor: secondary,
      appBar: AppBar(
        backgroundColor: orange,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            FontAwesomeIcons.arrowLeft,
            color: white,
          ),
        ),
        title: const Text("Transaction Details"),
        actions: [
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              FontAwesomeIcons.pen,
              color: white,
              size: width * 5,
            ),
          ),
          SizedBox(
            width: width * 2,
          ),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              FontAwesomeIcons.trash,
              color: white,
              size: width * 5,
            ),
          ),
          SizedBox(
            width: width * 2,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(width * 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.indianRupeeSign,
                    color: orange,
                    size: width * 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //remark
                      Text(
                        transaction.remark,
                        // textScaleFactor: 2,
                        textScaler: const TextScaler.linear(2),
                        style: const TextStyle(color: white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      //amount
                      Text(
                        "${transaction.totalAmount}",
                        // textScaleFactor: 3,
                        textScaler: const TextScaler.linear(3),
                        style: const TextStyle(color: white),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: width * 3,
              ),
              Text(
                "${transaction.paidByName} paid ₹ ${transaction.totalAmount}",
                // textScaleFactor: 1.2,
                textScaler: const TextScaler.linear(1.2),
                style: const TextStyle(color: white),
              ),
              SizedBox(
                height: width * 5,
              ),
              for (var i = 0;
                  i < transaction.participants.entries.length;
                  i++) ...{
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: width * 1),
                      height: width * 8,
                      width: 1,
                      color: Colors.grey,
                    ),
                    Container(
                      width: width * 5,
                      height: 1,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: width * 2,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: width * 1,
                        ),
                        Text(
                          "${transaction.participants.entries.elementAt(i).key} owes ${transaction.paidByName} ₹${transaction.participants.entries.elementAt(i).value}",
                          style: const TextStyle(color: white),
                        ),
                        SizedBox(
                          height: width * 1,
                        ),
                      ],
                    )
                  ],
                ),
              },
              //date
              Text(
                "Occurred on ${transaction.date.day} ${textMonth(transaction.date.month)} ${transaction.date.year}",
                style: TextStyle(
                  color: white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
