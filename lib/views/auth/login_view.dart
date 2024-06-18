import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_scholar/controllers/auth_controller.dart';
import 'package:my_scholar/utils/app_colors.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final nameController = TextEditingController();
  final phoneNumberCtr = TextEditingController();
  final authController = Get.put(AuthController());
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final appColors = AppColors();

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double designHeight = 812.0;
    double designWidth = 375.0;
    double hsf = screenHeight / designHeight;
    double wsf = screenWidth / designWidth;
    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 18 * wsf, top: 66 * hsf),
              child: Text(
                'Sign in',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26 * hsf,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 7 * wsf, left: 18 * hsf),
              child: Row(
                children: [
                  const Text("New user?"),
                  Text(
                    'Create an account',
                    style: TextStyle(
                        color: const Color(0xff0098FF), fontSize: 15 * hsf),
                  ),
                ],
              ),
            ),
            Form(
              key: _formKey1,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 11),
                child: Container(
                  width: 354,
                  // height: 52,
                  child: TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name is required';
                      } else if (value.length > 15) {
                        return 'Name should not exceed 15 characters';
                      } else if (value.length < 3) {
                        return 'Name should not less than 3 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      labelText: 'Name',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: appColors.borderColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // Border style when focused
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: appColors
                              .focusBorderColor, // Set the desired color for the focused border
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Form(
              key: _formKey2,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 11),
                child: Container(
                  width: 354,
                  // height: 50,
                  child: TextFormField(
                    controller: phoneNumberCtr,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Phone number is required';
                      } else if (value.length != 10) {
                        return 'Phone number should be exactly 10 digits';
                      }
                      return null;
                    },
                    maxLength: 10,

                    decoration: InputDecoration(
                      hintText: 'Enter your phone number',
                      labelText: 'Phone',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: appColors.borderColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // Border style when focused
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: appColors
                              .focusBorderColor, // Set the desired color for the focused border
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 210, top: 36),
              child: Obx(() {
                return GestureDetector(

                    onTap: authController.loadingPhone.value ||
                        authController.loadingGoogle.value ? null :  () {

                      if (_formKey1.currentState!.validate() &&
                          _formKey2.currentState!.validate()) {
                        authController.loginWithPhone(
                            phoneNumberCtr, nameController.text);

                      }
                    },
                    child: Container(
                      alignment: Alignment.topRight,
                      width: 150.81,
                      height: 39.24,
                      decoration: BoxDecoration(
                          color: appColors.deepPurpleColor,
                          borderRadius: BorderRadius.circular(7)),
                      child: Center(
                          child: authController.loadingPhone.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Continue',
                                  style: TextStyle(color: Colors.white),
                                )),
                    ));
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 17, top: 29),
              child: Row(children: [
                Container(
                  width: 155, // Width of the vertical divider
                  height: .87, // Height of the vertical divider
                  color: appColors.borderColor,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Center(child: Text('or')),
                ),
                Container(
                  width: 155, // Width of the vertical divider
                  height: .87, // Height of the vertical divider
                  color: appColors.borderColor,
                ),
              ]),
            ),
            Padding(
              padding: EdgeInsets.only(left: 17, top: 50 * hsf),
              child: Obx(() {
                return   GestureDetector(

                  onTap: (authController.loadingPhone.value == true || authController.loadingGoogle.value == true) ? null : () {
                    authController.signInWithGoogle();
                  },
                  child: Container(
                    width: 341 * wsf,
                    height: 61 * hsf,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(130 * hsf)),
                    child: Wrap(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 46 * wsf, top: 17 * hsf),
                                child:
                                    Image.asset('assets/icons/google_icon.png'),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 17 * wsf, top: 17 * hsf),
                                child: authController.loadingGoogle.value
                                    ? const CircularProgressIndicator(
                                  color: Colors.blue,
                                ) : const Text(
                                  'Continue with Google',
                                  style: TextStyle(fontSize: 19),
                                ),
                              ),
                            ],
                          ),
                  ),
                );
              })),
            Padding(
              padding: EdgeInsets.only(left: 17 * wsf, top: 13 * hsf),
              child: InkWell(
                onTap: () {
                  // print('screen height ${hsf.toString()} -> ${wsf.toString()}');
                },
                child: Container(
                  width: 341 * wsf,
                  height: 61 * hsf,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(130 * hsf)),
                  child: Wrap(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 34 * wsf, top: 13 * hsf),
                        child: Image.asset(
                          'assets/icons/facebook_icon.png',
                          width: 35,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 17 * wsf, top: 17 * hsf),
                        child: Text(
                          'Continue with Facebook',
                          style: TextStyle(fontSize: 19 * hsf),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 17 * wsf, top: 13 * hsf),
              child: InkWell(
                onTap: () {},
                child: Container(
                  width: 341 * wsf,
                  height: 61 * hsf,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(130 * hsf)),
                  child: Wrap(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 34 * wsf, top: 13 * hsf),
                        child: Image.asset(
                          'assets/icons/apple_icon.png',
                          width: 35,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 17 * wsf, top: 17 * hsf),
                        child: Text(
                          'Continue with Apple',
                          style: TextStyle(fontSize: 19 * hsf),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
