import 'package:flutter/material.dart';
import 'package:splitify/ui/models/transaction.dart';

import '../../utils/colors.dart';
import '../../widgets/text_field_ui.dart';


import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../widgets/show_snackbar.dart';


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
  TextEditingController _categoryController = TextEditingController();
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
    _categoryController.text = widget.transaction.category;
    _remarkController.text = widget.transaction.remark;
    dropdownValue = widget.transaction.category;
    categories = widget.transaction.amount < 0 ? categoriesExpense : categoriesIncome;
  }
    editdata()async {
      String endPoint=dotenv.env["URL"].toString();
      final storage = new FlutterSecureStorage();
      try {
        String? value = await storage.read(key: "authtoken");
       var date= widget.transaction.transactionDate;
       date = DateTime.parse(date.toString());
      var formattedDate = "${date.day}/${date.month}/${date.year}";
      var response=await http.post(Uri.parse(endPoint+"/api/user/edittransaction"),
          body:{
            "token":value,
            "id":widget.transaction.transactionId,
            "addamount":_amountController.text,
            "description":_remarkController.text,
            "category":_categoryController.text,
            "date":formattedDate
          });
          var res=jsonDecode(response.body) as Map<String,dynamic>;
          if(res['flag']){
            return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
              res['message'], "Please contact admin to resolve", pink, Icons.close));
          }
      } catch (e) {
        return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
              e.toString(), "Please contact admin to resolve", pink, Icons.close));
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
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(_width * 5),
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
              SizedBox(height: _width * 5),
              Container(
                // padding: EdgeInsets.only(left: _width * 4, right: _width * 4),
                child: textFieldUi(
                    text: 'Amount',
                    icon: Icons.wallet,
                    textColor: purple,
                    isPasswordType: false,
                    controller: _amountController,
                    inputType: TextInputType.number),
              ),
              SizedBox(height: _width * 5),
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
                      width: _width * 3,
                    ),
                    DropdownButton(
                      value: dropdownValue,
                      underline: const SizedBox(),
                      dropdownColor: secondaryLight,
                      items: categories
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          child: Flexible(
                            child: Text(value,
                                textScaleFactor: 1,
                                style: TextStyle(
                                  color: purple,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ),
                          value: value,
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

                        setState(() {_categoryController=dropdownValue as TextEditingController;});
                        print(dropdownValue);
                      },
                      icon: const Icon(Icons.keyboard_arrow_down),
                      style: TextStyle(
                        color: purple,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: _width * 5),
              Container(
                // margin: EdgeInsets.only(left: _width * 4, right: _width * 4),
                child: textFieldUi(
                    text: 'Description',
                    icon: Icons.menu,
                    textColor: purple,
                    isPasswordType: false,
                    controller: _remarkController,
                    inputType: TextInputType.streetAddress),
              ),
              SizedBox(height: _width * 5),
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
              SizedBox(height: _width * 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      primary: white.withOpacity(0.2),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(width: _width * 2.5),
                  ElevatedButton(
                    onPressed: () {
                      //TODO: implement edit transaction functionality
                      editdata();
                      Navigator.of(context).pop();
                    },
                    child: Text('Save'),
                    style: ElevatedButton.styleFrom(
                      primary: white.withOpacity(0.2),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(width: _width * 2.5),
                  ElevatedButton(
                    onPressed: () {
                      //TODO: implement edit transaction functionality
                      Navigator.of(context).pop();
                    },
                    child: Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      primary: white.withOpacity(0.2),
                      onPrimary: red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
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
