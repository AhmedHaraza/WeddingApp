import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  String? name;
  String? password;
  String? phoneNumber;
  String? email;
  String? profileId;
  String? gender;
  String? address;
  String? governorate;
  String? birthDate;
  String? profilePic;
  String? authorization;
  String? price;

  Profile(
      {this.name,
      this.password,
      this.phoneNumber,
      this.email,
      this.profileId,
      this.gender,
      this.address,
      this.governorate,
      this.birthDate,
      this.profilePic,
      this.price,
      this.authorization});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'photographerId': profileId,
      'gender': gender,
      'address': address,
      'governorate': governorate,
      'birthDate': birthDate,
      'profilePic': profilePic,
      'authorization': authorization,
      'price': price
    };
  }

  factory Profile.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Profile(
        name: data['name'],
        password: data['password'],
        phoneNumber: data['phoneNumber'],
        email: data['email'],
        profileId: data['photographerId'],
        gender: data['gender'],
        address: data['address'],
        governorate: data['governorate'],
        birthDate: data['birthDate'],
        profilePic: data['profilePic'],
        authorization: data['authorization'],
        price: data['price']);
  }
}
