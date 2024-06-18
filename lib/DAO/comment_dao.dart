

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:my_scholar/DAO/post_dao.dart';
import 'package:my_scholar/DAO/user_dao.dart';
import 'package:my_scholar/controllers/comment_controller.dart';
import 'package:my_scholar/controllers/post_controller.dart';
import 'package:my_scholar/models/comment.dart';
import 'package:my_scholar/models/post_model.dart';
import 'package:my_scholar/utils/utils.dart';

import '../models/user_model.dart';
class CommentDao{

  final db = FirebaseFirestore.instance.collection('posts');
  final userDao = UserDao();
  final postDao = PostDao();
  final auth = FirebaseAuth.instance;

  Future<void> addComment(String postId, String userId, String content) async {

    final commentController = Get.find<CommentController>();

    try{
      commentController.setLoading(true);
      Users? user = await userDao.getUserByUid(userId);
      Post? post = await postDao.getPostById(postId);
      if(user != null && post != null){
        Comments comment = Comments(postId: postId,
            userId: userId,
            content: content,
            createdAt: Timestamp.now(),
            createdBy: user,
            likedBy: []);
        await db.doc(postId).collection('comments').add(comment.toMap());
        QuerySnapshot snapshot = await db.doc(postId).collection('comments').get();
        post.commentCount = snapshot.size;
        db.doc(postId).update(post.toMap());

          Utils.showToast('comment added successfully');
          commentController.setLoading(false);

      }else{
        commentController.setLoading(false);

        throw Exception('user is null in comment doa');
      }
    }catch(e){
      Utils.showSnackbar('some thing went wrong');
      commentController.setLoading(false);
      throw Exception(e);
    }


  }

  Stream<List<Comments>> getComments(String postId)  {

    Query query = db.doc(postId).collection('comments').orderBy('createdAt', descending: true);
    Stream<QuerySnapshot> snapshots =  query.snapshots();
    return snapshots.map((QuerySnapshot snapshot) {

      List<QueryDocumentSnapshot> docs = snapshot.docs;

      List<Comments> comments = docs.map((QueryDocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Comments comment = Comments.fromMap(data,doc.id);
        return comment;
      }).toList();

      return comments;
    });

  }

  Future<void> updateLike(String commentId,String postId) async{
    try{

      final commentCollection =  db.doc(postId).collection('comments');
      final comment = await getCommentById(commentId,postId);
      final uid = auth.currentUser!.uid;
      if(comment!.likedBy.contains(uid)){
        comment.likedBy.remove(uid);
      }else{
        comment.likedBy.add(uid);
      }
      commentCollection.doc(commentId).update(comment.toMap())
      .then((value){
        if (kDebugMode) {
          print('like updated successfully');
        }
      });


    }catch(e){
      throw Exception(e);
    }
  }

  Future<Comments?> getCommentById(String commentId,String postId)async{
    final commentCollection =  db.doc(postId).collection('comments');
    try {
      DocumentSnapshot commentDoc =
      await commentCollection.doc(commentId).get();

      if (commentDoc.exists) {
        Map<String, dynamic>? commentData = commentDoc.data() as Map<String, dynamic>?;

        return Comments.fromMap(commentData!,commentId);
      } else {
        if (kDebugMode) {
          print('Post not found');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting post: $e');
      }
      throw Exception(e);
    }


  }




}