import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageVideoCubit extends Cubit<List<String>> {
  ImageVideoCubit() : super([]);

  Future<void> fetchImageURLs(String id) async {
    try {
      final images = await FirebaseFirestore.instance
          .collection('photographers')
          .doc(id)
          .collection("images")
          .get();
      final urls = images.docs.map((doc) {
        return '${doc.data()['url']}#${doc.id}';
      }).toList();
      emit(urls);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> deleteImage(String imageId, String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('photographers')
          .doc(userId)
          .collection('images')
          .doc(imageId)
          .delete()
          .then(
        (value) {
          fetchImageURLs(userId);
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchVideosUrls(String id) async {
    try {
      final videos = await FirebaseFirestore.instance
          .collection('photographers')
          .doc(id)
          .collection("videos")
          .get();
      final urls =
          videos.docs.map((doc) {
            return '${doc.data()['url']}#${doc.id}';
          }).toList();
      emit(urls);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> deleteVideo(String videoId, String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('photographers')
          .doc(userId)
          .collection('videos')
          .doc(videoId)
          .delete()
          .then(
            (value) {
          fetchVideosUrls(userId);
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
