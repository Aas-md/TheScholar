import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_scholar/controllers/auth_controller.dart';
import 'package:my_scholar/controllers/post_controller.dart';
import 'package:my_scholar/utils/utils.dart';
import 'package:my_scholar/views/components/round_button.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../utils/app_colors.dart';
import 'package:file_picker/file_picker.dart';


class PdfPost extends StatefulWidget {
  const PdfPost({super.key});

  @override
  State<PdfPost> createState() => _PdfPostState();
}

class _PdfPostState extends State<PdfPost> {
  final authController = Get.put(AuthController());
  final textController = TextEditingController();
  final postController = Get.put(PostController());
  final auth = FirebaseAuth.instance;
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _filePath;
   File? _pdfFile;
    PlatformFile? _platformFile;

  @override
  void initState() {
    _pickPDFFile();
    super.initState();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textController.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Size screenSize = MediaQuery.of(context).size;
    final appColors = AppColors();

   if(_platformFile == null){
     return Container(child: const Center(child: Text('loading'),),);
   }

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
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.only(top: 21, left: 11, right: 11),
                  child: TextFormField(
                    controller: nameController,
                    maxLength: 25,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'File name',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: appColors.borderColor,
                        ),
                      ),
                      hintText: 'Enter File Name',
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
                      nameController.text = value;
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 21, left: 11, right: 11),
                  child: TextFormField(
                    controller: textController,
                    minLines: 3,
                    maxLines: 3,
                    maxLength: 300,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
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
                      } else if (value.length < 10) {
                        return 'Name should not less than 10 characters';
                      }
                      return null;
                    },

                    onChanged: (value) {
                      textController.text = value;
                    },
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 29,left: 11,right: 11),
            child: Container(
              height: 116,
              decoration: const BoxDecoration(
                color: Color(0xffF1F1F1),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black, // Specify the color of the border
                    width: 0.5, // Specify the width of the border
                  ),
                ),

              ),

              child: Padding(
                padding: const EdgeInsets.only(top: 22),
                child: ListTile(
                  leading: Image.asset('assets/icons/pdf_icon.png',height: 72,width: 58,),
                  title: Text(_platformFile!.name.toString(),style: const TextStyle(fontSize: 24),),
                  subtitle: Text( getSizeString(_platformFile!.size).toString(),style: const TextStyle(fontSize: 16),),
                ),
              ),
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
                        // String? imageUrl = await postController.uploadImage(_image);
                       final list= await postController.uploadPdf(_pdfFile);
                        final time = Timestamp.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);
                        const postType = 2;
                        List<String> likedBy = [];
                        final text = textController.text.toString();
                        String uid = user.uid;
                        if(list.isNotEmpty){
                          Post post = Post(
                              pdfSize: getSizeString(_platformFile!.size).toString(),
                              pdfUrl: list[0],
                              filePath: list[1],
                              pdfName: _platformFile?.name,
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

  Future<void> _pickPDFFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      File pdfFile = File(result.files.single.path!);


      _pdfFile = pdfFile;
      String filePath = pdfFile.path;

      setState(() {
        _filePath = filePath;
        _platformFile= result.files.single;// Store the selected PDF file path
      });
      // Optionally, you can upload the PDF file to Firebase Storage here
    } else {
      Navigator.pop(context);
      Utils.showSnackbar('File was not picked');
    }
  }

  String getSizeString(int sizeInBytes) {
    if (sizeInBytes < 1024) {
      return '$sizeInBytes B'; // Display size in bytes if less than 1 KB
    } else if (sizeInBytes < 1024 * 1024) {
      double sizeInKB = sizeInBytes / 1024;
      return '${sizeInKB.toStringAsFixed(2)} KB'; // Display size in KB with 2 decimal places
    } else {
      double sizeInMB = sizeInBytes / (1024 * 1024);
      return '${sizeInMB.toStringAsFixed(2)} MB'; // Display size in MB with 2 decimal places
    }
  }



}
