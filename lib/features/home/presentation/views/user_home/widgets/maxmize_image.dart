import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wedding/core/utils/assets.dart';
class MaxmizeImage extends StatelessWidget {
  const MaxmizeImage({super.key, required this.url});
  final String url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: GestureDetector(
        onTap: () {
          GoRouter.of(context).pop(); // Go back to the previous screen when tapping on the image
        },
        child: Hero(
          tag: AssetImage(AssetsData.testImage),
          child: Center(
            child:CachedNetworkImage(imageUrl: url,
              fit: BoxFit.fill,
              errorWidget:(context,url,error)=> const Icon(Icons.error , color: Colors.red,),
            )
          ),
        ),
      ),
    );
  }
}
