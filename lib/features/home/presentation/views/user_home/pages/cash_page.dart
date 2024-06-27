// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wedding/features/auth/data/profile.dart';

class CashPage extends StatefulWidget {
  const CashPage({
    super.key,
    required this.userProfile,
    required this.photographerProfile,
    required this.date,
    required this.time,
  });
  final Profile userProfile;
  final Profile photographerProfile;
  final DateTime date;
  final TimeOfDay time;
  @override
  _CashPageState createState() => _CashPageState();
}

class _CashPageState extends State<CashPage> {
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
        // Convert TimeOfDay to string
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
    return Container();
  }
}
