import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:splitify/ui/screens/customer/group_splits/group_splits.dart';
import 'package:http/http.dart' as http;

import '../../../utils/colors.dart';
import '../../../utils/text_month.dart';
import '../../../widgets/show_snackbar.dart';
import '../../../widgets/text_field_ui.dart';
import '../home_page.dart';
// import '../split_bills/split_bills.dart';

class AddGroupTransaction extends StatefulWidget {
  final Group groupDetails;
  const AddGroupTransaction({super.key, required this.groupDetails});

  @override
  State<AddGroupTransaction> createState() => _AddGroupTransactionState();
}

class _AddGroupTransactionState extends State<AddGroupTransaction> {
  final TextEditingController _remarkTextController = TextEditingController();
  final TextEditingController _amountTextController = TextEditingController();
  // final TextEditingController _userShareTextController =
  //     TextEditingController();
  // final TextEditingController _friendShareTextController =
  //     TextEditingController();
  // final TextEditingController _userSharePercentTextController =
  //     TextEditingController();
  // final TextEditingController _friendSharePercentTextController =
  //     TextEditingController();

  Map<String, TextEditingController> _shareController = {};
  Map<String, TextEditingController> _percentController = {};

  DateTime date = DateTime.now();
  String paidBy = "";
  String splitOptionSelected = 'Split Equally';
  var splitOptions = [
    'Split Equally',
    'Split by amount',
    'Split by percentage'
  ];
  List<String> paidByOptions = [];
  @override
  void initState() {
    super.initState();
    //ADD CONDITION THAT IF USER THEN DONT ADD IT
    for (var participant in widget.groupDetails.members) {
      paidByOptions.add(participant.userName);
      _shareController[participant.userName] = TextEditingController();
      _percentController[participant.userName] = TextEditingController();
      // print(participant);
    }
    paidBy = paidByOptions[0];
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              primaryColor: secondary,
              splashColor: secondary,
              colorScheme: ColorScheme.light(
                primary: secondary,
                // background: secondary,
                secondary: secondary,
                onPrimary: orange,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                    // primary: orange,
                    backgroundColor: orange),
              ),
            ),
            child: child!,
          );
        });
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
        // print(date.runtimeType);
      });
    }
  }

  addNewGroupTransaction() async {
    try {
      String endPoint = dotenv.env["URL"].toString();
      const storage = FlutterSecureStorage();

      String? value = await storage.read(key: "authtoken");
      date = DateTime.parse(date.toString());
      var formattedDate = "${date.day}/${date.month}/${date.year}";

      Map<String, Map<String, double>> memberShares = {};

      double amt = double.parse(_amountTextController.text.toString());

      if (splitOptionSelected == 'Split equally') {
      } else if (splitOptionSelected == 'Split by amount') {
        double totalShare = 0;

        if (totalShare != amt) {
          throw "User's share and Friend's share does not total to Total amount.";
        }
      } else {
        double totalPercent = 0;

        // userShare = amt *
        //     (double.parse(_userSharePercentTextController.text.toString())) /
        //     100;
        // friendShare = amt *
        //     (double.parse(_friendSharePercentTextController.text.toString())) /
        //     100;

        if ((totalPercent - 100).abs() < 0.01) {
          throw "User's percent and Friend's percent does not total to 100%.";
        }
      }
      var response = await http.post(
          Uri.parse("$endPoint/GroupSplitApi/addNewGroupSplitTransaction"),
          body: {
            "token": value,
            "amount": amt.toString(),
            "paidByUser": paidBy,
            "date": formattedDate,
            "groupDebtId": widget.groupDetails.groupId,
            "memberShares": memberShares,
            "description": _remarkTextController.text,
          });
      var res = jsonDecode(response.body) as Map<String, dynamic>;
      if (res['flag']) {
        // setState(() {
        //   _isLoading = false;
        // });
        if (!mounted) return;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => HomePage(
                  currentIndex: 1,
                )));
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          ctype: ContentType.success,
          message: res['message'] + ". Keep Adding 😀😀",
        ));
      } else {
        // print("add transaction error: ${res['message']}");
        if (!mounted) return;
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          ctype: ContentType.failure,
          message: res['message'],
        ));
      }
    } catch (e) {
      // print("transaction error: $e");
      return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
        ctype: ContentType.failure,
        message: "$e  Please contact admin to resolve",
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.01;
    // double _height = MediaQuery.of(context).size.height * 0.01;

    return Scaffold(
        backgroundColor: secondary,
        appBar: AppBar(
          leading: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                FontAwesomeIcons.arrowLeft,
                color: secondary,
              )),
          // elevation: 0.0,
          title: const Text(
            'Add Expense',
            style: TextStyle(color: secondary),
          ),
          backgroundColor: orange,
        ),
        body: Container(
          padding: EdgeInsets.all(width * 2),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //split between
                const Text("Split between"),
                //description
                Container(
                  child: textFieldUi(
                      text: 'Description',
                      icon: FontAwesomeIcons.bars,
                      textColor: orange,
                      isPasswordType: false,
                      controller: _remarkTextController,
                      inputType: TextInputType.streetAddress),
                ),
                SizedBox(
                  height: width * 5,
                ),
                //amount
                Container(
                  // padding: EdgeInsets.only(left: width * 4, right: width * 4),
                  child: textFieldUi(
                      text: 'Amount',
                      icon: FontAwesomeIcons.wallet,
                      textColor: orange,
                      isPasswordType: false,
                      controller: _amountTextController,
                      inputType: TextInputType.number),
                ),
                SizedBox(
                  height: width * 5,
                ),
                //date
                Container(
                  decoration: BoxDecoration(
                    color: white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.fromLTRB(15, 20, 0, 20),
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.calendarDays,
                          color: orange,
                        ),
                        SizedBox(
                          width: width * 3,
                        ),
                        Text(
                          "Select Date:",
                          style: TextStyle(
                            color: orange,
                          ),
                          // textScaleFactor: 1.2,
                          textScaler: const TextScaler.linear(1.2),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          "${date.day} ${textMonth(date.month)} ${date.year}",
                          style: TextStyle(
                            color: orange,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: width * 5,
                ),
                //paid by options
                Container(
                  decoration: BoxDecoration(
                    color: white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.fromLTRB(width * 4, 5, width * 4, 5),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.ghost,
                        color: orange,
                      ),
                      SizedBox(
                        width: width * 3,
                      ),
                      Text(
                        "Paid By:",
                        style: TextStyle(
                          color: orange,
                        ),
                        // textScaleFactor: 1.2,
                        textScaler: const TextScaler.linear(1.2),
                      ),
                      SizedBox(
                        width: width * 10,
                      ),
                      DropdownButton(
                        value: paidBy,
                        underline: const SizedBox(),
                        dropdownColor: secondary,
                        items: paidByOptions
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              // textScaleFactor: 1.2,
                              textScaler: const TextScaler.linear(1.2),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          paidBy = newValue!;
                          setState(() {});
                        },
                        icon: const Icon(FontAwesomeIcons.chevronDown),
                        style: TextStyle(
                          color: orange,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: width * 5,
                ),
                //split options
                Container(
                  decoration: BoxDecoration(
                    color: white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.fromLTRB(width * 4, 5, width * 4, 5),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.tableColumns,
                        color: orange,
                      ),
                      SizedBox(
                        width: width * 3,
                      ),
                      Text(
                        "Split by:",
                        style: TextStyle(
                          color: orange,
                        ),
                        // textScaleFactor: 1.2,
                        textScaler: const TextScaler.linear(1.2),
                      ),
                      SizedBox(
                        width: width * 10,
                      ),
                      DropdownButton(
                        value: splitOptionSelected,
                        underline: const SizedBox(),
                        dropdownColor: secondary,
                        items: splitOptions
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              // textScaleFactor: 1.2,
                              textScaler: const TextScaler.linear(1.2),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          splitOptionSelected = newValue!;
                          setState(() {});
                        },
                        icon: const Icon(FontAwesomeIcons.chevronDown),
                        style: TextStyle(
                          color: orange,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: width * 5,
                ),
                //both ka share amount
                if (splitOptionSelected == 'Split by amount')
                  Container(
                    padding: EdgeInsets.all(width * 2),
                    decoration: BoxDecoration(
                        color: white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25)),
                    child: Column(
                      children: [
                        const Text(
                          'Split by amount',
                          // textScaleFactor: 1.5,
                          textScaler: TextScaler.linear(1.5),
                          style: TextStyle(color: white),
                        ),
                        ..._shareController.entries.map(
                          (entry) {
                            String key = entry.key;
                            TextEditingController _scontroller = entry.value;

                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width * 5,
                                        ),
                                        Text(
                                          "$key's share:",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: width * 30,
                                      child: TextField(
                                        controller: _scontroller,
                                        style: TextStyle(color: Colors.orange),
                                        cursorColor: Colors.orange,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          labelText: '0.00',
                                          labelStyle:
                                              TextStyle(color: Colors.orange),
                                          filled: true,
                                          fillColor: white.withOpacity(0.2),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.never,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: width * 2,
                                )
                              ],
                            );
                          },
                        ).toList(), // Con
                      ],
                    ),
                  ),

                if (splitOptionSelected == 'Split by percentage')
                  Container(
                    decoration: BoxDecoration(
                        color: white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: width * 2,
                        ),
                        const Text(
                          'Split by percentage',
                          // textScaleFactor: 1.5,
                          textScaler: TextScaler.linear(1.5),
                          style: TextStyle(color: white),
                        ),
                        ..._percentController.entries.map(
                          (entry) {
                            String key = entry.key;
                            TextEditingController _pcontroller = entry.value;
                            print(key);

                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width * 5,
                                        ),
                                        Text(
                                          "$key's percentage:",
                                          style: TextStyle(color: white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width * 20,
                                          child: TextField(
                                            controller: _pcontroller,
                                            style: TextStyle(color: orange),
                                            cursorColor: orange,
                                            keyboardType: TextInputType.phone,
                                            decoration: InputDecoration(
                                              // prefixIcon: Icon(
                                              //   ,
                                              //   color: textColor,
                                              // ),
                                              labelText: '0.00',
                                              fillColor: white.withOpacity(0.2),
                                              labelStyle:
                                                  TextStyle(color: orange),
                                              filled: true,
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.never,
                                              // fillColor: white.withOpacity(0.2),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    width: 0,
                                                    style: BorderStyle.none),
                                              ),
                                            ),
                                            // validator: (value) {
                                            //   if (value!.isEmpty) {
                                            //     print('empty');
                                            //     return "Field cannot be empty";
                                            //   } else {
                                            //     print('pappu pass');
                                            //     return null;
                                            //   }
                                            // },
                                          ),
                                        ),
                                        const Text(
                                          "%",
                                          // textScaleFactor: 1.3,
                                          textScaler: TextScaler.linear(1.2),
                                          style: TextStyle(color: white),
                                        ),
                                        SizedBox(
                                          width: width * 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: width * 2,
                                ),
                              ],
                            );
                          },
                        ).toList(), // Con
                      ],
                    ),
                  ),
                if (splitOptionSelected != 'Split Equally')
                  SizedBox(
                    height: width * 5,
                  ),

                //add it to transactions
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: width * 15,
                  // margin: EdgeInsets.only(left: width * 4, right: width * 4),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(90)),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.pressed)) {
                          return secondary;
                        }
                        return orange.withOpacity(0.8);
                      }),
                      //     MaterialStateProperty.resolveWith((states) {
                      //   if (states.contains(MaterialState.pressed)) {
                      //     return secondary;
                      //   }
                      //   return orange.withOpacity(0.8);
                      // }),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(width * 28))),
                    ),
                    child:
                        // _isLoading
                        //     ? const Center(
                        //         child: CircularProgressIndicator(
                        //           color: white,
                        //         ),
                        //       )
                        //     :
                        const Text(
                      "Add",
                      style: TextStyle(
                        color: secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
