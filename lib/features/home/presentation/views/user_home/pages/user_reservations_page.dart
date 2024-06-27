import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wedding/features/auth/data/profile.dart';

import '../../../../data/reservation.dart';

class UserResrvationPage extends StatefulWidget {
  const UserResrvationPage({Key? key, required this.profile}) : super(key: key);

  final Profile profile;

  @override
  State<UserResrvationPage> createState() => _UserResrvationPageState();
}

class _UserResrvationPageState extends State<UserResrvationPage> {
  List<Reservation> reservations = [];

  @override
  void initState() {
    super.initState();
    fetchReservations();
  }

  Future<void> fetchReservations() async {
    try {
      // Access Firestore collection 'reservations'
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.profile.profileId)
          .collection("orders")
          .get();

      List<Reservation> fetchedReservations = [];

      querySnapshot.docs.forEach((doc) {
        // Extract data from each document
        DateTime dateTime = (doc['dateTime'] as Timestamp).toDate();
        String photographerId = doc['photographerId'];
        String photographerName = doc['photographerName'];
        String photographerPhone = doc['photographerPhone'];
        String timeOfDay = doc['timeOfDay'];
        String userId = doc['userId'];
        String userName = doc['userName'];
        String userPhone = doc['userPhone'];

        // Create Reservation object and add to the list
        fetchedReservations.add(Reservation(
          dateTime: dateTime,
          photographerId: photographerId,
          photographerName: photographerName,
          photographerPhone: photographerPhone,
          userId: userId,
          userName: userName,
          userPhone: userPhone,
        ));
      });

      setState(() {
        reservations = fetchedReservations;
      });
    } catch (e) {
      print('Error fetching reservations: $e');
      // Handle errors here
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reservations"),
        backgroundColor: Colors.orange,
      ),
      body:

      ListView.builder(
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          final reservation = reservations[index];

          // Format date to display day/month/year
          String formattedDate = DateFormat('dd/MM/yyyy').format(
              reservation.dateTime);

          // Format time to display in 12-hour format
          // String formattedTime = DateFormat.jm().format(
          //   //DateFormat('HH:mm').parse(reservation.timeOfDay),
          // );

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              // Adjust the border radius as needed
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            child: ListTile(
              title: Text(
                  'User: ${reservation.userName}\nPhotographer: ${reservation
                      .photographerName}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: $formattedDate'),
                  Text('Photographer Phone: ${reservation.photographerPhone}'),
                  Text('User Phone: ${reservation.userPhone}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}