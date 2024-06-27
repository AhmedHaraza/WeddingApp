import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../../constants.dart';
import '../../../../../../../core/common/custom_button.dart';
import '../../../../../../../core/common/custom_text_feild.dart';
import '../../../../../../../core/utils/styles.dart';
import '../../../../../data/profile.dart';
import '../../../../../manager/auth_cubit/auth_cubit.dart';
import 'custom_drop_down.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class SignUpPhotographerForm2 extends StatefulWidget {
  SignUpPhotographerForm2(
      {super.key,
      required this.email,
      required this.password,
      required this.name,
      required this.phoneNumber});

  final String email;

  final String password;

  final String name;
  final String phoneNumber;
  late String imageUrl;

  @override
  State<SignUpPhotographerForm2> createState() =>
      _SignUpPhotographerForm2State();
}

class _SignUpPhotographerForm2State extends State<SignUpPhotographerForm2> {
  String address = "";
  String governement = "";
  String gender = "";
  String date = "";
  String price = "";

  DateTime selectedDate = DateTime.now();
  String? selectedImagePath;
  final TextEditingController dateController = TextEditingController(
    text: "mm/dd/yyyy",
  );
  File? _image;
  String _imageUrl = "";

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() async {
        _image = File(pickedFile.path);
        _imageUrl = await _uploadImage();
      });
      print('Image picked: ${_image!.path}');
    } else {
      print("No image selected");
    }
  }

  Future<String> _uploadImage() async {
    if (_image == null) {
      print('No image selected');
      return ''; // or throw an exception based on your requirements
    }

    try {
      String fileExtension = _image!.path.split('.').last;
      String fileName = '${widget.name}.$fileExtension';

      Reference storageReference =
          FirebaseStorage.instance.ref('profilePics/').child(fileName);
      UploadTask uploadTask = storageReference.putFile(_image!);

      Completer<String> completer = Completer<String>();

      uploadTask.snapshotEvents.listen(
        (TaskSnapshot snapshot) {
          print(
              'Upload progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
        },
        onError: (Object e) {
          print('Error during upload: $e');
          completer.completeError(e.toString());
        },
        onDone: () async {
          try {
            String imageUrl = await storageReference.getDownloadURL();
            print('Image uploaded. URL: $imageUrl');
            completer.complete(imageUrl);
          } catch (e) {
            print('Error getting download URL: $e');
            completer.completeError(e.toString());
          }
        },
      );

      return completer.future;
    } catch (e) {
      print('Error uploading image: $e');
      throw e; // Propagate the exception
    }
  }

  Future<void> addUserToFirestore(
      String name,
      String email,
      String phoneNumber,
      String photographerId,
      String gover,
      String address,
      String date,
      String gender,
      String imageUrl,
      String price) async {
    Profile profile = Profile(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        profileId: photographerId,
        gender: gender,
        governorate: gover,
        birthDate: date,
        profilePic: imageUrl,
        address: address,
        authorization: "photographer",
        price: price);
    Map<String, dynamic> profileMap = profile.toMap();

    try {
      await FirebaseFirestore.instance
          .collection('photographers')
          .doc(photographerId)
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
      if (_imageUrl.isNotEmpty) {
        try {
          // Create user in Firebase Authentication
          User? user = await context
              .read<AuthenticationCubit>()
              .signUpWithEmailAndPassword(widget.email, widget.password);

          if (user != null) {
            // Use the user's ID to store additional information in Firestore
            final userId = user.uid;

            await addUserToFirestore(
                widget.name,
                widget.email,
                widget.phoneNumber,
                userId,
                governement,
                address,
                dateController.text,
                gender,
                _imageUrl,
                price);

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
          title: "Image",
          desc: "Must be select Image",
          btnCancelOnPress: () {},
        ).show();
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

  Widget buildAvatar() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
            child: _image != null
                ? ClipOval(
                    child: Image.file(
                      _image!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(
                    Icons.person,
                    size: 50,
                  ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
              onPressed: () {
                _pickImage();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildAvatar(),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(8.0, 4, 8, 8),
                          child:
                              Text("Governorate", style: Styles.kTextStyle18),
                        ),
                        DropDownButtonAuth(
                          list: const ["Giza", "Cairo", "Alexandria"],
                          onChanged: (value) {
                            governement = value;
                          },
                          icon: const Icon(Icons.location_on),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child:
                              Text("Your address", style: Styles.kTextStyle18),
                        ),
                        CustomTextField(
                          hint: "address",
                          secure: false,
                          icon: const Icon(Icons.location_city),
                          type: TextInputType.multiline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "address is required";
                            } else {
                              address = value;
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("BirthDate", style: Styles.kTextStyle18),
                        ),
                        GestureDetector(
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );

                              if (pickedDate != null &&
                                  pickedDate != selectedDate) {
                                setState(() {
                                  selectedDate = pickedDate;
                                  // You can format the date as needed
                                  dateController.text =
                                      "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";
                                });
                              }
                            },
                            child: Container(
                              color: Colors.white70,
                              child: Row(
                                children: [
                                  const Icon(Icons.date_range),
                                  const SizedBox(width: 8),
                                  // Adjust the spacing as needed
                                  Expanded(
                                    child: TextFormField(
                                      decoration: Constant.paymentDecoration
                                          .copyWith(
                                              fillColor: Colors.transparent),
                                      controller: dateController,
                                      enabled: false,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(
                          height: 8,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Gender", style: Styles.kTextStyle18),
                        ),
                        DropDownButtonAuth(
                          list: const ["Male", "Female"],
                          onChanged: (value) {
                            gender = value;
                          },
                          icon: const Icon(Icons.person_2),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomTextField(
                          hint: "Price",
                          secure: false,
                          icon: const Icon(Icons.currency_pound_outlined),
                          type: TextInputType.multiline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "price is required";
                            } else {
                              price = value;
                              return null;
                            }
                          },
                        ),
                      ],
                    ),
                    CustomButton(
                        status: "Sign Up",
                        onPressed: () {
                          navigate(context);
                        }),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
