import 'package:flutter/material.dart';
class Constant{

  static  InputDecoration paymentDecoration=  InputDecoration(
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,

    ),
    fillColor: Colors.white,
    filled: true,
      hintStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w400,
      ),
      labelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold
      )
  );
  static bool isValidEmail(String email) {
    // Regular expression for validating an email address
    // This pattern checks for the basic structure of an email address
    // It may not catch all possible invalid emails, but it covers most cases
    // You can use more sophisticated regex patterns for stricter validation
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }



}