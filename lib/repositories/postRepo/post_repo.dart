
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:my_scholar/DAO/post_dao.dart';
import 'package:my_scholar/models/user_model.dart';

import '../../models/post_model.dart';

class PostRepo{

  final postDao = PostDao();
  Future<void> addPost(Post post,Users user) async{

    try{
      postDao.addPosts(post, user);
    }catch(e){
      throw e.toString();
    }
  }

  Future<List<String?>> uploadImage(File? image)async{

   try{
     final list = await postDao.uploadImage(image);
     return list;
   }catch(e){
     throw Exception(e);
   }
  }

  Future<List<String?>> uploadPdf(File? pdfFile)async{

    try{
      final list = await postDao.uploadPdf(pdfFile);
      return list;
    }catch(e){
      throw Exception(e);
    }
  }

  Stream<List<Post>> getPostStream(String searchFilter){
    return postDao.getPostStream(searchFilter);
  }

  Future<void> updateLike(Post post)async{
    postDao.updateLike(post);
  }

  Future<void> downloadPdf(String url)async{

    postDao.downloadPdf(url);
  }

  Future<void> deletePost(String postId)async{
    postDao.deletePost(postId);
  }

  Future<Stream<List<Post>>> getLikedPosts(){
   return  postDao.getLikedPostStream();
  }

}