import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_scholar/controllers/auth_controller.dart';
import 'package:my_scholar/controllers/comment_controller.dart';
import 'package:my_scholar/models/comment.dart';
import 'package:my_scholar/models/user_model.dart';
import 'package:my_scholar/utils/utils.dart';

class CommentsBottomSheet extends StatefulWidget {
  final String postId;
  final String userId;

  const CommentsBottomSheet({super.key,
    required this.postId,
    required this.userId,
  });

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final commentController = Get.put(CommentController());
  TextEditingController textController = TextEditingController();
  final authController = AuthController();
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //root
    return Container(
     decoration: const BoxDecoration(
       color: Colors.white,
       borderRadius: BorderRadius.only(
         topLeft: Radius.circular(15),
         topRight: Radius.circular(15),

       )
     ),
      height: MediaQuery.of(context).size.height * 0.7,

      child: Column(
        children: [
          // Close icon
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          const Divider(
            color: Colors.black, // Color of the line
            thickness: 0.5, // Thickness of the line
            // indent: 20, // Empty space to the leading edge of the line
            // endIndent: 10,
          ),
           Align(
            alignment: Alignment.topRight,
            child:
            ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),

              leading: FutureBuilder(
                  future: authController.getUserById(auth.currentUser!.uid),
                  builder: (BuildContext context, AsyncSnapshot<Users> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Icon(Icons.person);
                       }else if(snapshot.hasError){
                      const Icon(Icons.person);
                    }
                    return  CircleAvatar(

                      backgroundImage: NetworkImage(snapshot.data!.imageURL.toString()),
                    );
                  }),
              title: TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: 'add a comment',
                  hintStyle: TextStyle(
                    color: Color(0xffA8A8A8),
                  ),
                  border: InputBorder.none,
                ),
              ),
              trailing:Obx(()=> InkWell(
                onTap: ()async{
                  if(textController.text.isEmpty){
                    Utils.showToast('please write something');
                    return;
                  }
                  await commentController.addComment(widget.postId,widget.userId,textController.text);
                  textController.clear();
                },
                  child: commentController.loading.value ? const CircularProgressIndicator(color: Colors.black,) :
                  const Icon(Icons.send)),
            ))
          ),
          const Divider(
            color: Colors.black,
            thickness: 0.5,

          ),


        StreamBuilder<List<Comments>>(
        stream: commentController.getComment(widget.postId),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
    print(snapshot.error);
    return Text('Error: ${snapshot.error}');
    } else if(snapshot.data!.isEmpty){
      return const Padding(
        padding: EdgeInsets.only(top: 170),
        child: Center(child: Text('No Comment Yet')),
      );
    } else
     {
      final comments = snapshot.data!;

      return Expanded(
        child: ListView.builder(
          itemCount: comments.length, // Example count, replace with actual data
          itemBuilder: (context, index) {
            final comment = comments[index];
            return  Column(
              children: [
                ListTile(
                  leading:  Container(
            width: 25.0, // Set the width of the container
              height: 25.0, // Set the height of the container
              child: CircleAvatar(
                backgroundImage: NetworkImage(comment.createdBy.imageURL.toString()),
              ),
            ),
                  title: Text(
                    comment.createdBy.name, style: const TextStyle(fontSize: 12, color: Color(
                      0xff4D4444)),),
                  subtitle: Text(comment.content
                    , style: const TextStyle(fontSize: 15, color: Colors.black),),

                ),
                 Padding(
                  padding: const EdgeInsets.only(left: 55),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: (){
                          commentController.updateLike(comment.commentId!, widget.postId);
                        },
                        child: Container(
                          child: comment.likedBy.contains(widget.userId) ?  const Icon(Icons.thumb_up_alt,size: 18,)
                              :const Icon(Icons.thumb_up_alt_outlined,size: 18,)
                        ),
                      ),
                      const SizedBox(width: 10,),
                       Text(comment.likedBy.length.toString()),
                      const SizedBox(width: 50),
                      Text(Utils.timeAgo(comment.createdAt.millisecondsSinceEpoch), style: const TextStyle(fontSize: 12,color: Color(
                          0xff4D4444)))


                    ],
                  ),
                )
              ],
            );
          },
        ),
      );
    }

    })
        ],
      ),
    );
  }

}


