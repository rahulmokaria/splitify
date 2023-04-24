import 'package:flutter/material.dart';

import '../../models/transaction.dart';
import '../../utils/colors.dart';
import '../../widgets/transaction_details_box.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../widgets/show_snackbar.dart';
import 'package:intl/intl.dart';

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
      final storage = new FlutterSecureStorage();
      String? value = await storage.read(key: "authtoken");
      var response = await http
          .post(Uri.parse(endPoint + "/api/user/gettransactions"), body: {
        "token": value,
      });
      var res = jsonDecode(response.body) as Map<String, dynamic>;
      if (res['flag']) {
        var length_of_array = res['message'].length;
        var array_of_res = res['message'];
        print(length_of_array);

        for (var i = 0; i < length_of_array; i++) {
          var tranJson = res['message'][i];
          var tran = tranJson;
          double amt = tran['amount'];
          String remark = tran['description'];
          String category = tran['category'];
        
          print(amt);
          print(remark);
          print(category);
          transactions.add(UserTransaction(
            amount: (tran['transactiontype']=='Income')?tran['amount']:-tran['amount'],
            remark: tran['description'],
            category: tran['category'],
            transactionId: tran['_id'],
            transactionDate: DateFormat('d/m/y').parse(tran['date']),
          ));

        }
        setState(() {
          
        });
        print(transactions);
      } else {
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
            "Please contact admin to resolve",
            res['message'],
            pink,
            Icons.close));
      }
    } catch (e) {
      return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          "Please contact admin to resolve", e.toString(), pink, Icons.close));
    }
  }
   
   
     @override
  void initState() {
    // TODO: implement initState

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
  print(transactions);
  print(transactions.length);
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
