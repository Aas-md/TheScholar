import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_scholar/utils/utils.dart';
import 'package:my_scholar/views/widgets/zoom_image.dart';

class CameraPick extends StatefulWidget {
  const CameraPick({super.key});

  @override
  State<CameraPick> createState() => _CameraPickState();
}

class _CameraPickState extends State<CameraPick> {
  File? _image;
  final picker = ImagePicker();
  bool _isImagePicked = false;
  @override
  void initState() {
    pickImage();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if (!_isImagePicked) {
      return  Scaffold(
        body: Center(
          child: Container(), // Show loading indicator while picking image
        ),
      );
    } else {
      return ZoomImage(image: _image!); // Pass _image only when it's not null
    }
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _isImagePicked = true;
      } else {
        // Navigate back to home screen if image is not picked
        Navigator.pop(context);
        Utils.showSnackbar('Image was not picked');
      }
    });
  }
}

