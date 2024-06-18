import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_scholar/controllers/auth_controller.dart';
import 'package:my_scholar/views/components/round_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../utils/app_colors.dart';

class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView({super.key});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  final otpController = TextEditingController();
  final appColors = AppColors();
  final verificationId = Get.arguments['id'];
  final name = Get.arguments['name'];
  final authController = Get.put(AuthController());

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    otpController.dispose();
  }

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
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 127 * hsf, right: 149 * wsf, bottom: 10 * hsf),
                child: Text(
                  'Verification Code',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22 * hsf,
                      color: const Color(0xff323232)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 38 * wsf, top: 0),
                child: Text(
                  'We have sent the verification code to your phone number',
                  style: TextStyle(
                      color: const Color(0xffB6B6B6), fontSize: 18 * hsf),
                ),
              ),

              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 15*wsf,vertical: 28*hsf),
                child: PinCodeTextField(
                  appContext: context,
                  length: 6,
                  obscureText: false,
                  controller: otpController,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  cursorColor: appColors.borderColor,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 40,
                    fieldWidth: 40,
                    activeFillColor:  appColors.backgroundColor,
                    selectedFillColor: appColors.backgroundColor,
                    inactiveFillColor:  appColors.backgroundColor,
                    inactiveColor: appColors.borderColor,
                    activeColor: appColors.buttonColor,
                    selectedColor: Colors.green,

                  ),

                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  onCompleted: (v) {
                    if (kDebugMode) {
                      print("Completed: $v");
                    }
                  },
                  onChanged: (value) {
                    if (kDebugMode) {
                      print('on change $value');
                    }
                  },
                  beforeTextPaste: (text) {
                    return true;
                  },
                )
              ),

              Padding(
                padding:  EdgeInsets.only(top: 28*hsf),
                child :  Obx((){
                  return  RoundButton(title: 'Continue',
                      loading: authController.loadingPhone.value,onTap: (){
                        authController.verifyOTP(otpController,verificationId,name.toString());

                      });
                })

              )
            ],
          ),
        ));
  }


}
