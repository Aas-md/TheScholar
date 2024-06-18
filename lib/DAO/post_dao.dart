import 'dart:async';
import 'dart:io';
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:my_scholar/DAO/user_dao.dart';
import 'package:my_scholar/controllers/auth_controller.dart';
import 'package:my_scholar/models/post_model.dart';
import 'package:my_scholar/models/user_model.dart';
import 'package:my_scholar/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:url_launcher/url_launcher.dart';
import '../controllers/post_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';



class PostDao {
  final db = FirebaseFirestore.instance.collection('posts');
  final storageRef = FirebaseStorage.instance;
  final userCollection = FirebaseFirestore.instance.collection('users');
  final userDao = UserDao();
  String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> addPosts(Post post,Users user) async {
    final postController = Get.put(PostController());

    try {

          db.doc().set(post.toMap());
            Utils.showToast('Post Added Successfully');
          Get.offAndToNamed('/HomeScreen');
            user.posts++;
            await userCollection.doc(uid).update(user.toMap());
            postController.setLoading(false);

    } catch (e) {
      postController.setLoading(false);
      Utils.showSnackbar(e.toString());
      throw e.toString();
    }
  }

  Future<List<String?>> uploadImage(File? image) async {

    try{
      String imageUrl;
      String filePath = 'images/${DateTime.now().millisecondsSinceEpoch}.png';
      if (image != null) {
        firebase_storage.Reference ref = storageRef.ref().child(filePath);
        await ref.putFile(image).timeout(const Duration(seconds: 15));

        String downloadURL = await ref.getDownloadURL();
        imageUrl = downloadURL;

        return [downloadURL,filePath];
      }else{
        return [];
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<List<String?>> uploadPdf(File? pdfFile) async {
    try {

      String filePath = 'pdfs/${DateTime.now().millisecondsSinceEpoch}.pdf';
      Reference ref = storageRef.ref().child(filePath);

      UploadTask uploadTask = ref.putFile(pdfFile!);
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL
      String downloadURL = await taskSnapshot.ref.getDownloadURL();


      return [downloadURL,filePath];
    } catch (e) {
     throw Exception(e);

    }
  }

  Stream<List<Post>> getPostStream(String searchFilter) {

    Query query = db.orderBy('createdAt', descending: true);
    Stream<QuerySnapshot> snapshots;

    if(searchFilter.isEmpty){

      snapshots =  query.snapshots();
    }else{

      snapshots = query
          .where('text', isGreaterThanOrEqualTo: searchFilter)
          .where('text', isLessThanOrEqualTo: searchFilter + '\uf8ff')
          .orderBy('text')
          .snapshots();
    }

    return snapshots.map((QuerySnapshot snapshot) {

      List<QueryDocumentSnapshot> docs = snapshot.docs;

      List<Post> posts = docs.map((QueryDocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        final id = doc.id;
        Post post = Post.fromMap(data,id);
        return post;
      }).toList();


      return posts;
    });
  }

  Future<Post?> getPostById(String postId)async{
    try {
      DocumentSnapshot postDoc = await db.doc(postId).get();

      if (postDoc.exists) {
        Map<String, dynamic>? postData = postDoc.data() as Map<String, dynamic>?;

        return Post.fromMap(postData!,postId);
      } else {

        return null;
      }
    } catch (e) {

      throw Exception(e);
    }
  }


  // we will make it fast and reduce the workload of this function in future
  Future<void> updateLike(Post post)async{
    print(post.createdBy.name);
    try{
      if(post.likedBy.contains(uid)){
        post.likedBy.remove(uid);
      }else{
        post.likedBy.add(uid);
      }
      await db.doc(post.postId).update(post.toMap());
     await addLikesToUsers(post);

    }catch(e){
      throw Exception(e);
    }


  }


  Future<void> addLikesToUsers(Post post)async {
    try{
      // final post = await getPostById(postId);
      Users? postUser = await userDao.getUserByUid(post.uid );
      final userDb = FirebaseFirestore.instance.collection('users');
      final currentUser =  await userDao.getUserByUid(uid);
      if(post.likedBy.contains(uid)){
        post.likedBy.remove(uid);
        currentUser?.likedPosts.add(post.postId!);
        postUser?.likes = (postUser.likes + 1);

      }else{

        currentUser?.likedPosts.remove(post.postId!);
        postUser?.likes = (postUser.likes - 1);

      }
      if(uid == post.uid){
        currentUser?.likes = postUser!.likes;
        userDb.doc(uid).update(currentUser!.toMap());
        print('equal');

      }else{
        userDb.doc(uid).update(currentUser!.toMap());
        userDb.doc(post.uid).update(postUser!.toMap());
        print('not equal');

      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> downloadPdf(String url) async {
    // Dio dio = Dio();
    // Directory? downloadsDir = await getDownloadsDirectory();
    // String filePath = '${downloadsDir!.path}/newFile';
    //
    // try {
    //   await dio.download(url, filePath);
    //   print('Download successful. File saved to: $filePath');
    // } catch (e) {
    //   print('Error downloading file: $e');
    // }

    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }

  }

  Future<void> deletePost(String postId)async{

  try{
    Users? user = await userDao.getUserByUid(uid);
    await db.doc(postId).delete();

          user?.posts--;
          userCollection.doc(uid).update(user!.toMap());
       Utils.showToast('post deleted');


  }catch(e){
    Utils.showSnackbar('some thing went wrong');
    throw Exception(e);
  }

  }

  Future<Stream<List<Post>>> getLikedPostStream() async {
    Query query = db.orderBy('createdAt', descending: true);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userDao = UserDao();
    final currentUser = await userDao.getUserByUid(uid!);

    if (currentUser == null || currentUser.likedPosts.isEmpty) {
      return Stream.value([]);
    }

    // List of streams for each likedPost
    List<Stream<List<Post>>> streams = currentUser.likedPosts.map((postId) {
      return query
          .where('postId', isEqualTo: postId)
          .snapshots().map((QuerySnapshot snapshot) {
        List<QueryDocumentSnapshot> docs = snapshot.docs;
        return docs.map((QueryDocumentSnapshot doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          final id = doc.id;
          return Post.fromMap(data, id);
        }).toList();
      });
    }).toList();

    // Combine all the streams into a single stream
    return StreamZip(streams).map((List<List<Post>> postsLists) {
      return postsLists.expand((posts) => posts).toList();
    });
  }


  Future<void> deleteImage(String filePath) async {
    final authController = Get.put(AuthController());
    authController.setLogoutLoading(true);
    try {
      await FirebaseStorage.instance.ref(filePath).delete();

      authController.setLogoutLoading(false);

    } catch (e) {
      if (kDebugMode) {
        print("Error deleting image: $e");
      }
      authController.setLogoutLoading(false);
      throw Exception(e);

    }
  }





}
