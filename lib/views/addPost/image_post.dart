import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_scholar/controllers/auth_controller.dart';
import 'package:my_scholar/controllers/post_controller.dart';
import 'package:my_scholar/views/components/round_button.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../utils/app_colors.dart';

class ImagePost extends StatefulWidget {
  const ImagePost({super.key});

  @override
  State<ImagePost> createState() => _ImagePostState();
}

class _ImagePostState extends State<ImagePost> {
  final authController = Get.put(AuthController());
  final textController = TextEditingController();
  final postController = Get.put(PostController());
  final auth = FirebaseAuth.instance;

  final File? _image = Get.arguments['image'];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Size screenSize = MediaQuery.of(context).size;
    final appColors = AppColors();
    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Create a new post',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        backgroundColor: appColors.backgroundColor,
      ),
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          FutureBuilder(
              future: authController.getUserById(auth.currentUser!.uid),
              builder: (BuildContext context, AsyncSnapshot<Users> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ListTile(
                              leading: Icon(Icons.person),
                              title: Text('name'),
                              subtitle: Text('username'),
                            ),
                          )
                        ]),
                  );
                } else if (snapshot.hasError) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ListTile(
                              leading: Icon(Icons.person),
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
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ListTile(
                              leading: url == null
                                  ? const Icon(Icons.person)
                                  : CircleAvatar(
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
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 21, left: 11, right: 11),
              child: TextFormField(
                controller: textController,
                minLines: 3,
                maxLines: 3,
                maxLength: 300,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: appColors.borderColor,
                    ),
                  ),
                  hintText: 'Description',
                  hintStyle: const TextStyle(fontWeight: FontWeight.w400),
                  // contentPadding: const EdgeInsets.fromLTRB(36, 30, 0, 0),
                  focusedBorder: OutlineInputBorder(
                    // Border style when focused
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: appColors.focusBorderColor,
                    ),
                  ),
                ),

                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Write Description';
                  } else if (value.length < 3) {
                    return 'Name should not less than 3 characters';
                  }
                  return null;
                },

                onChanged: (value) {
                  textController.text = value;
                },
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 38,left: 11,right: 11),
            child: Container(
              height:250,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(15),

              image: DecorationImage(
                image: FileImage(_image!),
                fit: BoxFit.fill, // To contain the image within the container
              ),
              )

            ),
          ),

          Padding(
              padding: const EdgeInsets.only(top: 46),
              child: Obx(() {
                return RoundButton(
                    title: 'Post',
                    loading: postController.loading.value,
                    onTap:() async {
                      if (_formKey.currentState!.validate()){
                        postController.setLoading(true);
                        Users user = await authController.getUserById(auth.currentUser!.uid);
                      final list  = await postController.uploadImage(_image);
                        final time = Timestamp.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);
                        const postType = 1;
                        List<String> likedBy = [];
                        final text = textController.text.toString();
                        String uid = user.uid;
                    if(list.isNotEmpty){
                      Post post = Post(

                          imageUrl: list[0],
                          filePath: list[1],
                          createdBy: user,
                          createdAt: time,
                          postType: postType,
                          likedBy: likedBy,
                          text: text,
                          uid: uid);
                      postController.addPost(post,user);
                    }

                      }
                    });
              }))
        ]),
      ),
    );
  }
}
