import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedding/core/common/custom_button.dart';
import 'package:wedding/features/auth/data/profile.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key, required this.profile}) : super(key: key);
  final Profile profile;

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.profile.name!;
    _emailController.text = widget.profile.email!;
    _phoneController.text = widget.profile.phoneNumber!;
  }

  Future<void> _updateProfile() async {
    try {
      widget.profile.phoneNumber = _phoneController.text;
      widget.profile.name = _nameController.text;
      widget.profile.email = _emailController.text;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.profile.profileId)
          .update(
            widget.profile.toMap(),
          );
      AlertDialog(
        title: const Text("Success"),
        content: const Text('Profile updated successfully'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile page"),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(45.0),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            color: Colors.white.withOpacity(0.6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      errorStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                      hintText: "Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      fillColor: Colors.white70,
                      filled: true,
                      prefixIcon: const Icon(Icons.person)),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.amber,
                  child: ListTile(
                    leading: const Icon(Icons.email),
                    title: Center(
                      child: Text(_emailController.text),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                      errorStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                      hintText: "Phone",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      fillColor: Colors.white70,
                      filled: true,
                      prefixIcon: const Icon(Icons.phone)),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  status: "Update Profile",
                  onPressed: () => _updateProfile(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
