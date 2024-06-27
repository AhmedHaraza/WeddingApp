import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wedding/features/auth/manager/auth_cubit/auth_cubit.dart';
import 'package:wedding/features/auth/manager/auth_cubit/auth_state.dart';
import 'package:wedding/features/home/manager/image_fetch_cubit.dart';
import 'package:wedding/features/home/presentation/views/user_home/widgets/maxmize_image.dart';

class CustomImagesWedding extends StatelessWidget {
  const CustomImagesWedding({
    super.key,
    required this.url,
    required this.cubit,
    required this.userId,
  });

  final String userId;
  final ImageVideoCubit cubit;
  final String url;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MaxmizeImage(
                        url: url.split('#')[0],
                      );
                    },
                  ),
                );
              },
              child: SizedBox(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 3.8 / 4,
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: url.split('#')[0],
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
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
                  child: context is AuthenticationSuccessPhotographer ?? true ? const Icon(
                    FontAwesomeIcons.remove,
                    color: Colors.white,
                  ) : null,
                ),
              ),
            ),
          ],
        );
      },
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
                if (context is AuthenticationSuccessPhotographer) {
                  cubit.deleteImage(url.split('#')[1], userId).then(
                    (value) {
                      Navigator.pop(context);
                    },
                  );
                } else {
                  Navigator.pop(context);
                }
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
