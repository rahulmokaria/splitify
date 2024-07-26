import 'package:flutter/material.dart';

import '../utils/colors.dart';

TextField textFieldUi(
    {required String text,
    required IconData icon,
    required bool isPasswordType,
    required Color textColor,
    required TextEditingController controller,
    required TextInputType inputType}) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    cursorColor: textColor,
    keyboardType: inputType,
    style: TextStyle(color: textColor),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: textColor,
      ),
      labelText: text,
      labelStyle: TextStyle(color: textColor),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: white.withOpacity(0.2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(width: 1, style: BorderStyle.none),
      ),
    ),
    // validator: (value) {
    //   if (value!.isEmpty) {
    //     // print('empty');
    //     return "Field cannot be empty";
    //   } else {
    //     // print('pappu pass');
    //     return null;
    //   }
    // },
  );
}
