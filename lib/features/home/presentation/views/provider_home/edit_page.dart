import 'package:flutter/material.dart';
import 'package:wedding/core/common/custom_text_feild.dart';
import 'package:wedding/features/auth/data/profile.dart';
import 'package:wedding/features/home/manager/DataFetchCubit.dart';

class EditProfilePage extends StatefulWidget {
  final Profile profile;
  final DataFetchingCubit cubit;

  const EditProfilePage(
      {super.key, required this.profile, required this.cubit});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _price = TextEditingController();

  String name = "", phone = "", address = "", price = "";

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.profile.name ?? '';
    _phoneNumberController.text = widget.profile.phoneNumber ?? '';
    _address.text = widget.profile.address ?? '';
    _price.text = widget.profile.price ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: _nameController,
              hint: "Name",
              secure: false,
              icon: const Icon(Icons.person),
              type: TextInputType.name,
              validator: (value) {
                name = value!;
                return null;
              },
            ),
            const SizedBox(height: 10,),
            CustomTextField(
              controller: _phoneNumberController,
              hint: "PhoneNumber",
              secure: false,
              icon: const Icon(Icons.phone),
              type: TextInputType.phone,
              validator: (value) {
                phone = value!;
                return null;
              },
            ),
            const SizedBox(height: 10,),
            CustomTextField(
              controller: _address,
              hint: "Address",
              secure: false,
              icon: const Icon(Icons.location_city),
              type: TextInputType.text,
              validator: (value) {
                address = value!;
                return null;
              },
            ),
            const SizedBox(height: 10,),
            CustomTextField(
              controller: _price,
              hint: "price",
              secure: false,
              icon: const Icon(Icons.price_change),
              type: TextInputType.phone,
              validator: (value) {
                price = value!;
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.cubit.updateProfile(
                  widget.profile,
                  _nameController.text.trim(),
                  _phoneNumberController.text.trim(),
                  _address.text.trim(),
                  _price.text.trim(),
                  context,
                );
              },
              child: const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }

// Future<void> _updateProfile() async {
//   try {
//     widget.profile.name = _nameController.text.trim();
//     widget.profile.phoneNumber = _phoneNumberController.text.trim();
//     widget.profile.address = _address.text.trim();
//     widget.profile.price = _price.text.trim();
//
//     await FirebaseFirestore.instance
//         .collection('photographers')
//         .doc(widget.profile.profileId)
//         .update(widget.profile.toMap())
//         .then(
//       (value) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Profile updated successfully'),
//             duration: Duration(seconds: 2),
//           ),
//         );
//       },
//     );
//   } catch (error) {
//     print(error);
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Failed to update profile'),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }
// }
}