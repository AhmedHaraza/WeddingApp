import 'package:flutter/material.dart';
import 'package:wedding/core/utils/styles.dart';
class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        const Text(
          "Welcome Back",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Enter your credential to login" ,
          style: Styles.kTextStyle18.copyWith(color: Colors.black),),
      ],
    );
  }
}
