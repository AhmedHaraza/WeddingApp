import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:wedding/constants.dart';
import '../../../../../../../core/common/custom_button.dart';
import '../../../../../../../core/common/custom_text_feild.dart';
import '../../../../../data/profile.dart';
import '../../../../../manager/auth_cubit/auth_cubit.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class FormInputSignup extends StatefulWidget {
  const FormInputSignup({Key? key}) : super(key: key);

  @override
  State<FormInputSignup> createState() => _FormInputSignupState();
}

class _FormInputSignupState extends State<FormInputSignup> {
  String email = '';
  String password = '';
  String name = '';
  String phoneNumber = '';
  String confirmPassword = '';

  Future<void> addUserToFirestore(
      String name, String email, String phoneNumber, String userId) async {
    Profile profile = Profile(
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      profileId: userId,
      authorization: "user",
    );
    Map<String, dynamic> profileMap = profile.toMap();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set(profileMap);
      print('User added to Firestore successfully.');
    } catch (e) {
      print('Error adding user to Firestore: $e');
    }
  }

  void navigate(BuildContext context) {
    _signUp(context);
  }

  void _signUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (confirmPassword == password) {
        try {
          // Create user in Firebase Authentication
          User? user = await context
              .read<AuthenticationCubit>()
              .signUpWithEmailAndPassword(email, password);

          if (user != null) {
            // Use the user's ID to store additional information in Firestore
            final userId = user.uid;
            addUserToFirestore(name, email, phoneNumber, userId);

            // Navigate to the home page after successful signup
          }
        } catch (e) {
          print('Error during signup: $e');
          // Handle signup errors here
        }
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: "Wrong password",
          desc: "Password and Confirm password are different",
          btnCancelOnPress: () {},
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.deepOrange,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "SignUp",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    CustomTextField(
                      hint: "Username",
                      secure: false,
                      icon: const Icon(Icons.person),
                      type: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Username is required";
                        } else {
                          name = value;
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hint: "Phone Number",
                      secure: false,
                      icon: const Icon(Icons.phone),
                      type: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Phone number is required";
                        } else if (value.length != 11) {
                          return "Phone Number must be 11 number";
                        } else if (value[0] != "0" && value[1] != "1") {
                          return "Phone number must be started with 01";
                        } else {
                          phoneNumber = value;
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hint: "Email",
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
                    const SizedBox(height: 8),
                    CustomTextField(
                      hint: "Password",
                      secure: true,
                      icon: const Icon(Icons.password),
                      type: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        } else if (value.length < 8) {
                          return "Password must be at least 8 characters";
                        } else if (!containsDigits(value) ||
                            !containsLetters(value)) {
                          return "Password must contain both letters and numbers";
                        } else {
                          password = value;
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hint: "Confirm Password",
                      secure: true,
                      icon: const Icon(Icons.password),
                      type: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Confirm password is required";
                        }else if(value!=password){
                          return "Confirm password must be equal to password";
                        }

                        else {
                          confirmPassword = value;
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      status: "Sign Up",
                      onPressed: () {
                        navigate(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  bool containsDigits(String value) {
    return value.contains(RegExp(r'\d'));
  }

  bool containsLetters(String value) {
    return value.contains(RegExp(r'[a-zA-Z]'));
  }
}
