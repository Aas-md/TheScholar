import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_scholar/models/user_model.dart';

class Post {

  Users createdBy;
  Timestamp createdAt;
  int postType; // 0, 1, or 2
  String? imageUrl;
  String? pdfUrl;
  String? pdfName;
  String? pdfSize;
  List<String> likedBy;
  String text;
  int? commentCount;
  String uid;
  String? postId;
  String? filePath;

  Post({

    required this.createdBy,
    required this.createdAt,
    required this.postType,
    this.imageUrl,
    this.pdfUrl,
    this.pdfName,
     required this.likedBy,
    required this.text,
     this.commentCount = 0,
    required this.uid,
    this.pdfSize,
    this.postId,
  this.filePath
  });

  // Convert a Post object into a map
  Map<String, dynamic> toMap() {
    return {

      'createdBy': createdBy.toMap(),
      'createdAt': createdAt,
      'postType': postType,
      'imageUrl': imageUrl,
      'pdfUrl': pdfUrl,
      'pdfName': pdfName,
      'likedBy': likedBy,
      'text': text,
      'commentCount': commentCount,
      'uid': uid,
      'pdfSize' : pdfSize,
      'postId' : postId,
      'filePath' : filePath
    };
  }

  // Create a Post object from a map
  factory Post.fromMap(Map<String, dynamic> map,String id) {
    return Post(
        postId : id,
      createdBy: Users.fromMap(map['createdBy']),
      createdAt: map['createdAt'],
      postType: map['postType'],
      imageUrl: map['imageUrl'],
      pdfUrl: map['pdfUrl'],
      pdfName: map['pdfName'],
      likedBy: List<String>.from(map['likedBy']),
      text: map['text'],
      commentCount: map['commentCount'],
      uid: map['uid'],
      pdfSize: map['pdfSize'],
      filePath : map['filePath']
    );
  }
}
