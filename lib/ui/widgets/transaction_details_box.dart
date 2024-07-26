import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:splitify/ui/screens/customer/expense_tracker/edit_transaction_popup.dart';

import '../models/transaction.dart';
import '../utils/colors.dart';
import '../utils/text_month.dart';
import 'glassmorphic_container.dart';


class TransactionBox extends StatelessWidget {
  final UserTransaction transaction;
  const TransactionBox({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 100;
    return SizedBox(
      height: width * 42,
      child: GlassMorphism(
        start: .25,
        end: 0,
        borderRadius: 20,
        child: Container(
          padding: EdgeInsets.all(width * 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(transaction.remark,
                    // textScaleFactor: 1.75,
                    textScaler: const TextScaler.linear(1.75),
                    style: TextStyle(
                      color: purple,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),

              const Divider(
                color: white,
              ),
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
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: primary.withAlpha(70),
                        ),
                        child: Text(
                          transaction.category,
                          // textScaleFactor: 1.2,
                          textScaler: const TextScaler.linear(1.2),
                          style: const TextStyle(
                            color: white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${transaction.transactionDate.day} ${textMonth(transaction.transactionDate.month)} ${transaction.transactionDate.year}",
                        style: const TextStyle(
                          color: white,
                        ),
                      ),
                    ],
                  ),
                  Flexible(flex: 1, child: Container()),
                  Row(
                    children: [
                      InkWell(
                        onTap: () =>
                            // Navigator.of(context).push(
                            // MaterialPageRoute(
                            showDialog(
                                context: context,
                                builder: (_) => EditTransactionCard(
                                      transaction: transaction,
                                    )
                                // )
                                ),
                        child: const Icon(
                          FontAwesomeIcons.pen,
                          color: white,
                        ),
                      ),
                      // InkWell(
                      //   child: Icon(
                      //     Icons.delete,
                      //     color: white,
                      //   ),
                      // )
                    ],
                  ),
                  SizedBox(
                    width: width * 3,
                  ),
                  Container(
                    width: width * 20,
                    height: width * 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      shape: BoxShape.rectangle,
                      color: (transaction.amount >= 0) ? green : red,
                    ),
                    child: Center(
                      child: Text(
                        (transaction.amount >= 0)
                            ? "+${transaction.amount}"
                            : transaction.amount.toString(),
                        // textScaleFactor: 1.2,
                        textScaler: const TextScaler.linear(1.2),
                        style: const TextStyle(
                          color: white,
                        ),
                      ),
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
