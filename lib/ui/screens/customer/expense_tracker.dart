import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../../utils/colors.dart';
import '../../widgets/glassmorphic_container.dart';
import '../../widgets/pie_chart.dart';
import 'new_expense.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../widgets/show_snackbar.dart';
class ExpenseTracker extends StatefulWidget {
  const ExpenseTracker({super.key});

  @override
  State<ExpenseTracker> createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  var _currentIndex = 0;
  String userName = 'User';
  double totBalance = 12230;
  double totExpense = 2000;
  double totIncome = 14230;
  String endPoint=dotenv.env["URL"].toString();
  final storage = new FlutterSecureStorage();
  
  @override
  userDetails() async{
    try {
      String? value = await storage.read(key: "authtoken");
      var response=await http.post(Uri.parse(endPoint+"/api/user/details"),
          body:{
            "token":value
          });
          var res=jsonDecode(response.body) as Map<String,dynamic>;
          print(res['message']['amount']);
          if(res['flag']){
            setState(() {
            userName=res['message']['name'];
            totBalance=res['message']['amount'].toDouble();
            totExpense=res['message']['expense'].toDouble();
            totIncome=res['message']['income'].toDouble();
            });
          }
          else{
            return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
              res['message'], "Please contact admin to resolve", pink, Icons.close));
          }
    } catch (e) {
      
      return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
              e.toString(), "Please contact admin to resolve", pink, Icons.close));
    }
  }
  @override
  void initState() {
    super.initState();
    userDetails();
  }
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: _width * 2, right: _width * 2),
            decoration: const BoxDecoration(
              color: secondary,
              // image: DecorationImage(
              //   image: AssetImage(
              //     'assets/signupbg1.png',
              //   ),
              //   fit: BoxFit.cover,
              // ),
              // color: secondary,
            ),
            child: Column(children: [
              // Flexible(
              //   flex: 1,
              //   child: Container(),
              // ),
              SizedBox(
                height: _width * 5,
              ),
              Container(
                padding: EdgeInsets.only(left: _width * 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hello, ' + userName,
                    style: TextStyle(color: white),
                    textScaleFactor: 1.5,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: _width * 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Here are your daily expenses",
                    style: TextStyle(color: white),
                    // textScaleFactor: 0.7,
                  ),
                ),
              ),
              // Flexible(
              //   flex: 1,
              //   child: Container(),
              // ),klj

              SizedBox(
                height: _width * 5,
              ),
              //atm card
              Container(
                height: _width * 50,
                width: _width * 80,
                child: GlassMorphism(
                  start: .25,
                  end: 0,
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
                                textScaleFactor: 1.2,
                                style: TextStyle(color: white.withOpacity(0.5)),
                              ),
                              Text(
                                totBalance.toString(),
                                textScaleFactor: 1.5,
                                style: TextStyle(color: white),
                              ),
                            ],
                          ),
                          Text(
                            '**** **** **** 5463',
                            textScaleFactor: 1.5,
                            style: TextStyle(color: white),
                          ),
                          Container(
                              width: _width * 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Flexible(flex: 1, child: Container()),
                                  Column(
                                    children: [
                                      Text(
                                        'Tot Inc',
                                        textScaleFactor: 0.9,
                                        style: TextStyle(
                                            color: white.withOpacity(0.5)),
                                      ),
                                      Text(
                                        totIncome.toString(),
                                        textScaleFactor: 1.2,
                                        style: TextStyle(color: white),
                                      )
                                    ],
                                  ),
                                  Flexible(flex: 1, child: Container()),
                                  Column(
                                    children: [
                                      Text(
                                        'Tot Exp',
                                        textScaleFactor: 0.9,
                                        style: TextStyle(
                                            color: white.withOpacity(0.5)),
                                      ),
                                      SizedBox(
                                        width: _width * 5,
                                      ),
                                      Text(
                                        totExpense.toString(),
                                        textScaleFactor: 1.2,
                                        style: TextStyle(color: white),
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
                        width: _width * 5,
                      ),
                      Container(
                        width: _width * 23,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          color: purple,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image(
                              image: AssetImage(
                                'assets/chip2.png',
                              ),
                              width: _width * 10,
                            ),
                            Image.asset(
                              'assets/chip3.png',
                              width: _width * 10,
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
                height: _width * 5,
              ),
              //new transactions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => CreateNewExpense(
                                  isExpense: false,
                                )));
                      },
                      child: Container(
                        height: _width * 15,
                        width: _width * 32,
                        child: GlassMorphism(
                          end: 0,
                          start: 0.25,
                          borderRadius: 20,
                          child: Center(
                            child: Text(
                              "New Income",
                              textScaleFactor: 1.2,
                              style: TextStyle(color: white),
                            ),
                          ),
                        ),
                      )),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => CreateNewExpense(
                                  isExpense: true,
                                )));
                      },
                      child: Container(
                        height: _width * 15,
                        width: _width * 32,
                        child: GlassMorphism(
                          end: 0,
                          start: 0.25,
                          borderRadius: 20,
                          child: Center(
                            child: Text(
                              "New Expense",
                              textScaleFactor: 1.2,
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
                height: _width * 5,
              ),
              //graph
              PieChart(
                showIndex: 0,
              ),
              // Flexible(
              //   flex: 1,
              //   child: Container(),
              // ),
              SizedBox(
                height: _width * 5,
              ),
              //all transactions
               Container(
                width: _width * 80,
                child: GlassMorphism(
                  borderRadius: 20,
                  end: 0,
                  start: 0.25,
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const TransactionPage())),
                    child: Column(
                      children: [
                        SizedBox(
                          height: _width * 3,
                        ),
                        Container(
                          height: _width * 10,
                          child: Center(
                              child: Text(
                            'Recent Transactions',
                            textScaleFactor: 1.2,
                            style: TextStyle(color: white),
                          )),
                        ),
                        SizedBox(
                          height: _width * 3,
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
                height: _width * 5,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
