import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wedding/core/utils/app_router.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        GoRouter.of(context).push(AppRouter.KForgerPassword);
      },
      child: const Text("Forgot password?",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}