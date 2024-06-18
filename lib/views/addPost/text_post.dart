
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_scholar/controllers/auth_controller.dart';
import 'package:my_scholar/controllers/post_controller.dart';
import 'package:my_scholar/views/components/round_button.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../utils/app_colors.dart';

class TextPost extends StatefulWidget {
  const TextPost({super.key});

  @override
  State<TextPost> createState() => _TextPostState();
}

class _TextPostState extends State<TextPost> {
  final authController = Get.put(AuthController());
  final textController = TextEditingController();
  final postController = Get.put(PostController());
  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    // Size screenSize = MediaQuery.of(context).size;
    final appColors = AppColors();

    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        title: const Text('Create a new post',style: TextStyle(color: Colors.black,fontSize: 20),),
        backgroundColor: appColors.backgroundColor,
      ),

      body: SafeArea(
        child: Column(children: [


          FutureBuilder(
              future: authController.getUserById(auth.currentUser!.uid),
              builder: (BuildContext context, AsyncSnapshot<Users> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return  const Padding(
                    padding:  EdgeInsets.only(top: 20),
                    child: Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Expanded(
                            child: ListTile(
                              leading:  Icon(Icons.person) ,
                              title: Text('name'),
                              subtitle: Text('username'),
                            ),
                          )
                        ]),
                  );
                } else if (snapshot.hasError) {
                  return  const Padding(
                    padding:  EdgeInsets.only(top: 20),
                    child: Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Expanded(
                            child: ListTile(
                              leading: Icon(Icons.person) ,
                              title: Text('your name'),
                              subtitle: Text('username'),
                            ),
                          )
                        ]),
                  );
                } else if (snapshot.hasData) {
                  String? url = snapshot.data!.imageURL;
                  String name = snapshot.data!.name;
                  String username = snapshot.data!.username;
                  return  Padding(
                    padding:  const EdgeInsets.only(top: 20),
                    child: Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Expanded(
                            child: ListTile(
                              leading: url == null ? const Icon(Icons.person) : CircleAvatar(
                                radius: 25, // Adjust the radius as needed
                                backgroundImage: NetworkImage(url),
                              ),
                              title: Text(name),
                              subtitle: Text(username),
                            ),
                          )
                        ]),
                  );
                } else {
                  return Container();
                }
              }),

          Padding(
            padding: const EdgeInsets.only(top: 21),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: textController,
                minLines: 10,
                maxLines: 10,
                decoration:  const InputDecoration(
                  filled: true,
                  fillColor: Color(0xffffffff),
                  hintText: 'Express Your thoughts',
                  hintStyle: TextStyle(fontWeight: FontWeight.w300 ),
                  contentPadding: EdgeInsets.fromLTRB(36, 30, 0, 0), // Adjust padding to position the hint text
                       // Optionally, add a
                  border: InputBorder.none,
                ),

                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Text is required';
                  }
                  return null;
                },

                onChanged: (value){
                  textController.text = value;
                },
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.only(top : 46),
            child: Obx((){
              return RoundButton(title: 'Post', loading : postController.loading.value,onTap: ()async{

                if(_formKey.currentState!.validate()) {
                  postController.setLoading(true);
                  Users user = await authController.getUserById(auth
                      .currentUser!.uid);
                  final time = Timestamp.fromMillisecondsSinceEpoch(DateTime
                      .now()
                      .millisecondsSinceEpoch);
                  const postType = 0;
                  List<String> likedBy = [];
                  final text = textController.text.toString();
                  String uid = user.uid;
                  print(user.name);
                  print(user);
                  Post post = Post(createdBy: user,
                      createdAt: time,
                      postType: postType,
                      likedBy: likedBy,
                      text: text,
                      uid: uid);
                  postController.addPost(post, user);
                }});
            }
            ) 
          )

        ]),
      ),
    );
  }


}
