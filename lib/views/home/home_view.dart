import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_scholar/controllers/auth_controller.dart';
import 'package:my_scholar/controllers/post_controller.dart';
import 'package:my_scholar/models/user_model.dart';
import 'package:my_scholar/utils/app_colors.dart';
import 'package:my_scholar/utils/utils.dart';
import 'package:my_scholar/views/home/profile_screen.dart';
import 'package:my_scholar/views/widgets/full_screen_img.dart';
import '../../models/post_model.dart';
import '../widgets/comment_btm_sheet.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isSearchBarVisible = false;
  final searchController = TextEditingController();
  final PostController postController = Get.put(PostController());
  final AuthController authController = Get.put(AuthController());



  void _showDeleteConfirmationDialog(BuildContext context, String postId) {
    // Show dialog using Get.dialog
    Get.defaultDialog(
      title: 'Confirm Deletion',
      content: const Text('Are you sure you want to delete this post?'),
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
            postController.deletePost(postId);
            Get.back(); // Close the dialog
            },
          child: const Text('Yes'),
        ),
      ],
    );
  }




  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double designHeight = 850.0;
    double designWidth = 393.0;
    double hsf = screenHeight / designHeight;
    double wsf = screenWidth / designWidth;
    final appColors = AppColors();


    final auth = FirebaseAuth.instance;
    final uid = auth.currentUser!.uid;

    return WillPopScope(
        onWillPop: () async {
          if (postController.isSearchBarVisible.value) {
            postController.toggleSearchBar();
            return false; // Prevent the default back button behavior
          }
          return true; // Allow the default back button behavior
        },
        child: Scaffold(
            backgroundColor:
                Colors.white, //white color given in the design figma file.

            body: SafeArea(
                child: Column(children: [
              Stack(clipBehavior: Clip.none, children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isSearchBarVisible = !isSearchBarVisible;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 12 * hsf, left: 11 * wsf),
                        child: InkWell(
                          onTap: () {
                            Get.toNamed('/CameraPick');
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
                      Padding(
                        padding: EdgeInsets.only(
                          top: 19 * hsf,
                        ),
                        child: Text(
                          'Explore',
                          style: TextStyle(
                              fontSize: 22 * hsf, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 12 * hsf, right: 11 * wsf),
                        child: GestureDetector(
                          onTap: () {
                            postController.toggleSearchBar();
                          },
                          child: Container(
                            width: 44 * wsf,
                            height: 44 * hsf,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: appColors.cardbackgroundColor),
                            child: const Icon(Icons.search),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  if (postController.isSearchBarVisible.value) {
                    return Positioned(
                        top: 10,
                        left: 10,
                        right: 10,
                        // bottom: 0,
                        child: TextFormField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: appColors.borderColor,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(10),
                            fillColor: appColors.cardbackgroundColor,
                            filled: true,
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                postController.toggleSearchBar();
                                searchController.clear();
                              },
                              child: const Icon(Icons.close),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchController.text = value.toLowerCase();
                            });
                          },
                        ));
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
              ]),
              StreamBuilder<List<Post>>(
                  stream: postController.getPostStream(searchController.text),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Text('Loading..'));
                    } else if (snapshot.hasError) {
                      if (kDebugMode) {
                        print('error : ${snapshot.error}');
                      }
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No posts found.'));
                    } else {
                      final posts = snapshot.data!;

                      bool isLikeClicked = false;
                      return Expanded(
                          child: ListView.builder(
                              itemCount: posts.length, //posts.length,
                              itemBuilder: (context, index) {
                                final post = posts[index];

                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10 * wsf, vertical: 13 * hsf),
                                  child: Container(
                                    padding: EdgeInsets.only(bottom: 10 * hsf),
                                    width: 373.5 * wsf,
                                    decoration: BoxDecoration(
                                      color: appColors.cardbackgroundColor,
                                      borderRadius:
                                          BorderRadius.circular(40 * hsf),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FutureBuilder<Users>(
                                            future: authController
                                                .fetchUser(post.uid),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child: Text('loading'),
                                                );
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    'Error: ${snapshot.error}');
                                              } else if (!snapshot.hasData) {
                                                return const Text('loading');
                                              } else {
                                                final user = snapshot.data!;


                                                return InkWell(
                                                  onTap : (){
                                                    Get.toNamed('/ProfileScreen',arguments: {
                                                    'uid' : post.uid

                                                    });
                                                  },
                                                  child: ListTile(
                                                      leading: InkWell(
                                                        onTap : (){

                                                          Get.toNamed('FullScreenImg',arguments: {
                                                            'url' : user.imageURL
                                                          });
                                                        },
                                                        child: CircleAvatar(
                                                          backgroundImage: user.imageURL != null
                                                              ? NetworkImage(user.imageURL!)
                                                              : const  AssetImage('assets/icons/profile_user2.png')  as ImageProvider,
                                                          // child: user.imageURL == null
                                                          //     ? const Icon(Icons.account_circle_rounded, size: 40.0,color: Color(
                                                          //     0xFF6E6C6C),)
                                                          //     : null,
                                                        ),
                                                      ),
                                                      title: Text(user.name,
                                                          style: TextStyle(
                                                              fontSize: 18 * hsf,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                      subtitle: Text(
                                                        user.username,
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xff6C7A9C)),
                                                      ),
                                                      trailing:
                                                          PopupMenuButton<String>(
                                                        onSelected:
                                                            (String value) {
                                                          switch (value) {
                                                            case 'Delete':
                                                              _showDeleteConfirmationDialog(context, post.postId!);
                                                              break;
                                                            case 'Report':
                                                              // Handle edit operation
                                                              break;
                                                          }
                                                        },
                                                        itemBuilder: (BuildContext
                                                            context) {
                                                          return [
                                                            if (post.uid == uid)
                                                              const PopupMenuItem<
                                                                  String>(
                                                                value: 'Delete',
                                                                child: Text(
                                                                    'Delete'),
                                                              ),
                                                            const PopupMenuItem<
                                                                String>(
                                                              value: 'Report',
                                                              child:
                                                                  Text('Report'),
                                                            ),
                                                          ];
                                                        },
                                                      )),
                                                );
                                              }
                                            }),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20 * wsf,
                                              right: 15 * wsf,
                                              bottom: 20 * hsf),
                                          child: Text(
                                            post.text.toString(),
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        post.postType == 1
                                            ? Center(
                                                child: InkWell(
                                                  onTap: () {
                                                    Get.toNamed(
                                                        '/FullScreenImg',
                                                        arguments: {
                                                          'url': post.imageUrl
                                                        });
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius
                                                        .circular(30 *
                                                            hsf), // Set radius here
                                                    child: Image.network(
                                                      post.imageUrl.toString(),
                                                      width: 353.31 *
                                                          wsf, // Set width here
                                                      height: 270 *
                                                          hsf, // Set height here
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(
                                                height: 0,
                                              ),
                                        post.postType == 2
                                            ? ListTile(
                                                leading: Image.asset(
                                                  'assets/icons/pdf_icon.png',
                                                  fit: BoxFit.cover,
                                                  color: Colors.red,
                                                  width: 30 * wsf,
                                                  height: 40 * hsf,
                                                ),
                                                title: Text(
                                                  post.pdfName.toString(),
                                                  style: TextStyle(
                                                      fontSize: 22 * hsf),
                                                ),
                                                subtitle: Text(post.pdfSize!),
                                                trailing: Obx(() => InkWell(
                                                    onTap: () async {
                                                      postController
                                                          .setLoading(true);
                                                      await postController
                                                          .downloadPdf(
                                                              post.pdfUrl!);
                                                      postController
                                                          .setLoading(false);
                                                    },
                                                    child: postController
                                                            .loading.value
                                                        ? const CircularProgressIndicator(
                                                            color: Colors.white,
                                                          )
                                                        : const Icon(Icons
                                                            .download_for_offline_outlined))),
                                              )
                                            : const SizedBox(
                                                height: 0,
                                              ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if (isLikeClicked == false) {
                                                   postController.updateLike(post);


                                                }
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 21 * wsf),
                                                child:
                                                    post.likedBy.contains(uid)
                                                        ? Image.asset(
                                                            'assets/icons/like.png',
                                                            color: Colors.red,
                                                            fit: BoxFit.cover,
                                                            width: 25 * wsf,
                                                            height: 25 * hsf,
                                                          )
                                                        : Image.asset(
                                                            'assets/icons/unlike.png',
                                                            fit: BoxFit.cover,
                                                            width: 25 * wsf,
                                                            height: 25 * hsf,
                                                          ),
                                              ),
                                            ), // Padding

                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10 * wsf),
                                              child: Text(post.likedBy.length
                                                  .toString()),
                                            ),

                                            InkWell(
                                              onTap: () {
                                                Get.bottomSheet(
                                                  CommentsBottomSheet(
                                                      postId: post.postId!,
                                                      userId: uid),
                                                  isScrollControlled:
                                                      true, // This is important for larger content
                                                );
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 21 * wsf),
                                                child: Image.asset(
                                                  'assets/icons/comment.png',
                                                  fit: BoxFit.cover,
                                                  color: Colors.black,
                                                  width: 25 * wsf,
                                                  height: 25 * hsf,
                                                ),
                                                // child : Icon(Icons.message)
                                              ),
                                            ),

                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10 * wsf),
                                              child: Text(
                                                  post.commentCount.toString()),
                                            ),

                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 21 * wsf),
                                              child: Image.asset(
                                                'assets/icons/share.png',
                                                fit: BoxFit.cover,
                                                color: Colors.grey[600],
                                                width: 22 * wsf,
                                                height: 22 * hsf,
                                              ),
                                              // child : Icon(Icons.message)
                                            ),

                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 80 * wsf),
                                              child: Text(Utils.timeAgo(post
                                                  .createdAt
                                                  .millisecondsSinceEpoch)),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }));
                    }
                  })
            ]))));
  }
}

// FutureBuilder<Users>(
// future: authController.getUserById(),
// builder: (context, snapshot) {
// if (snapshot.connectionState == ConnectionState.waiting) {
// return const CircularProgressIndicator();
// } else if (snapshot.hasError) {
// return Text('Error: ${snapshot.error}');
// } else if (!snapshot.hasData) {
// return const Text('loading');
// } else {
// final user = snapshot.data!;
// return  StreamBuilder<List<Post>>(
// stream: postController.getPostStream(searchController.text),
// builder: (context, snapshot) {
// if (snapshot.connectionState == ConnectionState.waiting) {
// return const Center(child: CircularProgressIndicator());
// } else if (snapshot.hasError) {
// if (kDebugMode) {
// print('error : ${snapshot.error}');
// }
// return Text('Error: ${snapshot.error}');
// } else if(!snapshot.hasData || snapshot.data!.isEmpty){
// return const Center(child: Text('No posts found.'));
// }else {
// final posts = snapshot.data!;
// return Expanded(
// child: ListView.builder(
// itemCount: posts.length, //posts.length,
// itemBuilder: (context, index) {
// final post = posts[index];
// return Padding(
