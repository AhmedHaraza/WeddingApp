import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wedding/core/common/custom_button.dart';
import 'package:wedding/features/auth/presentation/signup/presentation/views/widgets/custom_drop_down.dart';

import '../../../../../../core/utils/app_router.dart';

class AuthorizationPage extends StatelessWidget {
  const AuthorizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    String dropdownValue = '';
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: Colors.deepOrange,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Select user or photographer",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropDownButtonAuth(
                        list: const ["User", "Photographer"],
                        onChanged: (value) {
                          dropdownValue = value;
                        },
                        icon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomButton(
                      status: "Continue",
                      onPressed: () {
                        if (dropdownValue == 'User') {
                          GoRouter.of(context)
                              .pushReplacement(AppRouter.KSignUpUser);
                        } else if (dropdownValue == 'Photographer') {
                          GoRouter.of(context)
                              .pushReplacement(AppRouter.KSignUpProvider);
                        }
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
