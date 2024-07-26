import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../utils/colors.dart';
import '../../../widgets/glassmorphic_container.dart';
import '../../../widgets/pie_chart.dart';
import '../../../widgets/show_snackbar.dart';
import 'new_expense.dart';
import 'transaction_page.dart';

class ExpenseTracker extends StatefulWidget {
  const ExpenseTracker({super.key});

  @override
  State<ExpenseTracker> createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  // var _currentIndex = 0;
  String userName = 'User';
  double totBalance = 12230;
  double totExpense = 2000;
  double totIncome = 14230;
  String endPoint = dotenv.env["URL"].toString();
  final storage = const FlutterSecureStorage();

  // @override
  userDetails() async {
    try {
      String? value = await storage.read(key: "authtoken");

      // print("trying to get userdata");
      // print("token= "+value.toString());
      var response = await http.post(Uri.parse("$endPoint/userApi/userDetails"),
          body: {"token": value});
      var res = jsonDecode(response.body) as Map<String, dynamic>;
      // print(response.body);
      if (res['flag']) {
        setState(() {
          userName = res['message']['name'];
          totBalance = double.parse(res['message']['amount'].toString());
          totExpense = double.parse(res['message']['expense'].toString());
          totIncome = double.parse(res['message']['income'].toString());
        });
        setState(() {});
      } else {
        if (!mounted) return;
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          ctype: ContentType.failure,
          message: res['message'] + ". Please contact admin to resolve.",
        ));
      }
    } catch (e) {
      // print("User details error: "+e.toString());
      if (!mounted) return;
      return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
        ctype: ContentType.failure,
        message: "${e}Please contact admin to resolve",
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    userDetails();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.01;
    // double _height = MediaQuery.of(context).size.height * 0.01;
    // userDetails();
    // return SafeArea(
    // child: Scaffold(
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(child: const Icon(FontAwesomeIcons.house)),
        title: Text("Splitify"),
        backgroundColor: purple,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: secondary,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),

            // decoration: const BoxDecoration(
            //   color: secondary,
            //   // image: DecorationImage(
            //   //   image: AssetImage(
            //   //     'assets/signupbg1.png',
            //   //   ),
            //   //   fit: BoxFit.cover,
            //   // ),
            //   // color: secondary,
            // ),
            child: Padding(
              // padding: const EdgeInsets.all(8.0),
              padding: EdgeInsets.only(left: width * 2, right: width * 2),
              child: Column(children: [
                // Flexible(
                //   flex: 1,
                //   child: Container(),
                // ),
                SizedBox(
                  height: width * 5,
                ),
                Container(
                  padding: EdgeInsets.only(left: width * 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Hello, $userName',
                      style: TextStyle(color: purple),
                      // textScaleFactor: 1.5,
                      textScaler: const TextScaler.linear(1.5),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: width * 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Here are your daily expenses",
                      style: TextStyle(color: purple),
                      // textScaleFactor: 0.7,
                    ),
                  ),
                ),
                // Flexible(
                //   flex: 1,
                //   child: Container(),
                // ),klj

                SizedBox(
                  height: width * 5,
                ),
                //atm card
                SizedBox(
                  height: width * 50,
                  width: width * 80,
                  child: GlassMorphism(
                    start: .25,
                    end: 0,
                    accent: purple,
                    borderRadius: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Your Balance",
                                  // textScaleFactor: 1.2,
                                  textScaler: const TextScaler.linear(1.2),
                                  style:
                                      TextStyle(color: white.withOpacity(0.5)),
                                ),
                                Text(
                                  totBalance.toString(),
                                  // textScaleFactor: 1.5,
                                  textScaler: const TextScaler.linear(1.5),
                                  style: const TextStyle(color: white),
                                ),
                              ],
                            ),
                            const Text(
                              '**** **** **** 5463',
                              // textScaleFactor: 1.5,
                              textScaler: TextScaler.linear(1.5),
                              style: TextStyle(color: white),
                            ),
                            SizedBox(
                              width: width * 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Flexible(flex: 1, child: Container()),
                                  Column(
                                    children: [
                                      Text(
                                        'Tot Inc',
                                        // textScaleFactor: 0.9,
                                        textScaler:
                                            const TextScaler.linear(1.5),
                                        style: TextStyle(
                                            color: white.withOpacity(0.5)),
                                      ),
                                      Text(
                                        totIncome.toString(),
                                        // textScaleFactor: 1.2,
                                        textScaler:
                                            const TextScaler.linear(1.2),
                                        style: const TextStyle(color: white),
                                      )
                                    ],
                                  ),
                                  Flexible(flex: 1, child: Container()),
                                  Column(
                                    children: [
                                      Text(
                                        'Tot Exp',
                                        // textScaleFactor: 0.9,
                                        textScaler:
                                            const TextScaler.linear(0.9),
                                        style: TextStyle(
                                            color: white.withOpacity(0.5)),
                                      ),
                                      SizedBox(
                                        width: width * 5,
                                      ),
                                      Text(
                                        totExpense.toString(),
                                        // textScaleFactor: 1.2,
                                        textScaler:
                                            const TextScaler.linear(1.2),
                                        style: const TextStyle(color: white),
                                      )
                                    ],
                                  ),
                                  // Flexible(flex: 1, child: Container()),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: width * 5,
                        ),
                        Container(
                          width: width * 23,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            color: purple,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(
                                FontAwesomeIcons.ccAmazonPay,
                                color: white,
                              ),
                              // Image(
                              //   image: AssetImage(
                              //     'assets/chip2.png',
                              //   ),
                              //   width: width * 10,
                              // ),
                              Image.asset(
                                'assets/chip3.png',
                                width: width * 10,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // Flexible(
                //   flex: 1,
                //   child: Container(),
                // ),
                SizedBox(
                  height: width * 5,
                ),
                //new transactions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const CreateNewExpense(
                                    isExpense: false,
                                  )));
                        },
                        child: SizedBox(
                          height: width * 15,
                          width: width * 32,
                          child: GlassMorphism(
                            end: 0,
                            start: 0.25,
                            accent: purple,
                            borderRadius: 20,
                            child: const Center(
                              child: Text(
                                "New Income",
                                // textScaleFactor: 1.2,
                                textScaler: TextScaler.linear(1.2),
                                style: TextStyle(color: white),
                              ),
                            ),
                          ),
                        )),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const CreateNewExpense(
                                    isExpense: true,
                                  )));
                        },
                        child: SizedBox(
                          height: width * 15,
                          width: width * 32,
                          child: GlassMorphism(
                            end: 0,
                            start: 0.25,
                            accent: purple,
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
                        )),
                  ],
                ),
                // Flexible(
                //   flex: 1,
                //   child: Container(),
                // ),
                SizedBox(
                  height: width * 5,
                ),
                //graph
                PieChart(
                  totalExpense: totExpense,
                ),
                // Flexible(
                //   flex: 1,
                //   child: Container(),
                // ),
                SizedBox(
                  height: width * 5,
                ),
                //all transactions
                SizedBox(
                  width: width * 80,
                  child: GlassMorphism(
                    borderRadius: 20,
                    end: 0,
                    accent: purple,
                    start: 0.25,
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const TransactionPage())),
                      child: Column(
                        children: [
                          SizedBox(
                            height: width * 3,
                          ),
                          SizedBox(
                            height: width * 10,
                            child: const Center(
                                child: Text(
                              'Recent Transactions',
                              // textScaleFactor: 1.2,
                              textScaler: TextScaler.linear(1.2),
                              style: TextStyle(color: white),
                            )),
                          ),
                          SizedBox(
                            height: width * 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Flexible(
                //   flex: 1,
                //   child: Container(),
                // ),
                SizedBox(
                  height: width * 5,
                ),
              ]),
            ),
          ),
        ),
      ),
      // ),
    );
  }
}
