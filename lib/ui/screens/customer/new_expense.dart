import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../widgets/text_field_ui.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../widgets/show_snackbar.dart';
class CreateNewExpense extends StatefulWidget {
  bool isExpense;
  CreateNewExpense({super.key, required this.isExpense});

  @override
  State<CreateNewExpense> createState() => _CreateNewExpenseState();
}

class _CreateNewExpenseState extends State<CreateNewExpense> {
  final TextEditingController _amountTextController = TextEditingController();
  String? cat = "";
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
  
    String endPoint=dotenv.env["URL"].toString();
  final storage = new FlutterSecureStorage();  

  var categories;

  var _isLoading = false;

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
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
        print(date.runtimeType);
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

  postdata() async{
    try {
      String transactionType="";
      if(widget.isExpense){
        cat="Food";
        transactionType="Expense";
      }
      else{
        cat="Salary";
        transactionType="Income";
      }
      String? value = await storage.read(key: "authtoken");
      date = DateTime.parse(date.toString());
      var formattedDate = "${date.day}-${date.month}-${date.year}";
      var response=await http.post(Uri.parse(endPoint+"/api/user/addtransaction"),
          body:{
            "token":value,
            "transactiontype":transactionType,
            "addamount":_amountTextController.text,
            "description":_remarkTextController.text,
            "category":cat,
            "date":formattedDate
          });
          var res=jsonDecode(response.body) as Map<String,dynamic>;
          if(res['flag']){
            return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
              res['message'], "Keep Adding 😀😀", green, Icons.celebration));
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
    // TODO: implement initState
    super.initState();
    dropdownValue = widget.isExpense ? 'Food' : 'Salary';
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width / 100;
    var _height = MediaQuery.of(context).size.height / 100;
    categories = widget.isExpense ? categoriesExpense : categoriesIncome;

    return Scaffold(
      backgroundColor: secondary,
      appBar: AppBar(
        title: Text(
          widget.isExpense ? 'New Expense' : 'New Income',
        ),
        backgroundColor: purple,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(_width * 5),
          child: Column(
            children: [
              Container(
                // padding: EdgeInsets.only(left: _width * 4, right: _width * 4),
                child: textFieldUi(
                    text: 'Amount',
                    icon: Icons.wallet,
                    textColor: purple,
                    isPasswordType: false,
                    controller: _amountTextController,
                    inputType: TextInputType.number),
              ),
              SizedBox(
                height: _width * 5,
              ),
              Container(
                decoration: BoxDecoration(
                  color: white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.fromLTRB(_width * 4, 5, _width * 4, 5),
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
                      width: _width * 10,
                    ),
                    DropdownButton(
                      value: dropdownValue,
                      underline: const SizedBox(),
                      dropdownColor: secondaryLight,
                      items: categories
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          child: Text(
                            value,
                            textScaleFactor: 1.2,
                          ),
                          value: value,
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        dropdownValue = newValue!;
                        cat = dropdownValue;
                        setState(() {});

                        print(cat);
                      },
                      icon: const Icon(Icons.keyboard_arrow_down),
                      style: TextStyle(
                        color: purple,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: _width * 5,
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
                // margin: EdgeInsets.only(left: _width * 4, right: _width * 4),
                child: textFieldUi(
                    text: 'Description',
                    icon: Icons.menu,
                    textColor: purple,
                    isPasswordType: false,
                    controller: _remarkTextController,
                    inputType: TextInputType.streetAddress),
              ),
              SizedBox(
                height: _width * 5,
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
                        textScaleFactor: 1.2,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "${date.day.toString() + " " + textMonth(date.month)} ${date.year}",
                        style: TextStyle(
                          color: purple,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: _width * 2,
              ),
              const Divider(
                color: white,
              ),
              SizedBox(
                height: _width * 2,
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
                height: _width * 15,
                // margin: EdgeInsets.only(left: _width * 4, right: _width * 4),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(90)),
                child: ElevatedButton(
                  // onPressed: () => AddExpense(),
                  onPressed: () {postdata();},
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return secondary;
                      }
                      return purple.withOpacity(0.8);
                    }),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(_width * 28))),
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
