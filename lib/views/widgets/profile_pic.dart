import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_scholar/controllers/auth_controller.dart';
import 'package:photo_view/photo_view.dart';

import '../../utils/utils.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({super.key});

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  File? _image;
  final picker = ImagePicker();
  bool isImagePicked = false;
  final authController = Get.put(AuthController());
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    pickImage();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(isImagePicked){
      return Stack(
        children: [
          // PhotoView in the background
          Positioned.fill(
            child: PhotoView(
              imageProvider: FileImage(_image!),
              minScale: PhotoViewComputedScale
                  .contained, // Minimum scale set to contained size
              maxScale: PhotoViewComputedScale.covered *
                  3, // Maximum scale set to thrice the covered size
            ),
          ),
          // Close button at the top left
          Positioned(
            top: 40.0,
            left: 10.0,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          // Done button at the top right
          Positioned(
            bottom: 20,
            right: 16.0,
            child: Obx((){
              return    ElevatedButton(
                onPressed: () {
                  authController.updateProfilePic(_image, auth.currentUser!.uid,context);
                },
                // style: ElevatedButton.styleFrom(
                // backgroundColor:  // Button background color
                // ),
                child: authController.profilePicLoading.value ? const CircularProgressIndicator() :  const Text('Done'),
              );
    })

          ),
        ],
      );
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
