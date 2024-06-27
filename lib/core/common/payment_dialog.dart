import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wedding/features/auth/data/profile.dart';
import 'package:wedding/features/home/presentation/views/provider_home/provider_home_page.dart';
import 'package:wedding/features/home/presentation/views/user_home/pages/payment_page.dart';

class PaymentDialog extends StatefulWidget {
  const PaymentDialog({
    super.key,
    required this.userData,
    required this.photographerData,
    required this.selectedDate,
    required this.selectedTime,
  });

  final Profile userData;
  final Profile photographerData;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
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
        'dateTime': dateTime,
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select Payment Method',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, 'Cash');
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'You Selected Cash pay, Your payment is with the photographer',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: () {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.success,
                                  animType: AnimType.scale,
                                  title: "Confirm Cash",
                                  desc: "Are you sure want to confirm Cash",
                                  btnOkOnPress: () {
                                    addOrderToFirestore(
                                        widget.userData.name!,
                                        widget.userData.phoneNumber!,
                                        widget.photographerData.name!,
                                        widget.photographerData.phoneNumber!,
                                        widget.userData.profileId!,
                                        widget.userData.profileId!,
                                        widget.selectedDate,
                                        widget.selectedTime);
                                  },
                                  btnCancelOnPress: () {},
                                ).show();
                              },
                              child: GestureDetector(
                                child: const Text('Ok'),
                                onTap: () {
                                  AlertDialog(
                                    title: const Text("Success"),
                                    content: const Text(
                                        'Profile updated successfully'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Text('Pay with Cash'),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, 'Visa');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return PaymentPage(
                        userProfile: widget.userData,
                        photographerProfile: widget.photographerData,
                        date: widget.selectedDate,
                        time: widget.selectedTime,
                      );
                    },
                  ),
                );
              },
              child: const Text('Pay with Visa'),
            ),
          ],
        ),
      ),
    );
  }
}