import 'package:image_picker/image_picker.dart';

class VideoPickerService {
  static Future<List<String>> pickVideos() async {
    List<String> selectedVideos = [];
    final XFile? xFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (xFile != null) {
      selectedVideos.add(xFile.path);
    }
    return selectedVideos;
  }
}
