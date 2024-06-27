import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding/features/auth/data/profile.dart';
import 'package:wedding/features/home/manager/PhotographersFetchCubit.dart';
import 'package:wedding/features/home/presentation/views/user_home/widgets/provider_list_view_item.dart';

class ProviderListView extends StatefulWidget {
  const ProviderListView({
    super.key,
    required this.userData,
    this.searchQuery,
  });

  final Profile userData;
  final String? searchQuery;

  @override
  _ProviderListViewState createState() => _ProviderListViewState();
}

class _ProviderListViewState extends State<ProviderListView> {
  late List<Profile> filteredProfiles;
  bool showLoading = true;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {});
    // Initially set filtered profiles to an empty list
    filteredProfiles = [];

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showLoading = false; // Hide the CircularProgressIndicator
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataFetchingPhotographersCubit, List<Profile>>(
      builder: (context, profiles) {
        // Filter profiles based on the search query
        filteredProfiles = profiles;

        if (widget.searchQuery != null && widget.searchQuery!.isNotEmpty) {
          filteredProfiles = profiles.where((profile) {
            // Customize the condition based on your search criteria
            return profile.name!
                .toLowerCase()
                .contains(widget.searchQuery!.toLowerCase());
          }).toList();
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.orangeAccent.withOpacity(0.3),
          ),
          child: _buildListView(),
        );
      },
    );
  }

  Widget _buildListView() {
    if (showLoading) {
      // Show CircularProgressIndicator while loading
      return const Center(child: CircularProgressIndicator());
    } else {
      // Show filtered profiles or a message if empty
      if (filteredProfiles.isNotEmpty) {
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: filteredProfiles.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: ProviderListViewItem(
                profile: filteredProfiles[index],
                userData: widget.userData,
              ),
            );
          },
        );
      } else {
        return const Center(
            child: Text(
          "No Photographers with this name",
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ));
      }
    }
  }
}
