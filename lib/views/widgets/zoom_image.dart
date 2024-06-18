import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class ZoomImage extends StatelessWidget {
  final File? image;
   const ZoomImage({super.key,required this.image});

  @override
  Widget build(BuildContext context) {


   return Scaffold(
       backgroundColor: Colors.white,
       body: Stack(
         children: [
           // PhotoView in the background
           Positioned.fill(
             child: PhotoView(
               imageProvider: FileImage(image!),
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
             child: ElevatedButton(
               onPressed: () {

                 Get.offAndToNamed('/ImagePost',arguments: {
                   'image' : image
                 });
               },
               // style: ElevatedButton.styleFrom(
               // backgroundColor:  // Button background color
               // ),
               child: const Text('Done'),
             ),
           ),
         ],
       ));
  }
}
