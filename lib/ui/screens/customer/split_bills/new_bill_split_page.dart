import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../utils/colors.dart';
import '../../../widgets/text_field_ui.dart';

class NewBillSplitPage extends StatefulWidget {
  const NewBillSplitPage({Key? key}) : super(key: key);

  @override
  State<NewBillSplitPage> createState() => _NewBillSplitPageState();
}

class _NewBillSplitPageState extends State<NewBillSplitPage> {
  TextEditingController _remarkTextController = TextEditingController();
  TextEditingController _amountTextController = TextEditingController();
  TextEditingController _userShareTextController = TextEditingController();
  TextEditingController _friendShareTextController = TextEditingController();
  TextEditingController _userSharePercentTextController =
      TextEditingController();
  TextEditingController _friendSharePercentTextController =
      TextEditingController();
  String paidBy = 'You';
  String splitOptionSelected = 'Split Equally';
  var splitOptions = [
    'Split Equally',
    'Split by amount',
    'Split by percentage'
  ];
  var paidByOptions = ['You', 'FriendName'];
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;

    return Scaffold(
        backgroundColor: secondary,
        appBar: AppBar(
          leading: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(FontAwesomeIcons.arrowLeft)),
          // elevation: 0.0,
          title: const Text('Add Expense'),
          backgroundColor: green,
        ),
        body: Container(
          padding: EdgeInsets.all(_width * 2),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //split between
                Text("Split between"),
                //description
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
                  height: _width * 5,
                ),
                //amount
                Container(
                  // padding: EdgeInsets.only(left: _width * 4, right: _width * 4),
                  child: textFieldUi(
                      text: 'Amount',
                      icon: FontAwesomeIcons.wallet,
                      textColor: green,
                      isPasswordType: false,
                      controller: _amountTextController,
                      inputType: TextInputType.number),
                ),
                SizedBox(
                  height: _width * 5,
                ),
                //paid by options
                Container(
                  decoration: BoxDecoration(
                    color: white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.fromLTRB(_width * 4, 5, _width * 4, 5),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.ghost,
                        color: green,
                      ),
                      SizedBox(
                        width: _width * 3,
                      ),
                      Text(
                        "Paid By:",
                        style: TextStyle(
                          color: green,
                        ),
                        textScaleFactor: 1.2,
                      ),
                      SizedBox(
                        width: _width * 10,
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
                              textScaleFactor: 1.2,
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
                  height: _width * 5,
                ),
                //split options
                Container(
                  decoration: BoxDecoration(
                    color: white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.fromLTRB(_width * 4, 5, _width * 4, 5),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.tableColumns,
                        color: green,
                      ),
                      SizedBox(
                        width: _width * 3,
                      ),
                      Text(
                        "Split by:",
                        style: TextStyle(
                          color: green,
                        ),
                        textScaleFactor: 1.2,
                      ),
                      SizedBox(
                        width: _width * 10,
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
                              textScaleFactor: 1.2,
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
                  height: _width * 5,
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
                          height: _width * 5,
                        ),
                        Text(
                          'Split by amount',
                          textScaleFactor: 1.5,
                          style: TextStyle(color: white),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: _width * 5,
                                ),
                                Text(
                                  "User's share:",
                                  style: TextStyle(color: white),
                                ),
                              ],
                            ),
                            Container(
                              width: _width * 30,
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
                                  width: _width * 5,
                                ),
                                Text(
                                  "Friend's share:",
                                  style: TextStyle(color: white),
                                ),
                              ],
                            ),
                            Container(
                              width: _width * 30,
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
                          height: _width * 5,
                        ),
                        Text(
                          'Split by percentage',
                          textScaleFactor: 1.5,
                          style: TextStyle(color: white),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: _width * 5,
                                ),
                                Text(
                                  "User's percentage:",
                                  style: TextStyle(color: white),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: _width * 20,
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
                                Text(
                                  "%",
                                  textScaleFactor: 1.3,
                                  style: TextStyle(color: white),
                                ),
                                SizedBox(
                                  width: _width * 5,
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
                                  width: _width * 5,
                                ),
                                Text(
                                  "Friend's percentage:",
                                  style: TextStyle(color: white),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: _width * 20,
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
                                Text(
                                  "%",
                                  textScaleFactor: 1.3,
                                  style: TextStyle(color: white),
                                ),
                                SizedBox(
                                  width: _width * 5,
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
                    height: _width * 5,
                  ),

                //add it to transactions
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: _width * 15,
                  // margin: EdgeInsets.only(left: _width * 4, right: _width * 4),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(90)),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return secondary;
                        }
                        return green.withOpacity(0.8);
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(_width * 28))),
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
