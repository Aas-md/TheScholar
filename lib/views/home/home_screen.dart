import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_scholar/utils/app_colors.dart';
import 'package:my_scholar/views/home/home_view.dart';
import 'package:my_scholar/views/home/like_screen.dart';
import 'package:my_scholar/views/home/notification_screen.dart';
import 'package:my_scholar/views/home/profile_screen.dart';
import '../widgets/dialog_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final appColors = AppColors();


  static const List<Widget> _widgetOptions = <Widget>[
    HomeView(),
   LikeScreen(),
    Text('Add Screen Screen'),
    Text('Add Screen Screen'),
   NotificationScreen()
  ];

  void onSelected(int index) {

    if(index == 2){

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => SimpleDialogBox(),
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
      );
    }else if(index == 3){
//
//       Get.to(const ProfileScreen(),arguments: {
//         'uid' : FirebaseAuth.instance.currentUser!.uid
//       },
// transition: Transition.rightToLeft
//       );


      Get.toNamed('ProfileScreen',arguments: {
        'uid' : FirebaseAuth.instance.currentUser!.uid
      },
      );
    }else{
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    return Transform.translate(
      offset: const Offset(0, 0),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.transparent : appColors.bottomNavBar.withOpacity(0.60),

          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.symmetric(vertical: isSelected ? 15 : 0),

        child: Icon(icon,
            color: isSelected ? Colors.black : Colors.white, size: 30),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double designHeight = 812.0;
    double designWidth = 375.0;
    double hsf = screenHeight / designHeight;
    double wsf = screenWidth / designWidth;
    return SafeArea(
      child: Scaffold(
        backgroundColor: appColors.backgroundColor,
          body: Container(
            child: Center(child: _widgetOptions.elementAt(_selectedIndex)),
          ),

        bottomNavigationBar: CurvedNavigationBar(
          index: 0,
          height: 75,

          buttonBackgroundColor: appColors.bottomNavBar.withOpacity(0.60),
          color: appColors.bottomNavBar.withOpacity(0.60),
            backgroundColor :Colors.white,

          items:   [

            const Icon(Icons.home, size: 30, color: Colors.white),
            // Icon(Icons.heart_broken, size: 30, color: Colors.white),
            Image.asset('assets/icons/like.png',width: 30,height: 30,color: Colors.white,),
            const Icon(Icons.add, size: 30, color: Colors.white),
            const Icon(Icons.person, size: 30, color: Colors.white),
            const Icon(Icons.notifications, size: 30, color: Colors.white),


          ],
          onTap: onSelected,

        ),


          ),
    );
  }
}

