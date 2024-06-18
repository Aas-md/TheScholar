import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_scholar/DAO/post_dao.dart';
import 'package:my_scholar/controllers/auth_controller.dart';
import 'package:my_scholar/models/user_model.dart';
import 'package:my_scholar/utils/utils.dart';

import '../models/post_model.dart';

class UserDao {
  final _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(User? user, String name) async {

    try{
      if (user != null) {
        final username = _generateUniqueUserId(name);
        final userDoc = db.doc(user.uid);
        final docSnapshot = await userDoc.get();
        if (docSnapshot.exists == false) {
          List<String> likedPosts = [];
          Users newUser = Users(
            likes: 0,
            username: username,
            name: name,
            uid: user.uid,
            email: user.email,
            phone: user.phoneNumber,
            imageURL: user.photoURL,
            likedPosts: likedPosts, posts: 0,
          );

          await db.doc(user.uid).set(newUser.toMap()).timeout(const Duration(seconds: 5));

        } else {
          if (kDebugMode) {
            print('user already exist');
          }
        }
      }
    }on TimeoutException {
      Utils.showSnackbar('please check your internet connection',title: 'Connection Error');

    }catch(e){
      Utils.showSnackbar(e.toString().toString());
      throw Exception(e);
    }

  }

  String _generateUniqueUserId(String name) {
    String reversedName = name.split(' ').reversed.join('.').toLowerCase();
    String userId;

    String randomNumber = Utils.getRandomNumber().toString();
    userId = '@$reversedName.$randomNumber';

    return userId;
  }

// Import the user model

  Future<Users?> getUserByUid(String uid) async {
    try {
      DocumentSnapshot userDoc = await db.doc(uid).get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

       final user =  Users.fromMap(userData!);

       return user;
      } else {
        if (kDebugMode) {
          print('User not found');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user: $e');
      }
      return null;
    }
  }

  Stream<List<Post>> getPostStreamByUser(String userId) {
    final db = FirebaseFirestore.instance.collection('posts');
    Query query = db
        .where('uid', isEqualTo: userId)
        .orderBy('createdAt', descending: true);
    Stream<QuerySnapshot> snapshots = query.snapshots();


    return snapshots.map((QuerySnapshot snapshot) {
      List<QueryDocumentSnapshot> docs = snapshot.docs;

      List<Post> posts = docs.map((QueryDocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        final id = doc.id;
        Post post = Post.fromMap(data, id);

        return post;
      }).toList();

      return posts;
    });
  }

  Future<void> editProfile(Users user,String uid)async{
    final authController = Get.put(AuthController());
    authController.setLoadingPhone(true);

    try{
      await db.doc(uid).update(user.toMap());
      authController.setLoadingPhone(false);
      Utils.showToast('Profile Updated Successfully');
      if (kDebugMode) {
        print('edit profile updated');
      }
      Get.back();

    }catch(e){
      authController.setLoadingPhone(false);
      throw Exception(e);
    }
  }

  Future<void> editProfilePic(File? image,String uid,BuildContext context)async{
    final postDao = PostDao();
    final authController = Get.put(AuthController());
    authController.setProfilePicLoading(true);
    try{
      Users? user = await getUserByUid(uid);
      final list = await postDao.uploadImage(image);
      final imagePath = user?.imagePath;


     if(user != null){
       user.imageURL = list[0];
       user.imagePath = list[1];
       await db.doc(uid).update(user.toMap());
       authController.setProfilePicLoading(false);
      Get.offAndToNamed('/ProfileScreen');
       if(imagePath !=  null){//it means there is old image in the storage
          await postDao.deleteImage(imagePath);
       }
     }else{
       if (kDebugMode) {
         print('user is null');
       }
       authController.setProfilePicLoading(false);
     }


    }catch(e){
      authController.setProfilePicLoading(false);
      throw Exception(e);
    }
  }


  Future<void> logout() async {
    final authController = Get.put(AuthController());
    authController.setLogoutLoading(true);
    try {
      await FirebaseAuth.instance.signOut();
      authController.setLogoutLoading(false);
      Get.offAndToNamed('/LoginView');
    } catch (e) {
      authController.setLogoutLoading(false);
      if (kDebugMode) {
        print("Error logging out: $e");
      }
      throw Exception(e);

    }
  }



}
