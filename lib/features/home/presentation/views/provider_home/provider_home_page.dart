import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:wedding/core/common/custom_button.dart';
import 'package:wedding/core/utils/app_router.dart';
import 'package:wedding/features/auth/data/profile.dart';
import 'package:wedding/features/home/manager/DataFetchCubit.dart';
import 'package:wedding/features/home/presentation/services/video_picker_services.dart';
import 'package:wedding/features/home/presentation/views/provider_home/edit_page.dart';
import 'package:wedding/features/home/presentation/views/provider_home/photographer_reservations_page.dart';
import 'package:wedding/features/home/presentation/views/provider_home/widgets/videos_list_view.dart';
import '../../../manager/image_fetch_cubit.dart';
import '../../services/firebase_service.dart';
import '../../services/image_picker_services.dart';
import '../user_home/widgets/images_list_view.dart';
import '../user_home/widgets/provider_details.dart';

class ProviderHomePage extends StatefulWidget {
  const ProviderHomePage({super.key});

  @override
  State<ProviderHomePage> createState() => _ProviderHomePageState();
}

class _ProviderHomePageState extends State<ProviderHomePage> {
  final List<String> _images = [];
  final List<String> _videos = [];
  bool _uploading = false;

  void _selectImages() async {
    List<String> selectedImages = await ImagePickerService.pickImages();
    setState(() {
      _images.addAll(selectedImages);
    });
  }

  void _selectVideos() async {
    List<String> selectedVideos = await VideoPickerService.pickVideos();
    setState(() {
      _videos.addAll(selectedVideos);
    });
  }

  Future<void> _upload() async {
    setState(() {
      _uploading = true;
    });

    if (_images.isNotEmpty) {
      await FirebaseService.uploadImages(_images, profile!);
    }

    if (_videos.isNotEmpty) {
      await FirebaseService.uploadVideos(_videos, profile!);
    }
    setState(() {
      _images.clear();
      _videos.clear();
      _uploading = false;
    });
  }

  Profile? profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orangeAccent,
        title: const Text("Photographer Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                DataFetchingCubit cubit =
                    BlocProvider.of<DataFetchingCubit>(context);
                return EditProfilePage(
                  profile: profile!,
                  cubit: cubit,
                );
              }));
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return PhotographerReservationPage(
                      profile: profile!,
                    );
                  },
                ),
              );
            },
            icon: const Icon(Icons.card_travel),
          ),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              GoRouter.of(context).pushReplacement(AppRouter.KLoginPage);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      backgroundColor: Colors.white.withOpacity(0.7),
      body: SafeArea(
        child: BlocBuilder<DataFetchingCubit, Profile?>(
          builder: (context, fetchedProfile) {
            profile = fetchedProfile;
            if (profile != null) {
              return CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          ProviderDetails(profile: profile!),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomButton(
                                      status: "Select Images",
                                      onPressed: _selectImages),
                                  CustomButton(
                                      status: "Select Videos",
                                      onPressed: _selectVideos),
                                ],
                              ),
                            ),
                          ),
                          CustomButton(
                            status: _uploading ? 'Uploading...' : 'Upload',
                            onPressed: () {
                              ImageVideoCubit cubit = BlocProvider.of(context);
                              _upload();
                              cubit
                                  .fetchImageURLs(profile!.profileId.toString())
                                  .then(
                                (value) {
                                  print('done');
                                  setState(() {});
                                },
                              );
                            },
                          ),
                          if (_uploading) const LinearProgressIndicator(),
                          const Expanded(child: SizedBox(height: 30)),
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
                              ..fetchImageURLs(profile!.profileId!),
                            child:
                                ImageListView(profileId: profile!.profileId!),
                          ),
                          const SizedBox(height: 20),
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
                              ..fetchVideosUrls(profile!.profileId!),
                            child: VideoListView(
                              profileId: profile!.profileId!,
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  )
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
