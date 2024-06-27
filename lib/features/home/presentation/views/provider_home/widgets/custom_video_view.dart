import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wedding/features/home/manager/image_fetch_cubit.dart';
import 'package:wedding/features/home/presentation/views/provider_home/video_dispaly_page.dart';

import '../../../../../../core/utils/assets.dart';

class CustomVideoView extends StatelessWidget {
  final String url;
  final ImageVideoCubit cubit;
  final String userId;

  const CustomVideoView(
      {super.key,
      required this.url,
      required this.cubit,
      required this.userId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DisplayVideo(
                url: url,
              );
            },
          ),
        );
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          SizedBox(
            child: AspectRatio(
              aspectRatio: 3.8 / 4,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(AssetsData.testImage),
                  ),
                ),
              ),
            ),
          ),
          Align(
            widthFactor: 0.5,
            heightFactor: 0.5,
            child: IconButton(
              onPressed: () {
                _showDialog(context);
              },
              icon: Container(
                color: Colors.grey,
                child: const Icon(
                  FontAwesomeIcons.remove,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentTextStyle: const TextStyle(fontSize: 18, color: Colors.black),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(13.0),
            ),
          ),
          content: const Text("are you sure you want to delete this image?"),
          actions: [
            MaterialButton(
              onPressed: () {
                cubit.deleteVideo(url.split('#')[1], userId).then(
                  (value) {
                    Navigator.pop(context);
                  },
                );
              },
              child: const Text("Yes"),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }
}
