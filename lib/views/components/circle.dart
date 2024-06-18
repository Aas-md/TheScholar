import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class CircleRound extends StatelessWidget {
  const CircleRound({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // Define the design dimensions
    double designHeight = 812.0;
    double designWidth = 375.0;

    // Calculate the scale factors
    double hsf = screenHeight / designHeight;
    double wsf = screenWidth / designWidth;
    final appColors = AppColors();
    return   Stack(
      children:[ Container(
        height: 106*hsf,
        width: 106*wsf,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(50),
          color: Color(0xffD9D9D9),
            shape: BoxShape.circle,
            border: Border.all(
              color: appColors.orangeColor, // Change this to your desired color
              width: 3.0,

            )
        ),

      ),
        Padding(
          padding: const EdgeInsets.all(27),
          child: Icon(
            Icons.check, // Use the check icon
            size: 50.0, // Adjust the size as needed
            color: appColors.orangeColor, // Change this to your desired color
          ),
        ),
    ]
    );
  }
}
