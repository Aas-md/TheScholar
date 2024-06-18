import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_scholar/utils/app_colors.dart';
import 'package:my_scholar/views/addPost/image_post.dart';
import 'package:my_scholar/views/addPost/pdf_post.dart';
import 'package:my_scholar/views/addPost/text_post.dart';
import 'package:my_scholar/views/auth/login_view.dart';
import 'package:my_scholar/views/auth/otp_success_view.dart';
import 'package:my_scholar/views/auth/otp_verification_view.dart';
import 'package:my_scholar/views/home/edit_profile_screen.dart';
import 'package:my_scholar/views/home/home_screen.dart';
import 'package:my_scholar/views/home/notification_screen.dart';
import 'package:my_scholar/views/home/profile_screen.dart';
import 'package:my_scholar/views/splahs_screen.dart';
import 'package:my_scholar/views/widgets/camera_pick.dart';
import 'package:my_scholar/views/widgets/full_screen_img.dart';
import 'package:my_scholar/views/widgets/gellery_pick.dart';
import 'package:my_scholar/views/widgets/profile_pic.dart';
import 'firebase_options.dart';
// import 'package:flutter_media_downloader/flutter_media_downloader.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

  @pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kDebugMode) {
    print('back ground notification called');
  }
}

class MyApp extends StatelessWidget {


   const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final appColor = AppColors();
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
          // scaffoldBackgroundColor: appColor.backgroundColor
      ),
      home: const SplashScreen(),
      getPages: [
        GetPage(name: '/', page: ()=> const SplashScreen()),
        GetPage(name: '/LoginView', page: () => const LoginView()),
        GetPage(name: '/OtpVerificationView', page: () => const OtpVerificationView()),
        GetPage(name: '/OtpSuccessView', page: () => const OtpSuccessView()),
        GetPage(name: '/HomeScreen', page: () => const HomeScreen()),
        GetPage(name: '/TextPost', page: () => const TextPost()),
        GetPage(name: '/PickPrevImage', page: () => const PickPrevImage()),
        GetPage(name: '/ImagePost', page: () => const ImagePost()),
        GetPage(name: '/CameraPick', page: () => const CameraPick()),
        GetPage(name: '/PdfPost', page: () => const PdfPost()),
        GetPage(name: '/ProfileScreen', page: () => const ProfileScreen()),
        GetPage(name: '/EditProfileScreen', page: () => const EditProfileScreen()),
        GetPage(name: '/FullScreenImg', page: () =>   FullScreenImg()),
        GetPage(name: '/ProfilePic', page: () =>    const ProfilePic()),
        GetPage(name: '/NotificationScreen', page: () =>    const NotificationScreen()),

      ],
    );
  }
}

// <uses-permission android:name="android.permission.INTERNET" />
// <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
// <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
// <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />

