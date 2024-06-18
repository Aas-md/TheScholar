import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_scholar/views/components/round_button.dart';
import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';
import '../../utils/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileScreen> {
  final authController = Get.put(AuthController());
  final appColors = AppColors();
  final auth = FirebaseAuth.instance;
  final nameController = TextEditingController();
  final courseController = TextEditingController();
  final phoneController = TextEditingController();
  final aboutController = TextEditingController();
  String? selectedYear;
  String? selectedGender;
  final List<String> years = ['1st', '2nd', '3rd','4th','5th'];
  final List<String> genders = ['Male', 'Female', 'Other'];


 String? uid;
  final _formKey = GlobalKey<FormState>();
  Users user = Get.arguments['user'];

  @override
  void initState() {
    uid = auth.currentUser?.uid;
    nameController.text = user.name;
    if(user.courseName != null) {
      courseController.text = user.courseName!;
    }
    if(user.phone != null){
      phoneController.text = user.phone!;
    }
    if(user.about != null){
      aboutController.text = user.about!;
    }


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

      body: SafeArea(
        child: SingleChildScrollView(
          physics:  const ScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: (){
                 Get.offAndToNamed('/ProfileScreen');
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10*hsf,left: 16*wsf),
                  width: 44 * wsf,
                  height: 44 * hsf,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: appColors.cardbackgroundColor),
                  child: const Icon(Icons.arrow_back),
                ),
              ),

              Padding(
                padding:  EdgeInsets.only(left: 25*wsf),
                child:  const Text('Edit Your Profile',
                style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
              ),


              Form(
                key: _formKey,
                child: Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(top: 21, left: 11, right: 11),
                      child: TextFormField(
                        controller: nameController,
                        maxLength: 15,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: appColors.borderColor,
                            ),
                          ),
                          hintText: 'Enter your name',
                          contentPadding: const EdgeInsets.symmetric(vertical: 17,horizontal: 10),
                          hintStyle: const TextStyle(fontWeight: FontWeight.w400),
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
                            return 'Name is mandatory';
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
                        controller: courseController,
                        maxLength: 15,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: 'Course',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: appColors.borderColor,
                            ),
                          ),
                          hintText: 'B tech(CSE)',
                          contentPadding: const EdgeInsets.symmetric(vertical: 17,horizontal: 10),
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


                        onChanged: (value) {
                          courseController.text = value;
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 21, left: 11, right: 11),
                      child: TextFormField(
                        controller: phoneController,
                        maxLength: 10,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone No',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.symmetric(vertical: 17,horizontal: 10),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: appColors.borderColor,
                            ),
                          ),
                          hintText: '9897...',
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

                        onChanged: (value) {
                          phoneController.text = value;
                        },
                      ),
                    ),


                    Padding(
                      padding:  EdgeInsets.only(left: 12*wsf,right: 12*wsf),
                      child: Row(
                        children: [

                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 12),
                                  child: Text(
                                    'year',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const SizedBox(height: 6,),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[200]
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    value: selectedYear,
                                    hint: const Text('Select Year'),
                                    icon: const Icon(Icons.arrow_drop_down), // Bottom arrow icon
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                        // filled: true,
                                        // fillColor: Colors.grey[200], // Background color
                                        border: InputBorder.none,// No border when focused
                                        hintStyle: TextStyle(color: Colors.grey),

                                    ),
                                    items: years.map((String gender) {
                                      return DropdownMenuItem<String>(
                                        value: gender,
                                        child: Text(gender),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedYear = newValue;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),


                          const SizedBox(width: 20,),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 12),
                                  child: Text(
                                    'Gender',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const SizedBox(height: 6,),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[200]
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    value: selectedGender,
                                    hint: const Text('Select Gender'),
                                    icon: const Icon(Icons.arrow_drop_down), // Bottom arrow icon
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                      // filled: true,
                                      // fillColor: Colors.grey[200], // Background color
                                      border: InputBorder.none,// No border when focused
                                      hintStyle: TextStyle(color: Colors.grey),

                                    ),
                                    items: genders.map((String gender) {
                                      return DropdownMenuItem<String>(
                                        value: gender,
                                        child: Text(gender),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedGender = newValue;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),


                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 11, right: 11),
                      child: TextFormField(
                        controller: aboutController,
                        maxLength: 500,
                        maxLines: 4,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: 'About',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: appColors.borderColor,
                            ),
                          ),
                          hintText: 'like 5 star coder at code ,doing web development etc',
                          contentPadding: const EdgeInsets.symmetric(vertical: 17,horizontal: 10),
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


                        onChanged: (value) {
                          aboutController.text = value;
                        },
                      ),
                    ),

                  ],
                ),
              ),

              Obx(() {
                return    Center(child: RoundButton(title: 'save', loading: authController.loadingPhone.value,onTap: (){
                  if(_formKey.currentState!.validate()){

                    Users updatedUser = Users(likedPosts: user.likedPosts, uid: user.uid,
                      username: user.username, name: nameController.text, likes: user.likes,
                      posts: user.posts,phone: phoneController.text,about: aboutController.text,
                      imageURL: user.imageURL,year:selectedYear,email:user.email,courseName: courseController.text
                    );
                     authController.editProfile(updatedUser, uid!);

                  }
                }));
              }),


              const SizedBox(height: 30,)

            ],
          ),
        ),
      ),
    );
  }
}
