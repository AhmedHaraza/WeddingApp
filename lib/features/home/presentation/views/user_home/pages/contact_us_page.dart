import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wedding/constants.dart';
import 'package:wedding/core/common/custom_button.dart';
import 'package:wedding/features/home/data/contact_message.dart';
import 'package:wedding/features/home/presentation/services/firebase_service.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  final _formStateKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text('Contact Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formStateKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Message cannot be empty';
                    }
                    return null;
                  },
                  controller: nameController,
                  decoration: Constant.paymentDecoration.copyWith(
                    labelText: "Name",
                    labelStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Message cannot be empty';
                    }
                    return null;
                  },
                  controller: emailController,
                  decoration: Constant.paymentDecoration.copyWith(
                    labelText: "Email",
                    labelStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Message cannot be empty';
                    }
                    return null;
                  },
                  controller: subjectController,
                  decoration: Constant.paymentDecoration.copyWith(
                    labelText: "Subject",
                    labelStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Message cannot be empty';
                    }
                    return null;
                  },
                  controller: messageController,
                  decoration: Constant.paymentDecoration.copyWith(
                      labelText: "Message",
                      labelStyle: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w400)),
                  maxLines: 5,
                ),
                const SizedBox(height: 16.0),
                CustomButton(
                  status: "Submit Message",
                  onPressed: () {
                    if (_formStateKey.currentState!.validate()) {
                      FirebaseService.sendContactMessage(
                        ContactMessage(
                          nameController.text,
                          emailController.text,
                          subjectController.text,
                          messageController.text,
                        ),
                      ).then(
                        (value) {
                          nameController.clear();
                          subjectController.clear();
                          emailController.clear();
                          messageController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Message was sent successfully'),
                            ),
                          );

                          Future<QuerySnapshot<Map<String, dynamic>>> data =
                              FirebaseFirestore.instance
                                  .collection('messages')
                                  .get();
                          data.then(
                            (value) {
                              value.docs.forEach(
                                (element) {
                                  print(
                                    element.data(),
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
