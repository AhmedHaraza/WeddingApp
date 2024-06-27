import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:wedding/core/common/custom_button.dart';
import 'package:wedding/features/auth/data/profile.dart';

import '../../../../../../constants.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage(
      {super.key,
      required this.date,
      required this.time,
      required this.userProfile,
      required this.photographerProfile});
  final Profile userProfile;
  final Profile photographerProfile;
  final DateTime date;
  final TimeOfDay time;
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Future<void> addOrderToFirestore(
      String userName,
      String userPhone,
      String photographerName,
      String photographerPhone,
      String userId,
      String photogId,
      DateTime dateTime,
      TimeOfDay timeOfDay) async {
    try {
      await FirebaseFirestore.instance.collection('orders').add({
        'userName': userName,
        'userPhone': userPhone,
        'photographerName': photographerName,
        'photographerPhone': photographerPhone,
        'userId': userId,
        'photographerId': photogId,
        'dateTime': dateTime.toString(),
        'timeOfDay':
            '${timeOfDay.hour}:${timeOfDay.minute}', // Convert TimeOfDay to string
      });
      await FirebaseFirestore.instance
          .collection('photographers')
          .doc(photogId)
          .collection("orders")
          .add({
        'userName': userName,
        'userPhone': userPhone,
        'photographerName': photographerName,
        'photographerPhone': photographerPhone,
        'userId': userId,
        'photographerId': photogId,
        'dateTime': dateTime,
        'timeOfDay':
            '${timeOfDay.hour}:${timeOfDay.minute}', // Convert TimeOfDay to string
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection("orders")
          .add({
        'userName': userName,
        'userPhone': userPhone,
        'photographerName': photographerName,
        'photographerPhone': photographerPhone,
        'userId': userId,
        'photographerId': photogId,
        'dateTime': dateTime,
        'timeOfDay':
            '${timeOfDay.hour}:${timeOfDay.minute}', // Convert TimeOfDay to string
      });

      await FirebaseFirestore.instance.collection('reservedDate').add({
        'dateTime': dateTime,
        'timeOfDay':
            '${timeOfDay.hour}:${timeOfDay.minute}', // Convert TimeOfDay to string
      });
      print('order added to Firestore successfully.');
    } catch (e) {
      print('Error adding user to Firestore: $e');
    }
  }

  String name = "";
  String expiryDate = "";
  String cardNumber = "";
  String cvv = "";
  bool isCvvFocused = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.7),
      appBar: AppBar(
        title: const Text('Payment Form'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CreditCardWidget(
                isHolderNameVisible: true,
                cardType: CardType.visa,
                cardBgColor: Colors.deepOrange,
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: name,
                cvvCode: cvv,
                showBackView: isCvvFocused,
                onCreditCardWidgetChange: (CreditCardBrand) {},
              ),
              FormBuilder(
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'cardNumber',
                      decoration: Constant.paymentDecoration.copyWith(
                          labelText: "Card Number", hintText: "xxxxxxxxxxx"),
                      onChanged: (value) {
                        setState(() {
                          cardNumber = value!;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    FormBuilderTextField(
                      name: 'expiryDate',
                      decoration: Constant.paymentDecoration.copyWith(
                          labelText: "Expiry Date", hintText: "mm/yy"),
                      onChanged: (value) {
                        setState(() {
                          expiryDate = value!;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    FormBuilderTextField(
                      name: 'cardHolderName',
                      decoration: Constant.paymentDecoration.copyWith(
                        hintText: "Card Holder Name",
                        labelText: "Name",
                      ),
                      onChanged: (value) {
                        setState(() {
                          name = value!;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    FormBuilderTextField(
                      name: 'cvvCode',
                      decoration: Constant.paymentDecoration.copyWith(
                        hintText: "***",
                        labelText: "CVV",
                      ),
                      onChanged: (value) {
                        cvv = value!;
                      },
                      onTap: () {
                        setState(() {
                          isCvvFocused = true;
                        });
                      },
                      onEditingComplete: () {
                        setState(() {
                          isCvvFocused = false;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                        status: "Submit Payment",
                        onPressed: () {
                          if (cardNumber.isNotEmpty &&
                              expiryDate.isNotEmpty &&
                              name.isNotEmpty &&
                              cvv.isNotEmpty) {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              animType: AnimType.scale,
                              title: "Confirm Payment",
                              desc: "Are you sure want to confirm payment",
                              btnOkOnPress: () {
                                addOrderToFirestore(
                                  widget.userProfile.name!,
                                  widget.userProfile.phoneNumber!,
                                  widget.photographerProfile.name!,
                                  widget.photographerProfile.phoneNumber!,
                                  widget.userProfile.profileId!,
                                  widget.photographerProfile.profileId!,
                                  widget.date,
                                  widget.time,
                                );
                              },
                              btnCancelOnPress: () {},
                            ).show();
                          } else {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.scale,
                              title: "Fill Data",
                              desc: "Please fill payment data",
                              btnCancelOnPress: () {},
                            ).show();
                          }
                        }),
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
