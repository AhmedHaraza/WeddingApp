import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:wedding/features/auth/data/profile.dart';
import 'package:wedding/features/home/presentation/views/user_home/pages/user_profile_page.dart';
import 'package:wedding/features/home/presentation/views/user_home/pages/user_reservations_page.dart';
import 'package:wedding/features/home/presentation/views/user_home/widgets/custom_app_bar.dart';
import 'package:wedding/features/home/presentation/views/user_home/widgets/provider_list_view.dart';

import '../../../../../../core/utils/app_router.dart';
import '../../../../../../core/utils/assets.dart';
import '../../../../manager/DataFetchCubit.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key, required this.userId});

  final String? userId;

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  Profile? profile;
  String? searchQuery;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orangeAccent,
        title: const Text(
          "Wedding",
          style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontFamily: AssetsData.Dancing,
              color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return UserProfilePage(
                      profile: profile!,
                    );
                  },
                ),
              );
            },
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.circleInfo,
              color: Colors.white,
            ),
            onPressed: () {
              GoRouter.of(context).push(AppRouter.KAboutUs);
            },
          ),
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.contactCard,
              color: Colors.white,
            ),
            onPressed: () {
              GoRouter.of(context).push(AppRouter.kContactUs);
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return UserResrvationPage(
                      profile: profile!,
                    );
                  },
                ),
              );
            },
            icon: const Icon(
              Icons.card_travel,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              GoRouter.of(context).pushReplacement(AppRouter.KLoginPage);
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: BlocBuilder<DataFetchingCubit, Profile?>(
        builder: (context, fetchProfile) {
          profile = fetchProfile;
          if (fetchProfile != null) {
            return Column(
              children: [
                CustomAppBar(
                  onSearch: (query) {
                    setState(
                      () {
                        searchQuery = query;
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 18,
                ),
                Expanded(
                  child: ProviderListView(
                    userData: fetchProfile,
                    searchQuery: searchQuery,
                  ),
                ),
              ],
            );
          } else {
            // Handle the case when fetchProfile is null
            return const Center(
              child:
                  CircularProgressIndicator(), // Or any other loading indicator
            );
          }
        },
      ),
    );
  }
}
