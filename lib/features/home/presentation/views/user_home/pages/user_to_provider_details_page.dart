import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wedding/core/common/payment_dialog.dart';
import 'package:wedding/features/auth/data/profile.dart';
import 'package:wedding/features/home/presentation/views/provider_home/widgets/videos_list_view.dart';
import 'package:wedding/features/home/presentation/views/user_home/widgets/images_list_view.dart';
import 'package:wedding/features/home/presentation/views/user_home/widgets/provider_details.dart';

import '../../../../manager/image_fetch_cubit.dart';

void _showPaymentDialog(BuildContext context, Profile userData,
    Profile photographerData, DateTime selectedDate, TimeOfDay selectedTime) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return PaymentDialog(
        userData: userData,
        photographerData: photographerData,
        selectedDate: selectedDate,
        selectedTime: selectedTime,
      );
    },
  ).then((selectedPayment) {
    if (selectedPayment != null) {
      // Handle the selected payment method
      print('Selected Payment Method: $selectedPayment');
    }
  });
}

class UserToProviderDetailsPage extends StatelessWidget {
  const UserToProviderDetailsPage(
      {super.key, required this.photographerData, required this.userData});

  final Profile photographerData;
  final Profile userData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Photographer Details"),
        backgroundColor: Colors.orangeAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              icon: const Icon(FontAwesomeIcons.calendarCheck),
              onPressed: () async {
                await _selectDateTime(context);
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white.withOpacity(0.7),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    //BooksDetailsSection(),
                    ProviderDetails(
                      profile: photographerData,
                    ),
                    const Expanded(
                      child: SizedBox(
                        height: 40,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Images",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),

                    BlocProvider(
                      create: (context) => ImageVideoCubit()
                        ..fetchImageURLs(photographerData.profileId!),
                      child:
                          ImageListView(profileId: photographerData.profileId!),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Videos",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    BlocProvider(
                      create: (context) => ImageVideoCubit()
                        ..fetchVideosUrls(photographerData.profileId!),
                      child:
                          VideoListView(profileId: photographerData.profileId!),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    _showPaymentDialog(
      context,
      userData,
      photographerData,
      selectedDate,
      selectedTime,
    );
  }
}
