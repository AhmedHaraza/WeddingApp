import 'package:flutter/material.dart';
import 'package:wedding/features/auth/presentation/login/presentation/views/widgets/forget_password.dart';
import 'package:wedding/features/auth/presentation/login/presentation/views/widgets/header.dart';
import 'package:wedding/features/auth/presentation/login/presentation/views/widgets/input_feilds.dart';
import 'package:wedding/features/auth/presentation/login/presentation/views/widgets/sign_up.dart';



class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Header(),
            Container(
              color: Colors.deepOrange,
              child: const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  InputFeilds(),
                  ForgetPassword(),
                  SignUp(),
                ],
              ),
            ),
          ], // Add the missing comma here
        ), // Add the missing closing parentheses here
      ),
    );
  }
}