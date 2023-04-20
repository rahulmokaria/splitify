import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../widgets/text_field_ui.dart';

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
  double? balance = 0;
  final TextEditingController _remarkTextController = TextEditingController();

  var dropdownValue = 'Food';
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

  var categories;

  var _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
        print(date);
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

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width / 100;
    var _height = MediaQuery.of(context).size.height / 100;
    categories = widget.isExpense ? categoriesExpense : categoriesIncome;
    dropdownValue = widget.isExpense ? 'Food' : 'Salary';
    return Scaffold(
      backgroundColor: secondary,
      appBar: AppBar(
        title: Text(
          widget.isExpense ? 'New Expense' : 'New Income',
        ),
        backgroundColor: purple,
      ),
      body: Container(
        padding: EdgeInsets.all(_width * 5),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: _width * 4, right: _width * 4),
              child: textFieldUi('Amount', Icons.wallet, false,
                  _amountTextController, TextInputType.number),
            ),
            SizedBox(
              height: _width * 5,
            ),
            Container(
              decoration: BoxDecoration(
                color: secondaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
              child: Row(
                children: [
                  const Text(
                    "Category:",
                    style: TextStyle(
                      color: white,
                    ),
                    textScaleFactor: 1.2,
                  ),
                  const SizedBox(
                    width: 50,
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
                      setState(() {
                        dropdownValue = newValue!;
                        cat = dropdownValue;
                      });
                    },
                    icon: const Icon(Icons.keyboard_arrow_down),
                    style: const TextStyle(
                      color: white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
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
              margin: EdgeInsets.only(left: _width * 4, right: _width * 4),
              child: textFieldUi('Description', Icons.menu, false,
                  _remarkTextController, TextInputType.streetAddress),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                color: secondaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.fromLTRB(15, 20, 0, 20),
              child: InkWell(
                onTap: () => _selectDate(context),
                child: Row(
                  children: [
                    const Text(
                      "Select Date:",
                      style: TextStyle(
                        color: white,
                      ),
                      textScaleFactor: 1.2,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      "${date.day.toString() + " " + textMonth(date.month)} ${date.year}",
                      style: const TextStyle(
                        color: white,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Divider(
              color: white,
            ),
            const SizedBox(
              height: 5,
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
              margin: EdgeInsets.only(left: _width * 4, right: _width * 4),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(90)),
              child: ElevatedButton(
                // onPressed: () => AddExpense(),
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return secondary;
                    }
                    return primary.withOpacity(0.8);
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
    );
  }
}
