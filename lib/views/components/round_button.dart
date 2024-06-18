import 'package:flutter/material.dart';
import 'package:my_scholar/utils/app_colors.dart';

class RoundButton extends StatelessWidget {
  bool loading;
   String title;
  final VoidCallback onTap;
   RoundButton({super.key,required this.title,required this.onTap,this.loading = false});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double designHeight = 812.0;
    double designWidth = 375.0;
    double hsf = screenHeight / designHeight;
    double wsf = screenWidth / designWidth;
    final appColors = AppColors();




    return GestureDetector(
        onTap: loading ? null : onTap,
        child: Container(
          alignment: Alignment.topRight,
          width: 330*wsf,
          height: 50*wsf,
          decoration: BoxDecoration(
              color: appColors.buttonColor,
              borderRadius: BorderRadius.circular(12)),
          child:  Center(
              child: loading ? const CircularProgressIndicator(color: Colors.white,) : Text(
                title,
                style:  TextStyle(color: Colors.white,fontSize: 21*hsf),
              )),
        ),

      );

  }
}
