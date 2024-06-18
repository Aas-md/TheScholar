import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:my_scholar/views/components/circle.dart';
import 'package:my_scholar/views/components/round_button.dart';

import '../../utils/app_colors.dart';

class OtpSuccessView extends StatefulWidget {
  const OtpSuccessView({super.key});

  @override
  State<OtpSuccessView> createState() => _OtpSuccessViewState();
}

class _OtpSuccessViewState extends State<OtpSuccessView> {
  @override
  Widget build(BuildContext context) {
    // print(otpController.text.toString());
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // Define the design dimensions
    double designHeight = 812.0;
    double designWidth = 375.0;

    // Calculate the scale factors
    double hsf = screenHeight / designHeight;
    double wsf = screenWidth / designWidth;
    final appColors = AppColors();
    return Scaffold(
        backgroundColor: appColors.backgroundColor,
        resizeToAvoidBottomInset: false,
        body:  SafeArea(
        child: Column(

          children: [
            Padding(
              padding:  EdgeInsets.only(top: 70*hsf),
              child: const Center(child: CircleRound()),
            ),
            Padding(
              padding: EdgeInsets.only(top: 55*hsf),
              child: const Text('Success',style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 22),),
            ),
            Padding(
              padding:  EdgeInsets.only(left: 25*wsf,top: 12*hsf,right: 37*wsf),
              child: Text('Congratulations! You have been successfully authenticated',
              style: TextStyle(color: appColors.borderColor,fontSize: 18),
              textAlign: TextAlign.center,),
            ),
            Padding(
              padding: EdgeInsets.only(top: 71*hsf),
              child: RoundButton(title: 'Continue', onTap: (){

                Get.offAndToNamed('/HomeScreen');
              }),
            )

          ],
        )
    )
    );
  }
}
