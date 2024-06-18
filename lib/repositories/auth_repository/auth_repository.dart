import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_scholar/DAO/user_dao.dart';
import 'package:my_scholar/controllers/auth_controller.dart';
import 'package:my_scholar/models/post_model.dart';
import 'package:my_scholar/views/auth/otp_success_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../models/user_model.dart';
import '../../utils/utils.dart';

class AuthRepository{
  final _auth = FirebaseAuth.instance;
  final _userDao = UserDao();

   void isLogin(BuildContext context){
  final currentUser = _auth.currentUser;
    Timer(const Duration(seconds: 2), () {
     if(currentUser != null){
       Get.offAndToNamed('/HomeScreen');

     }else{
       Get.offAndToNamed('/LoginView');
     }
    });

  }

  Future<void> loginWithPhone(TextEditingController phoneNumberCtr,String name) async {
    final authController = Get.find<AuthController>(); //
     authController.setLoadingPhone(true);
    await _auth.verifyPhoneNumber(
        phoneNumber: '+91 ${phoneNumberCtr.text}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            if (kDebugMode) {
              print('The provided phone number is not valid.');
            }

          }
          Utils.showSnackbar(e.toString());
          authController.setLoadingPhone(false);
        },
        codeSent: (String verificationId, int? resendToken) {
          authController.setLoadingPhone(false);
          Get.toNamed('/OtpVerificationView',arguments: {
            'id' : verificationId,
           'name' :  name
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {

        });
  }

  Future<void> verifyOTP(TextEditingController otpController,String verificationId,String name) async {
    String smsCode = otpController.text.trim();
    final authController = Get.find<AuthController>();
    final userDao = UserDao();
    authController.setLoadingPhone(true);
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    try {
      await _auth.signInWithCredential(credential)
          .then((value) async {
        authController.setLoadingPhone(false);
        Utils.showSnackbar('Login Successful',title: 'Login');
        Get.toNamed('/OtpSuccessView');
         userDao.addUser(_auth.currentUser, name);

          })

          .onError((error, stackTrace) {
        authController.setLoadingPhone(false);
            Utils.showSnackbar(error.toString());});
      // Navigate to the next screen or home screen

    } catch (e) {
      authController.setLoadingPhone(false);
      Utils.showSnackbar(e.toString());
    }
  }




  Future<void> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final authController = Get.find<AuthController>();

    try {
      authController.setLoadingGoogle(true);

      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {

        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        _auth.signInWithCredential(credential)
        .then((value){
          final user = _auth.currentUser;
          _userDao.addUser(user, user?.displayName ?? 'Testing User');
          authController.setLoadingGoogle(false);
          Get.toNamed('/OtpSuccessView');
          Utils.showToast('Login Successful');

        }).onError((error, stackTrace){
          authController.setLoadingGoogle(false);
          Utils.showSnackbar(error.toString());
          if (kDebugMode) {
            print(error.toString());
          }
        });

        // final UserCredential authResult = await _auth.signInWithCredential(credential);
        // final User? user = authResult.user;


      }else{
        authController.setLoadingGoogle(false);
      }
    } catch (error) {
      authController.setLoadingGoogle(false);
        if (kDebugMode) {
          print("Error signing in with Google: $error");
        }
      }

  }


  Future<void> signOutFromGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      // Sign out from Firebase
     _auth.signOut();

      // Sign out from Google
      await googleSignIn.signOut();
      Utils.showToast('signed out');

    } catch (error) {
      Utils.showSnackbar(error.toString());
    }
  }

  Future<void> signOutFromPhone() async {
    try {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      if (kDebugMode) {
        print('User signed out from phone number authentication');
      }
      Utils.showToast('User signed out from phone number authentication');
    } catch (error) {
      if (kDebugMode) {
        print('Error signing out: $error');
      }
      Utils.showSnackbar(error.toString());
    }
  }

  Future<Users> getUserById(String uid)async{

     try{
       Users? user = await _userDao.getUserByUid(uid);

       if (user != null) {
         return user;
       } else {
         throw Exception('User not found');
       }
     }catch(e){
       throw e.toString();
     }

  }

  Stream<List<Post>> getPostStreamByUser(String userId){

     return _userDao.getPostStreamByUser(userId);
  }

  Future<void> editProfile(Users user,String uid)async{
     _userDao.editProfile(user, uid);
  }

  Future<void> updateProfilePic(File? image,String uid,BuildContext context)async{
     _userDao.editProfilePic(image, uid,context);
  }

  Future<void> logout() async{
     _userDao.logout();
  }

}