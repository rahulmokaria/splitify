import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:splitify/ui/screens/customer/expense_tracker/edit_transaction_popup.dart';

import '../models/transaction.dart';
import '../utils/colors.dart';
import 'glassmorphic_container.dart';

textMonth(num month) {
  switch (month) {
    case 1:
      return "January";
    case 2:
      return "February";
    case 3:
      return "March";
    case 4:
      return "April";
    case 5:
      return "May";
    case 6:
      return "June";
    case 7:
      return "July";
    case 8:
      return "August";
    case 9:
      return "September";
    case 10:
      return "October";
    case 11:
      return "November";
    case 12:
      return "December";
  }
}

class BillSplitTransactionBox extends StatelessWidget {
  String friendName;
  BillSplitTransaction transaction;
  BillSplitTransactionBox(
      {super.key, required this.transaction, required this.friendName});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 100;
    return SizedBox(
      height: width * 27,
      child: GlassMorphism(
        start: .25,
        end: 0,
        borderRadius: 20,
        child: Container(
          padding: EdgeInsets.all(width * 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(
              //   height: 10,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: width * 66,
                        child: Text(transaction.remark,
                            textScaleFactor: 1.2,
                            style: TextStyle(
                              color: white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      SizedBox(
                        height: width * 1,
                      ),
                      Text(
                          "${transaction.paidBy == friendName ? friendName : "You"} paid ${transaction.amount}",
                          textScaleFactor: 1,
                          style: TextStyle(
                            color: white.withOpacity(0.8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),

                      // Container(
                      //   padding: const EdgeInsets.all(5),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(5),
                      //     color: primary.withAlpha(70),
                      //   ),
                      //   child: Text(
                      //     "etgdrh",
                      //     // transaction.category,
                      //     textScaleFactor: 1.2,
                      //     style: const TextStyle(
                      //       color: white,
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            "${"${transaction.transactionDate.day} " + textMonth(transaction.transactionDate.month)} ${transaction.transactionDate.year}",
                            style: TextStyle(
                              color: white.withOpacity(0.8),
                            ),
                          ),
                          SizedBox(
                            width: width * 3,
                          ),
                          InkWell(
                            // onTap: () =>
                            // Navigator.of(context).push(MaterialPageRoute(
                            // builder: (_) => EditTransactionCard(
                            // transaction: transaction,
                            // ))),
                            child: Icon(
                              FontAwesomeIcons.pen,
                              color: white,
                              size: width * 4,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Flexible(flex: 1, child: Container()),
                  SizedBox(
                    width: width * 3,
                  ),
                  Container(
                    width: width * 20,
                    height: width * 20,
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(20),
                    //   shape: BoxShape.rectangle,
                    //   color: (transaction.paidBy == friendName) ? red : green,
                    // ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: width * 3,
                        ),
                        Text(
                          (transaction.paidBy != friendName)
                              ? "you lent"
                              : "you borrowed",
                          textScaleFactor: 0.8,
                          style: TextStyle(
                            color: (transaction.paidBy != friendName)
                                ? green
                                : red,
                          ),
                        ),
                        SizedBox(
                          height: width * 2,
                        ),
                        Text(
                          (transaction.paidBy != friendName)
                              ? transaction.friendShare.toString()
                              : transaction.userShare.toString(),
                          textScaleFactor: 1.2,
                          style: TextStyle(
                            color: (transaction.paidBy != friendName)
                                ? green
                                : red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
