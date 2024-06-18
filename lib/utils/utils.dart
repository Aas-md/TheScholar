import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:my_scholar/utils/app_colors.dart';


class Utils {

  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }


  static void showSnackbar(String message, {String title = 'Error'}) {
    final appColors = AppColors();
    Get.snackbar(
      title, // Title of the Snackbar
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: appColors.buttonColor,
      // Background color of the Snackbar
      colorText: Colors.white,
      // Text color of the Snackbar
      borderRadius: 10,
      // Border radius of the Snackbar
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
    );
  }


  static int getRandomNumber() {
    Random random = Random();

    // Generate a random number between 100 and 999
    int randomNumber = 100 + random.nextInt(900);

    return randomNumber;
  }


 static String timeAgo(int timestampInMilliseconds) {

    final now = DateTime.now().toUtc();
    final difference = now.difference(
        DateTime.fromMillisecondsSinceEpoch(timestampInMilliseconds).toUtc());
    final seconds = difference.inSeconds.abs();

    if (seconds <= 45) {
      return 'just now';
    } else if (seconds < 60) {
      return '$seconds second${seconds > 1 ? 's' : ''} ago';
    } else if (seconds < 3600) {
      final minutes = (seconds / 60).floor();
      return '$minutes minute${minutes > 1 ? 's' : ''} ago';
    } else if (seconds < 86400) {
      final hours = (seconds / 3600).floor();
      return '$hours hour${hours > 1 ? 's' : ''} ago';
    } else if (seconds < 604800) {
      final days = (seconds / 86400).floor();
      return '$days day${days > 1 ? 's' : ''} ago';
    } else if (seconds < 2592000) {
      final weeks = (seconds / 604800).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (seconds < 31536000) {
      final months = (seconds / 2592000).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (seconds / 31536000).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }


}


  static double calculateFontSize(String text) {
    // Define your logic to calculate font size based on text length
    // For example, you can set a threshold length and adjust the font size accordingly
    if (text.length > 50) {
      return 14; // Set smaller font size for longer text
    } else {
      return 20; // Set larger font size for shorter text
    }
  }


}
