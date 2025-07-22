import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ftoast/ftoast.dart';
import 'package:stylish/auth/screens/components/social_button.dart';
import 'package:stylish/colors.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:stylish/extensions/space_exs.dart';
import 'package:stylish/auth/screens/components/custom_button.dart';
import 'package:stylish/auth/screens/components/custom_text_field.dart';
import 'package:stylish/home/homepage.dart';
import 'package:stylish/auth/screens/sign_up_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool isTermUse = false;
  TextEditingController usernameTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  bool isValid = true;

  void loadingScreen() {
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator(color: Colors.black));
      },
    );
  }

  void loginUserWithEmailAndPassword() async {
    try {
      final user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: usernameTextController.text.trim(),
            password: passwordTextController.text.trim(),
          );

      Navigator.pushReplacementNamed(context, '/home');
      print(user);
    } catch (e) {
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
                  'Welcome \nBack!',
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
                  hintText: 'Username or Email',
                  fontSize: 12.sp,
                  icon: Icon(
                    Icons.person,
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
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: mainColor,
                      fontSize: 12.sp,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                60.customh,
                CustomButton(text: 'Login', isActive: true, onTap: () {
                  if (usernameTextController.text.isEmpty ||
                      passwordTextController.text.isEmpty) {
                    FToast.toast(
                      context,
                      msg: "Error",
                      subMsg: 'Please fill in all fields',
                      corner: 20,
                      duration: 3000,
                      padding: const EdgeInsets.all(20),
                    );
                  } else {
                    loadingScreen();
                    loginUserWithEmailAndPassword();
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const HomePage()),
                    // );
                  }
                }),
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
                          text: 'Create An Account ',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.sp,
                            fontFamily: 'Montserrat',
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Sign Up',
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
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const SignUpPage(),
                                        ),
                                      );
                                      // Handle Sign Up tap
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
