import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_scholar/controllers/auth_controller.dart';
import 'package:my_scholar/models/user_model.dart';
import '../../models/post_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final userController = Get.put(AuthController());
  final appColors = AppColors();
  final auth = FirebaseAuth.instance;
  Users? currentUser;
  String uid = Get.arguments['uid'];



  void _showDeleteConfirmationDialog(BuildContext context) {
    Get.defaultDialog(
      title: 'Confirm Logout',
      content: const Text('Are you sure you want to Logout?'),
      backgroundColor: appColors.cardbackgroundColor,
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // Close the dialog
          },
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            // Call the delete method from your controller
            userController.logout();
            Get.back(); // Close the dialog
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }



  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double designHeight = 850.0;
    double designWidth = 393.0;
    double hsf = screenHeight / designHeight;
    double wsf = screenWidth / designWidth;
    return  Scaffold(
      body:Stack(
        children: [

      Image.asset(
      'assets/icons/background_image.png', // Replace 'background_image.jpg' with your image asset
      fit: BoxFit.cover,
      width:double.infinity,
      height: 300*hsf,
    ),


          ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 180),
                    // padding: const EdgeInsets.all(20),
                    decoration:  BoxDecoration(
                      color: appColors.cardbackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(60),
                        topLeft: Radius.circular(60),
                      ),
                    ),
                    child: FutureBuilder<Users>(
                                    future: userController.getUserById(uid),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                    if (kDebugMode) {
                      print('error : ${snapshot.error}');
                    }
                    return Text('Error: ${snapshot.error}');
                                      } else if (!snapshot.hasData) {
                    return const Center(child: Text('Loading.'));
                                      } else {
                    final user = snapshot.data!;
                         return Column(
                            children: [

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:  EdgeInsets.only(left: 61*wsf,top: 15*hsf),
                                    child: Column(
                                      children: [
                                        Text(user.likes.toString(),style: TextStyle(fontSize: 18.2*hsf,fontWeight: FontWeight.bold),),
                                        const Text('Likes')
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(right: 66*wsf,top:15*hsf),
                                    child: Column(
                                      children: [
                                        Text(user.posts.toString(),style: TextStyle(fontSize: 18.2*hsf,fontWeight: FontWeight.bold)),
                                        const Text('Posts')
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:  EdgeInsets.only(top: 14*hsf),
                                child: Text(user.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16*hsf,height: 22/16),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(user.username,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16*hsf,height: 22/16),),
                              ),
                              Padding(
                                padding:  EdgeInsets.only(top: 10*hsf,left:50,right: 50 ),
                                child: Text(user.about.toString(),style:
                                const TextStyle(color: Color(0xff6C7A9C),height: 22/14,),textAlign: TextAlign.center,maxLines: 3,),
                              ),
                              Padding(
                                padding:  EdgeInsets.only(left: 40*wsf,right: 40*wsf,top: 20*hsf,bottom: 20),
                                child:  Row(

                                  children: [
                                    const Text('Course : '),
                                    Text(user.courseName.toString()),
                                    SizedBox(width: 80*wsf,),
                                    const Text('Year : '),
                                    Text(user.year.toString())
                                  ],
                                ),
                              ),


                            ],);

                          // }});
                          }}),
                  ),


                  FutureBuilder<Users>(
                      future: userController.getUserById(uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          if (kDebugMode) {
                            print('error : ${snapshot.error}');
                          }
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData) {
                          return const Center(child: Text('Loading.'));
                        } else {
                          final user = snapshot.data!;
                           currentUser = user;

                         return Positioned(
                            top: 125, // Adjust this value to control the vertical position of the image
                            left: (MediaQuery.of(context).size.width - (130 * wsf)) / 2,
                            child: InkWell(
                              onTap: (){
                                Get.toNamed('/FullScreenImg',arguments: {
                                  'url' : currentUser?.imageURL
                                });
                              },
                              child: Container(
                                height: 130 * hsf,
                                width: 130 * wsf,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: user.imageURL == null
                                      ? const DecorationImage(image: AssetImage('assets/icons/profile_user2.png'))
                                      : DecorationImage(image: NetworkImage(user.imageURL!), fit: BoxFit.cover),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),

                              ),
                            ),
                          );
                        }}),


                  Positioned(
                    top: 125, // Adjust this value to control the vertical position of the image
                    left: (MediaQuery.of(context).size.width) / 2 + 20,
                    child : Padding(
                      padding: EdgeInsets.only(top: 12 * hsf, left: 11 * wsf),
                      child: InkWell(
                        onTap: (){

                          Get.toNamed('ProfilePic');

                        },
                        child: Container(
                          width: 44 * wsf,
                          height: 44 * hsf,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: appColors.cardbackgroundColor),
                          child: const Icon(Icons.camera_alt_rounded),
                        ),
                      ),
                    ),
                  )


                ],
              ),

              StreamBuilder<List<Post>>(
                  stream: userController.getPostStreamByUser(uid!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      if (kDebugMode) {
                        print('error : ${snapshot.error}');
                      }
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No posts found.'));
                    } else {
                      final posts = snapshot.data!;

                      return Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.white,
                        child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: posts.length, //posts.length,
                            itemBuilder: (context, index) {
                              final post = posts[index];

                              if(post.postType == 0){

                                return Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: Card(
                                    elevation: 4,
                                    color: appColors.cardbackgroundColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            post.text,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: Utils.calculateFontSize(post.text), // Dynamic font size
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Posted by: ${post.createdBy.name}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Posted : ${Utils.timeAgo(post.createdAt.millisecondsSinceEpoch)}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );

                              }else if(post.postType == 1){

                                return  Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                    child: Card(
                                        elevation: 4,
                                        color: appColors.cardbackgroundColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                  child:

                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        10 * hsf), // Set radius here
                                    child: Image.network(
                                      post.imageUrl.toString(),
                                      width: 353.31 * wsf, // Set width here
                                      height: 270 * hsf, // Set height here
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  )
                                );
                              }else{

                                return Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: Card(
                                    elevation: 4,
                                    color: appColors.cardbackgroundColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.picture_as_pdf,
                                                color: Colors.red,
                                                size: 50,
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  post.pdfName != null ? post.pdfName!:  post.text,
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Posted by: ${post.createdBy.name}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Posted on: ${post.createdAt.toDate()}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );

                              }

                            }),
                      );

                  }

                    })
                ],
              ),
          Positioned(

            top: 32.0,
            left: 16.0,
            right: 16.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: (){
                    print('object');
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 44 * wsf,
                    height: 44 * hsf,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: appColors.cardbackgroundColor),
                    child: const Icon(Icons.arrow_back),
                  ),
                ),

             Padding(
                  padding: const EdgeInsets.only(left: 200),
                  child:  uid == auth.currentUser!.uid  ? InkWell(
                    onTap: (){
                      if(currentUser != null){
                        Get.toNamed('/EditProfileScreen',arguments: {
                          'user' : currentUser!
                        });
                      }

                    },
                    child: Container(
                      width: 44 * wsf,
                      height: 44 * hsf,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: appColors.cardbackgroundColor),
                      child: const Icon(Icons.edit),
                    ),
                  ) : const SizedBox(),
                ),

              Obx(() {

                return InkWell(
                  onTap: (){
                    _showDeleteConfirmationDialog(context);
                  },
                  child: Container(
                    width: 44 * wsf,
                    height: 44 * hsf,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: appColors.cardbackgroundColor),
                    child: userController.logoutLoading.value ? const CircularProgressIndicator() :  const Icon(Icons.logout_outlined),
                  ),
                );
              })


              ],
            ),
          ),
            ],
          ),


    );
  }
}
