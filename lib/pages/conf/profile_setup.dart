import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:stylish/colors.dart';
import 'package:stylish/extensions/space_exs.dart';
import 'package:stylish/providers/image_picker_provider.dart';
import 'package:stylish/providers/user_provider.dart';
import 'package:stylish/services/image_picker_service.dart';
import 'package:stylish/services/vendors_service.dart';
import 'package:stylish/widgets.dart';

class ProfileSetup extends ConsumerWidget with ImagePickerService {
  ProfileSetup({super.key});

  //   @override
  //   ConsumerState<ProfileSetup> createState() => _ProfileSetupState();
  // }

  // class _ProfileSetupState extends ConsumerState<ProfileSetup> {
  final TextEditingController _editUsernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  // final File? selectedImage;
  // Uint8List? selectedImageAsBytes;

  // Future<void> requestGalleryPermission() async {
  //   await Permission.photos.request();
  //   await Permission.storage.request();
  // }

  // @override
  // void initState() {
  //   // _editUsernameController.text = ref.watch(userProvider.notifier) ?? '';
  //   super.initState();
  //   // Initialize any necessary data or state here
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    _editUsernameController.text = user?.username ?? '';
    _phoneController.text = user?.phone ?? '';
    _locationController.text = user?.location ?? '';

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Account Setup(Settings can't be changed)",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    30.customh,
                    //Profile Picture
                    GestureDetector(
                      onTap: () async {
                        // requestGalleryPermission();
                        await pickImage((selectedImageAsBytes) {
                          ref
                              .read(selectedImageProvider.notifier)
                              .setImage(selectedImageAsBytes);
                        });
                        ref
                            .read(userProvider.notifier)
                            .updateProfilePicture(
                              ref.watch(selectedImageProvider).toString(),
                            );
                      },
                      child: Consumer(
                        builder: (context, ref, _) {
                          final image = ref.watch(selectedImageProvider);
                          return CircleAvatar(
                            radius: 60.r,
                            backgroundColor: mainColorFade,
                            foregroundImage:
                                image != null ? MemoryImage(image) : null,
                            child: Center(
                              child: Icon(
                                Icons.person,
                                size: 24.r,
                                color: iconColor,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Username Edit Field
                    Container(
                      width: 240.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1.r, color: iconColor),
                        ),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 200.w,
                            height: 25.h,
                            child: TextField(
                              controller: _editUsernameController,
                              style: TextStyle(fontSize: 13.sp),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Username',
                                hintStyle: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.black26,
                                ),
                              ),
                              onChanged: (value) {
                                ref
                                    .read(userProvider.notifier)
                                    .updateName(value);
                              },
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.edit_outlined,
                            size: 20.r,
                            color: iconColor,
                          ),
                        ],
                      ),
                    ),
                    40.customh,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0.w),
                      child: Divider(
                        color: Colors.black26,
                        thickness: 0.5.r,
                        // endIndent: 24.w,
                        // indent: 24.w,
                      ),
                    ),

                    //Account Details Section
                    20.customh,
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Account Details',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          20.customh,
                          CustomProfileInput(
                            hint: 'WhatsApp Number',
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(9),
                            ],
                            onChanged:
                                (value) => ref
                                    .read(userProvider.notifier)
                                    .updatePhone(value),
                            controller: _phoneController,
                            title: 'Phone Number',
                            prefix: Text(
                              '+237 | ',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.black,
                              ),
                            ),
                            suffix: Icon(
                              Icons.phone,
                              size: 20.r,
                              color: iconColor,
                            ),
                          ),
                          20.customh,
                          CustomProfileInput(
                            hint: 'Location. e.g Buea',
                            onChanged:
                                (value) => ref
                                    .read(userProvider.notifier)
                                    .updateLocation(value),

                            controller: _locationController,
                            title: 'Location',

                            suffix: Icon(
                              Icons.location_history,
                              size: 20.r,
                              color: iconColor,
                            ),
                          ),

                          20.customh,

                          // Vendor Check
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Are you a vendor?',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              Transform.scale(
                                scale: 1.5,
                                child: CupertinoSwitch(
                                  value: user.isVendor,
                                  onChanged: (value) {
                                    ref
                                        .read(userProvider.notifier)
                                        .updateVendorStatus(value);
                                  },
                                  activeTrackColor: mainColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: GestureDetector(
                onTap: () async {
                  String? imageString = user.profilePic;
                  final imageBytes = ref.read(selectedImageProvider);
                  if (imageBytes != null) {
                    imageString = base64Encode(imageBytes);
                  }
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({
                        // "creator": FirebaseAuth.instance.currentUser!.uid,
                        "username": user.username,
                        "phone": user.phone,
                        "location": user.location,
                        "profilePic": imageString,
                        "isVendor": user.isVendor,
                      });

                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 80.w,
                    height: 33.h,
                    margin: EdgeInsets.only(top: 5.h, right: 5.w),
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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
