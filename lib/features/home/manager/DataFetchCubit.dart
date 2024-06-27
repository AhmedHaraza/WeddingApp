import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/data/profile.dart';

class DataFetchingCubit extends Cubit<Profile?> {
  DataFetchingCubit() : super(null);

  void fetchDataPhotographer(String photographerId) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('photographers')
          .doc(photographerId)
          .get();
      if (docSnapshot.exists) {
        Profile profile = Profile.fromFirestore(docSnapshot);
        emit(profile);
      } else {
        emit(null);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateProfile(Profile profile, String name, String phone,
      String address, String price, BuildContext context) async {
    try {
      profile.name = name;
      profile.phoneNumber = phone;
      profile.address = address;
      profile.price = price;

      await FirebaseFirestore.instance
          .collection('photographers')
          .doc(profile.profileId)
          .update(profile.toMap())
          .then(
        (value) {
          fetchDataPhotographer(profile.profileId.toString());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      );
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void fetchDataUser(String userId) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (docSnapshot.exists) {
        Profile profile = Profile.fromFirestore(docSnapshot);
        emit(profile);
      } else {
        emit(null);
      }
    } catch (e) {
      print(e);
    }
  }
}
