import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_scholar/utils/utils.dart';
import 'package:my_scholar/views/widgets/zoom_image.dart';

class PickPrevImage extends StatefulWidget {
  const PickPrevImage({super.key});

  @override
  State<PickPrevImage> createState() => _PickPrevImageState();
}

class _PickPrevImageState extends State<PickPrevImage> {
  File? _image;
  final picker = ImagePicker();
  bool isImagePicked = false;

  @override
  void initState() {
    pickImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(isImagePicked){
      return ZoomImage(image: _image);
    }else{
      return Center(child: Container(),);
    }
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        isImagePicked = true;
      } else {
        // Navigate back to home screen if image is not picked
        Navigator.pop(context);
        Utils.showSnackbar('Image was not picked');
      }
    });
  }
}
