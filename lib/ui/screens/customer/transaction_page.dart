import 'package:flutter/material.dart';

import '../../models/transaction.dart';
import '../../utils/colors.dart';
import '../../widgets/transaction_details_box.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  Widget buildTransaction(UserTransaction transaction) {
    return Column(
      children: [
        TransactionBox(transaction:transaction),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<UserTransaction> transactions = [
      UserTransaction(
          amount: -100.0,
          remark: 'Grocvfbg nhjm,k ytgr fghtyjukilkujhygeries Groceries Groceries ',
          balance: 1000.0,
          category: 'Rent',
          transactionDate: DateTime.now().subtract(const Duration(days: 5))),
      UserTransaction(
          amount: -50.0,
          remark: 'Gas',
          balance: 950.0,
          category: 'Loan',
          transactionDate: DateTime.now().subtract(const Duration(days: 4))),
      UserTransaction(
          amount: 200.0,
          remark: 'Salary',
          balance: 1150.0,
          category: 'Loan',
          transactionDate: DateTime.now().subtract(const Duration(days: 3))),
      UserTransaction(
          amount: -20.0,
          remark: 'Coffee',
          balance: 1130.0,
          category: 'Rent',
          transactionDate: DateTime.now().subtract(const Duration(days: 2))),
      UserTransaction(
          amount: -150.0,
          remark: 'Utilities',
          balance: 980.0,
          category: 'Rent',
          transactionDate: DateTime.now().subtract(const Duration(days: 1))),
      UserTransaction(
          amount: 300.0,
          remark: 'Bonus',
          balance: 1280.0,
          category: 'Gift',
          transactionDate: DateTime.now()),
      UserTransaction(
          amount: -80,
          remark: 'Dinner',
          balance: 1200.0,
          category: 'Rent',
          transactionDate: DateTime.now()),
      UserTransaction(
          amount: -500.0,
          remark: 'Rent',
          balance: 700.0,
          category: 'Rent',
          transactionDate: DateTime.now()),
      UserTransaction(
          amount: 1000.0,
          remark: 'Salary',
          balance: 1700.0,
          category: 'Loan',
          transactionDate: DateTime.now()),
      UserTransaction(
          amount: -25.0,
          remark: 'Parking',
          balance: 1675.0,
          category: 'Rent',
          transactionDate: DateTime.now()),
    ];

    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      backgroundColor: secondary,
      appBar: AppBar(
        // elevation: 0.0,
        title: const Text('Transactions'),
        backgroundColor: purple,
      ),
      body: (transactions.isEmpty)
          ? const Center(
              child: Text(
              "No Transactions made",
              textScaleFactor: 1.5,
              style: TextStyle(
                color: white,
              ),
            ))
          : ListView(
              padding: const EdgeInsets.all(30.0),
              children: [
                for (var data in transactions) ...[
                  TransactionBox(transaction: data),
                  SizedBox(
                    height: _width * 5,
                  ),
                ]
              ],
            ),
    );
  }
}
