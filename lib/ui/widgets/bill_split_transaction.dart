import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:splitify/ui/screens/customer/expense_tracker/edit_transaction_popup.dart';

import '../models/friend.dart';
import '../models/transaction.dart';
import '../screens/customer/split_bills/edit_bill_split_page.dart';
import '../utils/colors.dart';
import '../utils/text_month.dart';
import 'glassmorphic_container.dart';

class BillSplitTransactionBox extends StatelessWidget {
  final Friend friend;
  final BillSplitTransaction transaction;
  const BillSplitTransactionBox(
      {super.key, required this.transaction, required this.friend});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 100;
    return SizedBox(
      height: width * 27,
      child: GlassMorphism(
        start: .25,
        end: 0,
        accent: green,
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
                      Text(
                          "${transaction.paidBy == friend.friendName ? friend.friendName : "You"} paid ${transaction.amount}",
                          // textScaleFactor: 1,
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
                            "${transaction.transactionDate.day} ${textMonth(transaction.transactionDate.month)} ${transaction.transactionDate.year}",
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
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => EditBillSplitPage(
                                  friend: friend,
                                  billSplitTransaction: transaction,
                                ),
                              ),
                            ),
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
                  SizedBox(
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
                          (transaction.paidBy != friend.friendName)
                              ? "you lent"
                              : "you borrowed",
                          // textScaleFactor: 0.8,
                          textScaler: const TextScaler.linear(0.8),
                          style: TextStyle(
                            color: (transaction.paidBy != friend.friendName)
                                ? green
                                : red,
                          ),
                        ),
                        SizedBox(
                          height: width * 2,
                        ),
                        Text(
                          transaction.shareOfBorrower.toString(),
                          // textScaleFactor: 1.2,
                          textScaler: const TextScaler.linear(1.2),
                          style: TextStyle(
                            color: (transaction.paidBy != friend.friendName)
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
