import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_scholar/controllers/auth_controller.dart';
import 'package:my_scholar/repositories/auth_repository/auth_repository.dart';
import 'package:my_scholar/utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final authController = Get.put(AuthController());
  final appColors = AppColors();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authController.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Add your app icon here (replace with your image path)
          Center(child: Image.asset('assets/icons/app_icon.png', height: 100,color: appColors.buttonColor,)),
          SizedBox(height: 20),
          const Text(
            'Welcome to',
            style: TextStyle(
              fontSize: 24,

            ),
          ),
          const Text(
            'The Scholar',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,

            ),
          ),



        ],
      ),
    );
  }
}
