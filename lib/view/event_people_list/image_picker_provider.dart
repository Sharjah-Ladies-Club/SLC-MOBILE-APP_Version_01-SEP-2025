import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerProvider {
  final ImagePicker _picker = new ImagePicker();
  var pickFile;

  Future<File> getImage() async {
    File image = null;
    //
    // await ImagePicker.platform
    //     .pickImage(
    //         source: ImageSource.gallery, maxWidth: 300.0, maxHeight: 400.0)
    //     .then((value) {
    //   image = File(value.path);
    // // });
    XFile pickFile = await _picker.pickImage(source: ImageSource.gallery);
    // XFile pickFile = await _picker.pickImage(
    //   source: ImageSource.gallery,
    //   maxWidth: 400,
    //   maxHeight: 300,
    //   imageQuality: 50,
    // );
    image = File(pickFile.path);
    print("GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG" + pickFile.path);
    return image;
  }

  Future<File> takeImage() async {
    File image = null;
    //
    // await ImagePicker.platform
    //     .pickImage(
    //         source: ImageSource.gallery, maxWidth: 300.0, maxHeight: 400.0)
    //     .then((value) {
    //   image = File(value.path);
    // // });
    XFile pickFile = await _picker.pickImage(source: ImageSource.camera);
    // XFile pickFile = await _picker.pickImage(
    //   source: ImageSource.gallery,
    //   maxWidth: 400,
    //   maxHeight: 300,
    //   imageQuality: 50,
    // );
    image = File(pickFile.path);
    print("GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG" + pickFile.path);
    return image;

    // File image = null;
    // await ImagePicker.platform
    //     .pickImage(
    //         source: ImageSource.camera, maxWidth: 300.0, maxHeight: 400.0)
    //     .then((value) {
    //   image = File(value.path);
    // });
    // return image;
  }
}
