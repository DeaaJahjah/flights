import 'dart:io';
import 'package:image_picker/image_picker.dart';

class FilesPicker {
  Future<File?> pickImage() async {
    final picker = ImagePicker();
    XFile? pickedimage;
    File? imageFile;
    try {
      pickedimage = await picker.pickImage(source: ImageSource.gallery);

      imageFile = File(pickedimage!.path);
      return imageFile;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
