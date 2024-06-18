
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:my_scholar/repositories/postRepo/post_repo.dart';

import '../models/post_model.dart';
import '../models/user_model.dart';

class PostController extends GetxController {

  final RxBool _loading = false.obs;
  RxBool get loading=> _loading.value.obs;
  void setLoading(bool value){
    _loading.value = value;
  }

  RxBool isSearchBarVisible = false.obs;
  void toggleSearchBar() {
  isSearchBarVisible.value = !isSearchBarVisible.value;
  }


  Future<void> addPost(Post post,Users user)async{
    PostRepo postRepo = PostRepo();
    setLoading(true);

    try{
     await postRepo.addPost(post,user);
    }catch(e){
      setLoading(false);
      throw e.toString();
    }
  }

  Future<List<String?>> uploadImage(File? image)async{
    final postRepo = PostRepo();
     final list = await postRepo.uploadImage(image);
      return list;

  }

  Future<List<String?>> uploadPdf(File? pdfFile)async{
    final postRepo = PostRepo();

      final list = await postRepo.uploadPdf(pdfFile);
      return list;

  }

  Stream<List<Post>> getPostStream(String searchFilter){
    final postRepo = PostRepo();
    return postRepo.getPostStream(searchFilter);
  }

  Future<void> updateLike(Post post)async{

    final postRepo = PostRepo();
    postRepo.updateLike(post);
  }

  Future<void> downloadPdf(String url)async{
    final postRepo = PostRepo();
    postRepo.downloadPdf(url);
  }

  Future<void> deletePost(String postId)async{
    final postRepo = PostRepo();
    postRepo.deletePost(postId);
  }

  Future<Stream<List<Post>>> getLikedPosts( ){
    final postRepo = PostRepo();
    return  postRepo.getLikedPosts();
  }
}