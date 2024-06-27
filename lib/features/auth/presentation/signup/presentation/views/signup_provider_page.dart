import 'package:flutter/material.dart';

import 'package:wedding/features/auth/presentation/signup/presentation/views/widgets/form_input_signup_photographer.dart';




class SignUpProviderPage extends StatelessWidget {
  const SignUpProviderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: const SignUpPhotographerForm(),
        ),
      ),
    );
  }
}

