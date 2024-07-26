import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
// import 'package:splitify/ui/screens/customer/expense_tracker/expense_tracker.dart';

import '../../../utils/colors.dart';
import '../../../utils/text_month.dart';
import '../../../widgets/text_field_ui.dart';
import '../../../widgets/show_snackbar.dart';
import '../home_page.dart';

class CreateNewExpense extends StatefulWidget {
  final bool isExpense;
  const CreateNewExpense({super.key, required this.isExpense});

  @override
  State<CreateNewExpense> createState() => _CreateNewExpenseState();
}

class _CreateNewExpenseState extends State<CreateNewExpense> {
  final TextEditingController _amountTextController = TextEditingController();
  String? cat = "Food";
  String? remark = "";
  DateTime date = DateTime.now();

  final TextEditingController _remarkTextController = TextEditingController();

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
    'Investment income',
    'Gift',
    'Loan',
    'Commission',
    'Retire pensions',
    'Other Incomes',
  ];

  String endPoint = dotenv.env["URL"].toString();
  final storage = const FlutterSecureStorage();

  var categories;

  bool _isLoading = false;

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
                primary: secondaryLight, // <-- SEE HERE
                surface: secondary,
                onPrimary: purple, // <-- SEE HERE
                onSurface: white.withOpacity(0.6), // <-- SEE HERE
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  // primary: purple, // button text color
                  backgroundColor: purple,
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

  postdata() async {
    try {
      setState(() {
        _isLoading = true;
      });
      String transactionType = "";
      if (widget.isExpense) {
        transactionType = "Expense";
      } else {
        transactionType = "Income";
      }
      // print("trying to add new transaction");
      String? value = await storage.read(key: "authtoken");
      date = DateTime.parse(date.toString());
      var formattedDate = "${date.day}/${date.month}/${date.year}";
      var response = await http
          .post(Uri.parse("$endPoint/transactionApi/addTransaction"), body: {
        "token": value,
        "transactionType": transactionType,
        "addAmount": _amountTextController.text,
        "description": _remarkTextController.text,
        "category": cat,
        "date": formattedDate
      });
      var res = jsonDecode(response.body) as Map<String, dynamic>;
      if (res['flag']) {
        setState(() {
          _isLoading = false;
        });
        if (!mounted) return;
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
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
  void initState() {
    // implement initState
    super.initState();
    dropdownValue = widget.isExpense ? 'Food' : 'Salary';
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 100;
    // var _height = MediaQuery.of(context).size.height / 100;
    categories = widget.isExpense ? categoriesExpense : categoriesIncome;

    return Scaffold(
      backgroundColor: secondary,
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(FontAwesomeIcons.arrowLeft)),
        title: Text(
          widget.isExpense ? 'New Expense' : 'New Income',
        ),
        backgroundColor: purple,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(width * 5),
          child: Column(
            children: [
              Container(
                // padding: EdgeInsets.only(left: width * 4, right: width * 4),
                child: textFieldUi(
                    text: 'Amount',
                    icon: FontAwesomeIcons.wallet,
                    textColor: purple,
                    isPasswordType: false,
                    controller: _amountTextController,
                    inputType: TextInputType.number),
              ),
              SizedBox(
                height: width * 5,
              ),
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
                      // textScaleFactor: 1.2,
                      textScaler: const TextScaler.linear(1.2),
                    ),
                    SizedBox(
                      width: width * 10,
                    ),
                    DropdownButton(
                      value: dropdownValue,
                      underline: const SizedBox(),
                      dropdownColor: secondaryLight,
                      items: categories
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
                        dropdownValue = newValue!;
                        cat = dropdownValue;
                        setState(() {});

                        // print(cat);
                      },
                      icon: const Icon(FontAwesomeIcons.chevronDown),
                      style: TextStyle(
                        color: purple,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: width * 5,
              ),
              // TextFormField(
              //   controller: _remarkTextController,
              //   cursorColor: white,
              //   onChanged: (value) {
              //     remark = value;
              //   },
              //   style: const TextStyle(color: white),
              //   decoration: InputDecoration(
              //     hintText: "Add Remark",
              //     hintStyle: const TextStyle(color: white),
              //     labelText: "Remark:",
              //     labelStyle: const TextStyle(color: white),
              //     filled: true,
              //     fillColor: secondaryLight,
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10),
              //       borderSide:
              //           const BorderSide(width: 0, style: BorderStyle.none),
              //     ),
              //   ),
              //   validator: (value) {
              //     if (value!.isEmpty) {
              //       return "Remark cannot be empty";
              //     } else {
              //       return null;
              //     }
              //   },
              //   // hint
              // ),
              Container(
                // margin: EdgeInsets.only(left: width * 4, right: width * 4),
                child: textFieldUi(
                    text: 'Description',
                    icon: FontAwesomeIcons.bars,
                    textColor: purple,
                    isPasswordType: false,
                    controller: _remarkTextController,
                    inputType: TextInputType.streetAddress),
              ),
              SizedBox(
                height: width * 5,
              ),
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
                        // textScaleFactor: 1.2,
                        textScaler: const TextScaler.linear(1.2),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "${date.day} ${textMonth(date.month)} ${date.year}",
                        style: TextStyle(
                          color: purple,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: width * 2,
              ),
              const Divider(
                color: white,
              ),
              SizedBox(
                height: width * 2,
              ),
              // Container(
              //   height: 50,
              //   margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
              //   decoration:
              //       BoxDecoration(borderRadius: BorderRadius.circular(90)),
              //   child: ElevatedButton(
              //     child: const Text(
              //       "Add",
              //       textScaleFactor: 1.4,
              //       style: TextStyle(
              //         color: white,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //     onPressed: () {},
              //     style: ButtonStyle(
              //       backgroundColor: MaterialStateProperty.resolveWith((states) {
              //         return secondaryLight;
              //       }),
              //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //           RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(10))),
              //     ),
              //   ),
              // ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: width * 15,
                // margin: EdgeInsets.only(left: width * 4, right: width * 4),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(90)),
                child: ElevatedButton(
                  // onPressed: () => AddExpense(),
                  onPressed: () {
                    postdata();
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith(
                      (states) {
                        if (states.contains(WidgetState.pressed)) {
                          return secondary;
                        }
                        return purple.withOpacity(0.8);
                      },
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(width * 28))),
                  ),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: white,
                          ),
                        )
                      : const Text(
                          "Add",
                          style: TextStyle(
                            color: secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
