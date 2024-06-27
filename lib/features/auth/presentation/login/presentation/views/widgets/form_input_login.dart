import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../constants.dart';
import '../../../../../../../core/common/custom_button.dart';
import '../../../../../../../core/common/custom_text_feild.dart';
import '../../../../../manager/auth_cubit/auth_cubit.dart';
final GlobalKey<FormState> _formKeyLogin = GlobalKey<FormState>();

class FormInput extends StatefulWidget {
  const FormInput({super.key});

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  String email = '';
  String password = '';

  void _login(BuildContext context) {
    if (_formKeyLogin.currentState!.validate()) {
      context.read<AuthenticationCubit>().signInWithEmailAndPassword(
        email,
        password,
      );


    }
  }
  @override
  Widget build(BuildContext context) {
    return  Form(
      key: _formKeyLogin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            hint: "Email",
            secure: false,
            icon: const Icon(Icons.person),
            type: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email is required";
              }
              else if(!Constant.isValidEmail(value)){
                return "Invalid Email";
              }
              else {
                email = value;
                return null;
              }
            },
          ),
          const SizedBox(height: 10),
          CustomTextField(
            hint: "Password",
            secure: true,
            icon: const Icon(Icons.password),
            type: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Password is required";
              }else if(value.length<6){
                return "Password is wrong";
              }

              else {
                password = value;
                return null;
              }
            },
          ),
          const SizedBox(height: 10),
          CustomButton(status: "Login", onPressed: () {
            _login(context);
          }),
        ],
      ),
    );
  }
}
