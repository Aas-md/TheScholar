import 'package:get/get.dart';

import '../DAO/comment_dao.dart';

class CommentController extends GetxController {

  final commentDao = CommentDao();
  RxBool loading = false.obs;
  setLoading(bool value){
    loading.value = value;
  }

  getComment(String postId){
    return commentDao.getComments(postId);
  }

  Future<void> addComment(String postId,String userId,String content)async{

    commentDao.addComment(postId, userId, content);

  }

  void updateLike(String commentId,String postId){

    commentDao.updateLike(commentId, postId);
  }

}
