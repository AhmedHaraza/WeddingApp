import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedding/core/common/custom_text_feild.dart';
import 'package:wedding/core/utils/app_router.dart';
import 'package:wedding/features/auth/manager/auth_cubit/auth_state.dart';

import '../../../../../../constants.dart';
import '../../../../../../core/common/custom_button.dart';
import '../../../../manager/auth_cubit/auth_cubit.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: BlocBuilder<AuthenticationCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthenticationFailure) {
                Future.delayed(Duration.zero, () {
                  AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          title: "Login failed",
                          desc: "Check data please + ${state.error}",
                          btnCancelOnPress: () {})
                      .show();
                });
                return const ForgetForm();
              } else if (state is AuthenticationSuccess) {
                return const ForgetForm();
              } else if (state is AuthenticationLoading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return const ForgetForm();
              }
            },
          ),
        ),
      ),
    );
  }
}

class ForgetForm extends StatefulWidget {
  const ForgetForm({super.key});

  @override
  State<ForgetForm> createState() => _ForgetFormState();
}

class _ForgetFormState extends State<ForgetForm> {
  String email = "";

  void forgetPassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthenticationCubit>().resetPassword(email);
      GoRouter.of(context).pushReplacement(AppRouter.KLoginPage);
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: "Wrong Email",
        desc: "This email didn't signup",
        btnCancelOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: Colors.deepOrange,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Forget Password",
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
                  child: CustomTextField(
                    hint: "enter Email",
                    secure: false,
                    icon: const Icon(Icons.email),
                    type: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      } else if (!Constant.isValidEmail(value)) {
                        return "Invalid Email";
                      } else {
                        email = value;
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomButton(
                  status: "Continue",
                  onPressed: () {
                    forgetPassword(context);
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
