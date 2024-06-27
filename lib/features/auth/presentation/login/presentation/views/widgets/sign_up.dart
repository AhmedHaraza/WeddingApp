import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wedding/core/utils/app_router.dart';
class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
            onPressed: () {
              GoRouter.of(context).push(AppRouter.KAuthPath);
            },
            child: const Text("Sign Up", style: TextStyle(color: Colors.white),)
        )
      ],
    );
  }
}