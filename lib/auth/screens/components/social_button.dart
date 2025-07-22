import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stylish/colors.dart';

Widget buildSocialButton(
    BuildContext context,
    String imageUrl,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45.w, // Diameter of the circle
        height: 45.h, // Diameter of the circle
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Circular shape
          color: mainColor.withOpacity(0.08), // White background for the circle
          border: Border.all(
            color: Colors.red, // Red border
            width: 2, // Border width
          ),
        ),
        child: Center(
          child: Image.network(
            imageUrl,
            width: 40, // Adjust logo size
            height: 40, // Adjust logo size
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.error,
                color: Colors.grey,
                size: 40,
              ); // Fallback icon in case of image loading error
            },
          ),
        ),
      ),
    );
  }
