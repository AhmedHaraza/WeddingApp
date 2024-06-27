import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding/features/home/presentation/views/provider_home/widgets/custom_video_view.dart';

import '../../../../manager/image_fetch_cubit.dart';

class VideoListView extends StatelessWidget {
  const VideoListView({super.key, required this.profileId});

  final String profileId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .3,
      child: BlocBuilder<ImageVideoCubit, List<String>>(
        builder: (context, state) {
          ImageVideoCubit cubit = BlocProvider.of<ImageVideoCubit>(context);
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CustomVideoView(
                  url: state[index],
                  cubit: cubit,
                  userId: profileId,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
