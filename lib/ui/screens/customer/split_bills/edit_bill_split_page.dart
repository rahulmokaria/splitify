import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../models/friend.dart';
import '../../../models/transaction.dart';
import '../../../utils/colors.dart';
import '../../../utils/text_month.dart';
import '../../../widgets/show_snackbar.dart';
import '../../../widgets/text_field_ui.dart';

class EditBillSplitPage extends StatefulWidget {
  const EditBillSplitPage(
      {Key? key, required this.billSplitTransaction, required this.friend})
      : super(key: key);
  final Friend friend;
  final BillSplitTransaction billSplitTransaction;
  @override
  State<EditBillSplitPage> createState() => _EditBillSplitPageState();
}

class _EditBillSplitPageState extends State<EditBillSplitPage> {
  final TextEditingController _remarkTextController = TextEditingController();
  final TextEditingController _amountTextController = TextEditingController();
  final TextEditingController _userShareTextController =
      TextEditingController();
  final TextEditingController _friendShareTextController =
      TextEditingController();
  final TextEditingController _userSharePercentTextController =
      TextEditingController();
  final TextEditingController _friendSharePercentTextController =
      TextEditingController();
  DateTime date = DateTime.now();
  String paidBy = 'You';
  String splitOptionSelected = 'Split Equally';
  var splitOptions = [
    'Split Equally',
    'Split by amount',
    'Split by percentage'
  ];
  var paidByOptions = ['You'];

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
                primary: secondary, // <-- SEE HERE
                // background: secondary,
                secondary: secondary,
                onPrimary: green, // <-- SEE HERE
                onSurface: white.withOpacity(0.6), // <-- SEE HERE
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  // primary: green, // button text color
                  backgroundColor: green,
                ),
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

  editTransaction() async {
    print(1);
    String endPoint = dotenv.env["URL"].toString();
    const storage = FlutterSecureStorage();
    try {
      print(2);
      String? value = await storage.read(key: "authtoken");
      // var date = widget.transaction.transactionDate;
      print(3);
      date = DateTime.parse(date.toString());
      var formattedDate = "${date.day}/${date.month}/${date.year}";
      print(4);
      double userShare = 0;
      double friendShare = 0;

      double amt = double.parse(_amountTextController.text.toString());
      print(5);
      if (splitOptionSelected == 'Split equally') {
        userShare = double.parse(_amountTextController.text.toString()) / 2;
        friendShare = userShare;
      } else if (splitOptionSelected == 'Split by amount') {
        userShare = double.parse(_userShareTextController.text.toString());
        friendShare = double.parse(_friendShareTextController.text.toString());
        if (userShare + friendShare != amt) {
          throw "User's share and Friend's share does not total to Total amount.";
        }
      } else {
        userShare = amt *
            (double.parse(_userSharePercentTextController.text.toString())) /
            100;
        friendShare = amt *
            (double.parse(_friendSharePercentTextController.text.toString())) /
            100;
        if (userShare + friendShare != amt) {
          throw "User's percent and Friend's percent does not total to 100%.";
        }
      }
      print(6);
      print(
        widget.billSplitTransaction.transactionId,
      );
      print(
        amt.toString(),
      );
      print(
        paidBy,
      );
      print(
        userShare.toString(),
      );
      print(
        friendShare.toString(),
      );
      print(
        formattedDate,
      );
      print(
        widget.friend.id,
      );
      print(
        _remarkTextController.text,
      );
      var response = await http.post(
          Uri.parse("$endPoint/friendSplitApi/editFriendSplitTransaction"),
          body: {
            "token": value,
            "id": widget.billSplitTransaction.transactionId,
            "amount": amt.toString(),
            "paidByUser": paidBy,
            "userShare": userShare.toString(),
            "friendShare": friendShare.toString(),
            "date": formattedDate,
            "friendDebtId": widget.friend.id,
            "description": _remarkTextController.text,
          });
      var res = jsonDecode(response.body) as Map<String, dynamic>;
      if (res['flag']) {
        if (!mounted) return;
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          ctype: ContentType.success,
          message: res['message'] + "Keep Enjoying",
        ));
      } else {
        print(res['message']);
        if (!mounted) return;
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          ctype: ContentType.failure,
          message: res['message'] + "Please contact admin to resolve",
        ));
      }
    } catch (e) {
      print("Edit transaction error: " + e.toString());
      return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
        ctype: ContentType.failure,
        message: "${e}Please contact admin to resolve",
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    paidByOptions.add(widget.friend.friendName);
    _remarkTextController.text = widget.billSplitTransaction.remark;
    _amountTextController.text = widget.billSplitTransaction.amount.toString();
    paidBy = (widget.billSplitTransaction.paidBy == widget.friend.friendName)
        ? widget.friend.friendName
        : "You";
    if (widget.billSplitTransaction.shareOfPayer !=
        widget.billSplitTransaction.shareOfBorrower) {
      splitOptionSelected = 'Split by amount';
      if (paidBy == widget.friend.friendName) {
        _friendShareTextController.text =
            widget.billSplitTransaction.shareOfPayer.toString();
        _userShareTextController.text =
            widget.billSplitTransaction.shareOfBorrower.toString();
        _friendSharePercentTextController.text =
            (widget.billSplitTransaction.shareOfPayer /
                    widget.billSplitTransaction.amount *
                    100)
                .toStringAsFixed(2);
        _userSharePercentTextController.text =
            (widget.billSplitTransaction.shareOfBorrower /
                    widget.billSplitTransaction.amount *
                    100)
                .toStringAsFixed(2);
      } else {
        _userShareTextController.text =
            widget.billSplitTransaction.shareOfPayer.toString();
        _friendShareTextController.text =
            widget.billSplitTransaction.shareOfBorrower.toString();
        _userSharePercentTextController.text =
            (widget.billSplitTransaction.shareOfPayer /
                    widget.billSplitTransaction.amount *
                    100)
                .toString();
        _friendSharePercentTextController.text =
            (widget.billSplitTransaction.shareOfBorrower /
                    widget.billSplitTransaction.amount *
                    100)
                .toString();
      }
    } else {
      _friendShareTextController.text =
          widget.billSplitTransaction.shareOfPayer.toString();
      _userShareTextController.text =
          widget.billSplitTransaction.shareOfBorrower.toString();
      _friendSharePercentTextController.text = "50";
      _userSharePercentTextController.text = "50";
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.01;

    return Scaffold(
        backgroundColor: secondary,
        appBar: AppBar(
          leading: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(FontAwesomeIcons.arrowLeft)),
          // elevation: 0.0,
          title: const Text('Edit Expense'),
          backgroundColor: green,
        ),
        body: Container(
          padding: EdgeInsets.all(width * 2),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //split between
                // const Text("Split between"),
                //description
                SizedBox(
                  height: width * 3,
                ),
                Container(
                  child: textFieldUi(
                      text: 'Description',
                      icon: FontAwesomeIcons.bars,
                      textColor: green,
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
                      textColor: green,
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
                          color: green,
                        ),
                        SizedBox(
                          width: width * 3,
                        ),
                        Text(
                          "Select Date:",
                          style: TextStyle(
                            color: green,
                          ),
                          // textScaleFactor: 1.2,
                          textScaler: const TextScaler.linear(1.2),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          "${date.day.toString()} ${textMonth(date.month)} ${date.year}",
                          style: TextStyle(
                            color: green,
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
                        color: green,
                      ),
                      SizedBox(
                        width: width * 3,
                      ),
                      Text(
                        "Paid By:",
                        style: TextStyle(
                          color: green,
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
                          color: green,
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
                        color: green,
                      ),
                      SizedBox(
                        width: width * 3,
                      ),
                      Text(
                        "Split by:",
                        style: TextStyle(
                          color: green,
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
                          color: green,
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
                        // SizedBox(
                        //   height: width * 5,
                        // ),
                        const Text(
                          'Split by amount',
                          // textScaleFactor: 1.5,
                          textScaler: TextScaler.linear(1.5),
                          style: TextStyle(color: white),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: width * 5,
                                ),
                                const Text(
                                  "Your share:",
                                  style: TextStyle(color: white),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: width * 30,
                              child: TextField(
                                controller: _userShareTextController,
                                style: TextStyle(color: green),
                                cursorColor: green,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  // prefixIcon: Icon(
                                  //   ,
                                  //   color: textColor,
                                  // ),
                                  labelText: '0.00',
                                  labelStyle: TextStyle(color: green),
                                  filled: true,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  fillColor: white.withOpacity(0.2),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        width: 0, style: BorderStyle.none),
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
                          ],
                        ),
                        SizedBox(
                          height: width * 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: width * 5,
                                ),
                                const Text(
                                  "Friend's share:",
                                  style: TextStyle(color: white),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: width * 30,
                              child: TextField(
                                controller: _friendShareTextController,
                                style: TextStyle(color: green),
                                cursorColor: green,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  // prefixIcon: Icon(
                                  //   ,
                                  //   color: textColor,
                                  // ),
                                  labelText: '0.00',
                                  labelStyle: TextStyle(color: green),
                                  filled: true,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  fillColor: white.withOpacity(0.2),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        width: 0, style: BorderStyle.none),
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
                          ],
                        ),
                      ],
                    ),
                  ),

                if (splitOptionSelected == 'Split by percentage')
                  Container(
                    padding: EdgeInsets.all(width * 2),
                    decoration: BoxDecoration(
                        color: white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25)),
                    child: Column(
                      children: [
                        // SizedBox(
                        //   height: width * 5,
                        // ),
                        const Text(
                          'Split by percentage',
                          // textScaleFactor: 1.5,
                          textScaler: TextScaler.linear(1.5),
                          style: TextStyle(color: white),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: width * 5,
                                ),
                                const Text(
                                  "User's percentage:",
                                  style: TextStyle(color: white),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: width * 30,
                                  child: TextField(
                                    controller: _userSharePercentTextController,
                                    style: TextStyle(color: green),
                                    cursorColor: green,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      // prefixIcon: Icon(
                                      //   ,
                                      //   color: textColor,
                                      // ),
                                      labelText: '0.00',
                                      labelStyle: TextStyle(color: green),
                                      filled: true,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      fillColor: white.withOpacity(0.2),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: const BorderSide(
                                            width: 0, style: BorderStyle.none),
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
                                // Text(
                                //   "%",
                                //   textScaleFactor: 1.3,
                                //   style: TextStyle(color: white),
                                // ),
                                // SizedBox(
                                //   width: width * 5,
                                // ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: width * 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: width * 5,
                                ),
                                const Text(
                                  "Friend's percentage:",
                                  style: TextStyle(color: white),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: width * 30,
                                  child: TextField(
                                    controller:
                                        _friendSharePercentTextController,
                                    style: TextStyle(color: green),
                                    cursorColor: green,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      // prefixIcon: Icon(
                                      //   ,
                                      //   color: textColor,
                                      // ),
                                      labelText: '0.00',
                                      labelStyle: TextStyle(color: green),
                                      filled: true,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      fillColor: white.withOpacity(0.2),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: const BorderSide(
                                            width: 0, style: BorderStyle.none),
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
                                // Text(
                                //   "%",
                                //   textScaleFactor: 1.3,
                                //   style: TextStyle(color: white),
                                // ),
                                // SizedBox(
                                //   width: width * 5,
                                // ),
                              ],
                            ),
                          ],
                        ),
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
                    onPressed: editTransaction,
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.pressed)) {
                          return secondary;
                        }
                        return green.withOpacity(0.8);
                      }),
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
                      "Update Expense",
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
