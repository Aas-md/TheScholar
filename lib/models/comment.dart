import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_scholar/models/user_model.dart';

class Comments{
  String? commentId;
  String postId;
  String userId;
  String content;
  Timestamp createdAt;
  List<String> likedBy;
  Users createdBy;


  Comments({
     this.commentId,
    required this.postId,
     required this.userId,
    required this.content,
    required this.createdAt,
    required this.createdBy,
    required this.likedBy
});

  // Method to convert Comment instance to a map
  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'postId': postId,
      'userId': userId,
      'content': content,
      'createdAt': createdAt,
      'likedBy': likedBy,
      'createdBy': createdBy.toMap(), // Assuming Users has a toMap method
    };
  }

  // Method to create Comment instance from a map
  factory Comments.fromMap(Map<String, dynamic> map,String commentId) {
    return Comments(
      commentId: commentId,
      postId: map['postId'],
      userId: map['userId'],
      content: map['content'],
      createdAt: map['createdAt'],
      likedBy: List<String>.from(map['likedBy']),
      createdBy: Users.fromMap(map['createdBy']),
      // Assuming Users has a fromMap method
    );
  }

}