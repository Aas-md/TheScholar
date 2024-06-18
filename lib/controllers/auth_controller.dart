import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:my_scholar/repositories/auth_repository/auth_repository.dart';

import '../models/post_model.dart';
import '../models/user_model.dart';
import '../utils/utils.dart';

class AuthController extends GetxController{

  final _authRepository = AuthRepository();
  final RxBool _loadingPhone = false.obs;
  RxBool get loadingPhone => _loadingPhone.value.obs;
   setLoadingPhone(bool value){
    _loadingPhone.value = value;
  }

  final RxBool _loadingGoogle = false.obs;
  RxBool get loadingGoogle => _loadingGoogle.value.obs;
  setLoadingGoogle(bool value){
    _loadingGoogle.value = value;
  }

  final RxBool _logoutLoading = false.obs;
  RxBool get logoutLoading => _logoutLoading.value.obs;
  setLogoutLoading(bool value){
    _logoutLoading.value = value;
  }

  final RxBool _profilePicLoading = false.obs;
  RxBool get profilePicLoading => _profilePicLoading.value.obs;
  setProfilePicLoading(bool value){
    _profilePicLoading.value = value;
  }


  void isLogin(BuildContext context){
     try{
       _authRepository.isLogin(context);

     }catch(e){
       throw e.toString();
     }

 }

  void loginWithPhone(TextEditingController phoneNumberCtr,String name) {
     try{
       _authRepository.loginWithPhone(phoneNumberCtr,name).catchError((error) {
         Utils.showSnackbar(error.toString());
       });
     }catch(e){
       throw e.toString();
     }

  }

  void verifyOTP(TextEditingController otpController,String verificationId,String name){
   _authRepository.verifyOTP(otpController, verificationId,name);
  }

  void signInWithGoogle(){

     _authRepository.signInWithGoogle();
   }

   Future<Users> getUserById(String uid)async{
    try{
      Users user = await _authRepository.getUserById(uid);
      return user;
    }catch(e){
      throw Exception(e.toString());
    }
   }

  Stream<List<Post>> getPostStreamByUser(String userId){

    return _authRepository.getPostStreamByUser(userId);
  }

  Future<void> editProfile(Users user,String uid)async{
    _authRepository.editProfile(user, uid);
  }


  Future<void> updateProfilePic(File? image,String uid,BuildContext context)async{
    _authRepository.updateProfilePic(image, uid,context);
  }

  Future<void> logout() async{
    _authRepository.logout();
  }

  final Map<String, Users> _userCache = {};

  Future<Users> fetchUser(String uid) async {
    if (!_userCache.containsKey(uid)) {
      final user = await getUserById(uid);
      _userCache[uid] = user;
    }
    return _userCache[uid]!;
  }


}