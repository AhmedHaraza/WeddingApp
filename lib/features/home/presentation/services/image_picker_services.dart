import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  static Future<List<String>> pickImages() async {
    List<String> selectedImages = [];
    List<XFile> xFiles = await ImagePicker().pickMultiImage();
    if (xFiles != null) {
      for (var file in xFiles) {
        selectedImages.add(file.path);
      }
    }
    return selectedImages;
  }

 
}
