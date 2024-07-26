import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../models/transaction.dart';
import '../../../utils/colors.dart';
import '../../../utils/text_month.dart';
import '../../../widgets/text_field_ui.dart';

class EditGroupSplitPage extends StatefulWidget {
  const EditGroupSplitPage(
      {Key? key, required this.billSplitTransaction, required this.friendName})
      : super(key: key);
  final String friendName;
  final BillSplitTransaction billSplitTransaction;
  @override
  State<EditGroupSplitPage> createState() => _EditBillSplitPageState();
}

class _EditBillSplitPageState extends State<EditGroupSplitPage> {
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
                onPrimary: orange, // <-- SEE HERE
                // onSurface: white.withOpacity(0.6), // <-- SEE HERE
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  // primary: orange, // button text color
                  backgroundColor: orange,
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

  @override
  void initState() {
    super.initState();
    paidByOptions.add(widget.friendName);
    _remarkTextController.text = widget.billSplitTransaction.remark;
    _amountTextController.text = widget.billSplitTransaction.amount.toString();
    paidBy = (widget.billSplitTransaction.paidBy == widget.friendName)
        ? widget.friendName
        : "You";
    if (widget.billSplitTransaction.shareOfPayer !=
        widget.billSplitTransaction.shareOfBorrower) {
      splitOptionSelected = 'Split by amount';
      if (paidBy == widget.friendName) {
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
    // double _height = MediaQuery.of(context).size.height * 0.01;

    return Scaffold(
        backgroundColor: secondary,
        appBar: AppBar(
          leading: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(FontAwesomeIcons.arrowLeft)),
          // elevation: 0.0,
          title: const Text('Edit Expense'),
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
                          "${date.day.toString()} ${textMonth(date.month)} ${date.year}",
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
                    decoration: BoxDecoration(
                        color: white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: width * 5,
                        ),
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
                                  "User's share:",
                                  style: TextStyle(color: white),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: width * 30,
                              child: TextField(
                                controller: _userShareTextController,
                                style: TextStyle(color: orange),
                                cursorColor: orange,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  // prefixIcon: Icon(
                                  //   ,
                                  //   color: textColor,
                                  // ),
                                  labelText: '0.00',
                                  labelStyle: TextStyle(color: orange),
                                  filled: true,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  // fillColor: white.withOpacity(0.2),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
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
                                style: TextStyle(color: orange),
                                cursorColor: orange,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  // prefixIcon: Icon(
                                  //   ,
                                  //   color: textColor,
                                  // ),
                                  labelText: '0.00',
                                  labelStyle: TextStyle(color: orange),
                                  filled: true,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  // fillColor: white.withOpacity(0.2),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
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
                    decoration: BoxDecoration(
                        color: white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: width * 5,
                        ),
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
                                  width: width * 20,
                                  child: TextField(
                                    controller: _userSharePercentTextController,
                                    style: TextStyle(color: orange),
                                    cursorColor: orange,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      // prefixIcon: Icon(
                                      //   ,
                                      //   color: textColor,
                                      // ),
                                      labelText: '0.00',
                                      labelStyle: TextStyle(color: orange),
                                      filled: true,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      // fillColor: white.withOpacity(0.2),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
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
                                const Text(
                                  "%",
                                  // textScaleFactor: 1.3,
                                  textScaler: TextScaler.linear(1.3),
                                  style: TextStyle(color: white),
                                ),
                                SizedBox(
                                  width: width * 5,
                                ),
                              ],
                            ),
                          ],
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
                                  width: width * 20,
                                  child: TextField(
                                    controller:
                                        _friendSharePercentTextController,
                                    style: TextStyle(color: orange),
                                    cursorColor: orange,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      // prefixIcon: Icon(
                                      //   ,
                                      //   color: textColor,
                                      // ),
                                      labelText: '0.00',
                                      labelStyle: TextStyle(color: orange),
                                      filled: true,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      // fillColor: white.withOpacity(0.2),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
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
                                const Text(
                                  "%",
                                  // textScaleFactor: 1.3,
                                  textScaler: TextScaler.linear(1.3),
                                  style: TextStyle(color: white),
                                ),
                                SizedBox(
                                  width: width * 5,
                                ),
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
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.pressed)) {
                          return secondary;
                        }
                        return orange.withOpacity(0.8);
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
