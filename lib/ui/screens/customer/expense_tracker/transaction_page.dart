import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../models/transaction.dart';
import '../../../utils/colors.dart';
import '../../../widgets/transaction_details_box.dart';
import '../../../widgets/show_snackbar.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<UserTransaction> transactions = [];
  Widget buildTransaction(UserTransaction transaction) {
    return Column(
      children: [
        TransactionBox(transaction: transaction),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  getall() async {
    try {
      String endPoint = dotenv.env["URL"].toString();
      const storage = FlutterSecureStorage();
      String? value = await storage.read(key: "authtoken");
      var response = await http
          .post(Uri.parse("$endPoint/transactionApi/getTransactions"), body: {
        "token": value,
      });
      var res = jsonDecode(response.body) as Map<String, dynamic>;

      if (res['flag']) {
        var arrayOfRes = res['message'] as List<dynamic>;

        for (var tranJson in arrayOfRes) {
          var tran = tranJson;
          double amt = double.parse(tran['amount'].toString());

          DateTime tDate;

          tDate = DateFormat('d/M/yyyy').parse(tran['date'].toString());

          transactions.add(
            UserTransaction(
              amount: (tran['transactiontype'] == 'Income') ? amt : -1 * amt,
              remark: tran['description'],
              category: tran['category'],
              transactionId: tran['_id'],
              transactionDate: tDate,
            ),
          );
        }
        setState(() {});
        // print(transactions);
      } else {
        if (!mounted) return;
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
            message: res['message'], ctype: ContentType.failure));
      }
    } catch (e) {
      // print(e);
      // print("Get All transactions error: " + e.toString());
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

    getall();
  }

  @override
  Widget build(BuildContext context) {
    // transactions = [
    //   UserTransaction(
    //       amount: -100.0,
    //       remark:
    //           'Grocvfbg nhjm,k ytgr fghtyjukilkujhygeries Groceries Groceries ',
    //       transactionId: '',
    //       category: 'Rent',
    //       transactionDate: DateTime.now().subtract(Duration(days: 5))),
    //   UserTransaction(
    //       amount: -50.0,
    //       remark: 'Gas',
    //       transactionId: '',
    //       category: 'Loan',
    //       transactionDate: DateTime.now().subtract(Duration(days: 4))),
    //   UserTransaction(
    //       amount: 200.0,
    //       remark: 'Salary',
    //       transactionId: '',
    //       category: 'Loan',
    //       transactionDate: DateTime.now().subtract(Duration(days: 3))),
    //   UserTransaction(
    //       amount: -20.0,
    //       remark: 'Coffee',
    //       transactionId: '',
    //       category: 'Rent',
    //       transactionDate: DateTime.now().subtract(Duration(days: 2))),
    //   UserTransaction(
    //       amount: -150.0,
    //       remark: 'Utilities',
    //       transactionId: '',
    //       category: 'Rent',
    //       transactionDate: DateTime.now().subtract(Duration(days: 1))),
    //   UserTransaction(
    //       amount: 300.0,
    //       remark: 'Bonus',
    //       transactionId: '',
    //       category: 'Gift',
    //       transactionDate: DateTime.now()),
    //   UserTransaction(
    //       amount: -80,
    //       remark: 'Dinner',
    //       transactionId: '',
    //       category: 'Rent',
    //       transactionDate: DateTime.now()),
    //   UserTransaction(
    //       amount: -500.0,
    //       remark: 'Rent',
    //       transactionId: '',
    //       category: 'Rent',
    //       transactionDate: DateTime.now()),
    //   UserTransaction(
    //       amount: 1000.0,
    //       remark: 'Salary',
    //       transactionId: '',
    //       category: 'Loan',
    //       transactionDate: DateTime.now()),
    //   UserTransaction(
    //       amount: -25.0,
    //       remark: 'Parking',
    //       transactionId: '',
    //       category: 'Rent',
    //       transactionDate: DateTime.now()),
    // ];
    // print(transactions);
    // print(transactions.length);
    double width = MediaQuery.of(context).size.width * 0.01;
    // double _height = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      backgroundColor: secondary,
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(FontAwesomeIcons.arrowLeft)),
        // elevation: 0.0,
        title: const Text('Transactions'),
        backgroundColor: purple,
      ),
      body: (transactions.isEmpty)
          ? const Center(
              child: Text(
              "No Transactions made",
              // textScaleFactor: 1.5,
              textScaler: TextScaler.linear(1.5),
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
                    height: width * 5,
                  ),
                ]
              ],
            ),
    );
  }
}
