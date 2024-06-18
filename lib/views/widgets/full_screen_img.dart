import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImg extends StatelessWidget {
  String? image = Get.arguments['url'];
   FullScreenImg({super.key});

  @override
  Widget build(BuildContext context) {

    return Stack(
        children: [
          // PhotoView in the background
          Positioned.fill(
            child: PhotoView(
              imageProvider:  image != null
                  ? NetworkImage(image!)
                  : const AssetImage('assets/icons/profile_user2.png') as ImageProvider,
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
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )]);
  }
}
