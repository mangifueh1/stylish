import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ftoast/ftoast.dart';
import 'package:stylish/auth/screens/components/social_button.dart';
import 'package:stylish/auth/screens/login_page.dart';
// import 'package:stylish/colors.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:stylish/extensions/space_exs.dart';
import 'package:stylish/auth/screens/components/custom_button.dart';
import 'package:stylish/auth/screens/components/custom_text_field.dart';
import 'package:stylish/providers/user_provider.dart';
// import 'package:stylish/home/homepage.dart';
// import 'package:stylish/auth/screens/sign_up_page.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends ConsumerState<SignUpPage> {
  bool isTermUse = false;
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController usernameTextController = TextEditingController();
  bool isValid = true;

  void loadingScreen() {
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator(color: Colors.black));
      },
    );
  }

  Future<void> creatUserWithEmailAndPassword() async {
    try {
      loadingScreen();
      final userCredentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailTextController.text.trim(),
            password: passwordTextController.text.trim(),
          );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
            // "creator": FirebaseAuth.instance.currentUser!.uid,
            "username": usernameTextController.text,
            "phone": "",
            "location": "",
            "profilePic": "",
            "isVendor": false,
          });
      Navigator.pushReplacementNamed(context, '/setup');
      print(userCredentials);
      // print(userDetails);
    } catch (e) {
      print(e);
      FToast.toast(
        context,
        msg: "Error",
        subMsg: 'Something went wrong. Please try again later',
        corner: 20,
        duration: 6000,
        padding: const EdgeInsets.all(20),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 40.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create an \naccount!',
                  style: TextStyle(
                    height: 1.2,
                    fontSize: 36.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
                30.customh,
                StylishInput(
                  controller: usernameTextController,
                  hintText: 'Username or Business Name',
                  fontSize: 12.sp,
                  icon: Icon(
                    Icons.person,
                    color: Colors.grey.shade800,
                    size: 24.r,
                  ),
                ),
                30.customh,
                StylishInput(
                  controller: emailTextController,
                  hintText: 'Email',
                  fontSize: 12.sp,
                  icon: Icon(
                    Icons.email,
                    color: Colors.grey.shade800,
                    size: 24.r,
                  ),
                ),
                30.customh,
                StylishInput(
                  controller: passwordTextController,
                  hintText: 'Password',
                  fontSize: 12.sp,
                  isPassword: true,
                  icon: Icon(
                    Icons.lock,
                    color: Colors.grey.shade800,
                    size: 24.r,
                  ),
                ),

                7.customh,
                RichText(
                  text: TextSpan(
                    text: 'By clicking the ',
                    style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Create Account',
                        style: const TextStyle(
                          color: Colors.pink, // Pink color for "Register"
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                // Handle Create Account tap
                                _showSnackBar(
                                  context,
                                  'Register terms tapped!',
                                );
                              },
                      ),
                      const TextSpan(
                        text: ' button, you agree\nto the public offer',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                20.customh,
                CustomButton(
                  text: 'Create Account',
                  isActive: true,
                  onTap: () async {
                    loadingScreen();
                    try {
                      if (emailTextController.text.isEmpty ||
                          passwordTextController.text.isEmpty ||
                          usernameTextController.text.isEmpty) {
                        FToast.toast(
                          context,
                          msg: "Error",
                          subMsg: 'Please fill in all fields',
                          msgStyle: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white,
                          ),
                          subMsgStyle: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                          ),
                          corner: 20.r,
                          duration: 3000,
                          padding: EdgeInsets.all(20.r),
                        );
                        Navigator.of(context).pop();
                        return;
                      }
                      ref
                          .read(userProvider.notifier)
                          .updateName(usernameTextController.text);
                      await creatUserWithEmailAndPassword();
                    } catch (e) {
                      FToast.toast(
                        context,
                        msg: "Error",
                        subMsg: 'Something went wrong. Please try again later',
                        msgStyle: TextStyle(
                          fontSize: 17.sp,
                          color: Colors.white,
                        ),
                        subMsgStyle: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.white,
                        ),
                        corner: 20.r,
                        duration: 3000,
                        padding: EdgeInsets.all(20.r),
                      );
                      print(e);
                      Navigator.of(context).pop();
                      return;
                    }
                  },
                ),
                30.customh,
                Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center content vertically
                  children: <Widget>[
                    // "OR Continue with -" text
                    Text(
                      '- OR Continue with -',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 30), // Spacing below text
                    // Social Login Buttons (Google, Apple, Facebook)
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center, // Center buttons horizontally
                      children: <Widget>[
                        // Google Button
                        buildSocialButton(
                          context,
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png', // Google logo URL
                          () {
                            // Handle Google login tap
                            _showSnackBar(context, 'Google login tapped!');
                          },
                        ),
                      ],
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 40.0, bottom: 40.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'I Already Have an Account ',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.sp,
                            fontFamily: 'Montserrat',
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                color: Colors.red, // Red color for "Sign Up"
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                decoration:
                                    TextDecoration
                                        .underline, // Underline "Sign Up"
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      // Handle Sign Up tap
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const LoginPage(),
                                        ),
                                      );
                                      // _showSnackBar(context, 'Sign Up tapped!');
                                    },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
