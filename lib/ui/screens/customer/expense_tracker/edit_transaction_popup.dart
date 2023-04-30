import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:splitify/ui/models/transaction.dart';

import '../../../utils/colors.dart';
import '../../../widgets/text_field_ui.dart';

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../../widgets/show_snackbar.dart';
import 'transaction_page.dart';

class EditTransactionCard extends StatefulWidget {
  UserTransaction transaction;

  EditTransactionCard({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  _EditTransactionCardState createState() => _EditTransactionCardState();
}

class _EditTransactionCardState extends State<EditTransactionCard> {
  TextEditingController _amountController = TextEditingController();
  TextEditingController _remarkController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: widget.transaction.transactionDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              primaryColor: secondary,
              splashColor: secondary,
              colorScheme: ColorScheme.light(
                primary: secondaryLight, // <-- SEE HERE
                background: secondary,
                onPrimary: purple, // <-- SEE HERE
                // onSurface: white.withOpacity(0.6), // <-- SEE HERE
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: purple, // button text color
                ),
              ),
            ),
            child: child!,
          );
        });
    if (picked != null && picked != widget.transaction.transactionDate) {
      setState(() {
        widget.transaction.transactionDate = picked;
        print(widget.transaction.transactionDate);
      });
    }
  }

  textMonth(num month) {
    switch (month) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
    }
  }

  String dropdownValue = 'Food';
  var categoriesExpense = [
    "Food",
    'Shopping',
    'Medicines',
    'Transport',
    'Utilities',
    'Education',
    'Entertainment',
    'Clothing',
    'Rent',
    'Others',
  ];
  var categoriesIncome = [
    'Salary',
    'Inves. income',
    'Gift',
    'Loan',
    'Commission',
    'Retire pensions',
    'Other Incomes',
  ];

  var categories;

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.transaction.amount.toString();

    _remarkController.text = widget.transaction.remark;
    dropdownValue = widget.transaction.category;
    categories =
        widget.transaction.amount < 0 ? categoriesExpense : categoriesIncome;
  }

  deletetransaction() async {
    String endPoint = dotenv.env["URL"].toString();
    final storage = new FlutterSecureStorage();
    try {
      String? value = await storage.read(key: "authtoken");
      var response = await http
          .post(Uri.parse(endPoint + "/api/user/deletetransaction"), body: {
        "token": value,
        "id": widget.transaction.transactionId,
      });
      var res = jsonDecode(response.body) as Map<String, dynamic>;
      if (res['flag']) {
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          ctype: ContentType.success,
          message: res['message'] + "Keep Enjoying",
        ));
      } else {
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          ctype: ContentType.failure,
          message: res['message'] + "Please contact admin to resolve",
        ));
      }
    } catch (e) {
      return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
        ctype: ContentType.failure,
        message: e.toString() + "Please contact admin to resolve",
      ));
    }
  }

  editdata() async {
    String endPoint = dotenv.env["URL"].toString();
    final storage = new FlutterSecureStorage();
    try {
      String? value = await storage.read(key: "authtoken");
      var date = widget.transaction.transactionDate;
      date = DateTime.parse(date.toString());
      var formattedDate = "${date.day}/${date.month}/${date.year}";
      var response = await http
          .post(Uri.parse(endPoint + "/api/user/edittransaction"), body: {
        "token": value,
        "id": widget.transaction.transactionId,
        "addamount": _amountController.text,
        "description": _remarkController.text,
        "category": dropdownValue,
        "date": formattedDate
      });
      var res = jsonDecode(response.body) as Map<String, dynamic>;
      if (res['flag']) {
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          ctype: ContentType.success,
          message: res['message'] + "Keep Enjoying",
        ));
      } else {
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          ctype: ContentType.failure,
          message: res['message'] + "Please contact admin to resolve",
        ));
      }
    } catch (e) {
      return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
        ctype: ContentType.failure,
        message: "${e}Please contact admin to resolve",
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    double width = MediaQuery.of(context).size.width * 0.01;
    double height = MediaQuery.of(context).size.height * 0.01;
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(width * 5),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: secondary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Edit/Delete Transaction',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: purple,
                ),
              ),
              SizedBox(height: width * 5),
              Container(
                // padding: EdgeInsets.only(left: width * 4, right: width * 4),
                child: textFieldUi(
                    text: 'Amount',
                    icon: FontAwesomeIcons.wallet,
                    textColor: purple,
                    isPasswordType: false,
                    controller: _amountController,
                    inputType: TextInputType.number),
              ),
              SizedBox(height: width * 5),
              Container(
                decoration: BoxDecoration(
                  color: white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.fromLTRB(width * 4, 5, width * 4, 5),
                child: Row(
                  children: [
                    Text(
                      "Category:",
                      style: TextStyle(
                        color: purple,
                      ),
                      textScaleFactor: 1.2,
                    ),
                    SizedBox(
                      width: width * 3,
                    ),
                    DropdownButton(
                      value: dropdownValue,
                      underline: const SizedBox(),
                      dropdownColor: secondaryLight,
                      items: categories
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Flexible(
                            child: Text(value,
                                textScaleFactor: 1,
                                style: TextStyle(
                                  color: purple,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ),
                        );

                        //   Text(
                        //     value,
                        //     textScaleFactor: 1.2,
                        //   ),
                        //   value: value,
                        // );
                      }).toList(),
                      onChanged: (String? newValue) {
                        dropdownValue = newValue!;

                        setState(() {});
                        print(dropdownValue);
                      },
                      icon: const Icon(FontAwesomeIcons.chevronDown),
                      style: TextStyle(
                        color: purple,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: width * 5),
              Container(
                // margin: EdgeInsets.only(left: width * 4, right: width * 4),
                child: textFieldUi(
                    text: 'Description',
                    icon: FontAwesomeIcons.bars,
                    textColor: purple,
                    isPasswordType: false,
                    controller: _remarkController,
                    inputType: TextInputType.streetAddress),
              ),
              SizedBox(height: width * 5),
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
                      Text(
                        "Select Date:",
                        style: TextStyle(
                          color: purple,
                        ),
                        textScaleFactor: 1.2,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "${widget.transaction.transactionDate.day.toString() + " " + textMonth(widget.transaction.transactionDate.month)} ${widget.transaction.transactionDate.year}",
                        style: TextStyle(
                          color: purple,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: width * 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: white.withOpacity(0.2),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: width * 2.5),
                  ElevatedButton(
                    onPressed: () {
                      //TODO: implement edit transaction functionality
                      editdata();
                      // Navigator.of(context).popUntil(( context, MaterialPageRout));
                      // if(Navigator.canPop(context)) {
                      //   // Navigator.canPop return true if can pop
                      //   Navigator.pop(context);
                      // }
                      // Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=>TransactionPage()));
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: white.withOpacity(0.2),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Save'),
                  ),
                  SizedBox(width: width * 2.5),
                  ElevatedButton(
                    onPressed: () {
                      //TODO: implement edit transaction functionality
                      deletetransaction();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: white.withOpacity(0.2),
                      onPrimary: red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
