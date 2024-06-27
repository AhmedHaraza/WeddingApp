import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wedding/features/auth/data/profile.dart';

import '../../../data/reservation.dart';

class PhotographerReservationPage extends StatefulWidget {
  const PhotographerReservationPage({super.key, required this.profile});
  final Profile profile;
  @override
  State<PhotographerReservationPage> createState() =>
      _PhotographerReservationPageState();
}

class _PhotographerReservationPageState
    extends State<PhotographerReservationPage> {
  List<Reservation> reservations = [];
  FirebaseFirestore querySnapshot = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    fetchReservations();
  }

  Future<void> fetchReservations() async {
    try {
      // Access Firestore collection 'reservations'
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('photographers')
          .doc(widget.profile.profileId)
          .collection("orders")
          .get();
      List<Reservation> fetchedReservations = [];

      for (var doc in querySnapshot.docs) {
        // Extract data from each document
        DateTime dateTime = (doc['dateTime'] as Timestamp).toDate();
        String photographerId = doc['photographerId'];
        String photographerName = doc['photographerName'];
        String photographerPhone = doc['photographerPhone'];
        //String timeOfDay = doc['timeOfDay'];
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
      }

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
      body: ListView.builder(
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          final reservation = reservations[index];

          // Format date to display day/month/year
          String formattedDate =
              DateFormat('dd/MM/yyyy').format(reservation.dateTime);

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
                  'User: ${reservation.userName}\nPhotographer: ${reservation.photographerName}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: $formattedDate'),
                  //Text('Time: $formattedTime'), // Display formatted time
                  Text('Photographer Phone: ${reservation.photographerPhone}'),
                  Text('User Phone: ${reservation.userPhone}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(onPressed: () {}, child: const Text("Accept")),
                      TextButton(
                          onPressed: () {
                            rejectOrder(reservation.photographerId, reservation.photographerId);
                          },
                          child: const Text("Reject")),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Future<void> deleteDocument(String id, String id2, BuildContext context) async {
  try {
    await FirebaseFirestore.instance
        .collection('photographers')
        .doc(id)
        .collection("orders")
        .doc(id2)
        .delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document deleted successfully')),
    );
  } catch (e) {
    print('Error deleting document: $e');
  }
}

void rejectOrder(String photographerId, String orderId) async {
  try {
    // الوصول إلى ال-collection الخاص بال-orders ثم ال-document المحدد
    await FirebaseFirestore.instance
        .collection('photographer')
        .doc(photographerId)
        .collection('orders')
        .doc(photographerId)
        .delete();
    print('Order rejected and deleted successfully');
  } catch (e) {
    print('Error rejecting order: $e');
  }
}
