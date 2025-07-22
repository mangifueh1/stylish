import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stylish/colors.dart';
import 'package:stylish/extensions/space_exs.dart';
import 'package:stylish/models/user_model.dart';
import 'package:stylish/providers/liked_products_provider.dart';
import 'package:stylish/services/product_data_source.dart';
import 'package:stylish/models/product_model.dart';
import 'package:stylish/providers/search_query_provider.dart';
import 'package:stylish/services/user_service.dart';

class CustomNavBar extends ConsumerWidget {
  const CustomNavBar({super.key, this.whatPage = 0});
  final int whatPage; // Default to Home page

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            10.customh,
            Container(
              width: double.infinity,
              height: 55.h,

              padding: EdgeInsets.symmetric(horizontal: 15.h),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  bottomNavItem(
                    () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    'Home',
                    Icons.home_outlined,
                    whatPage == 0 ? mainColor : iconColor,
                  ),
                  40.customw,
                  bottomNavItem(
                    () {
                      ref.invalidate(searchQueryProvider);
                      Navigator.pushReplacementNamed(context, '/wishlist');
                    },
                    'Wishlist',
                    Icons.favorite_outline,
                    whatPage == 1 ? mainColor : iconColor,
                  ),
                  Spacer(),
                  bottomNavItem(
                    () {
                      Navigator.pushReplacementNamed(context, '/search');
                    },
                    'Search',
                    Icons.search_outlined,
                    whatPage == 3 ? mainColor : iconColor,
                  ),
                  40.customw,
                  bottomNavItem(
                    () {
                      Navigator.pushReplacementNamed(context, '/settings');
                    },
                    'Settings',
                    Icons.settings_outlined,
                    whatPage == 4 ? mainColor : iconColor,
                  ),
                ],
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.topCenter,
          child: GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, '/cart'),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 10,
                    color: Colors.grey.shade100,
                    blurRadius: 20,
                    offset: Offset(10, 10),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: whatPage == 2 ? mainColor : Colors.white,
                radius: 25.r,
                child: Icon(
                  Icons.shopping_cart_outlined,
                  weight: 0.5,
                  size: 20.r,
                  color: whatPage == 2 ? Colors.white : iconColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  GestureDetector bottomNavItem(
    void Function()? onTap,
    String title,
    IconData icon,
    Color color,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20.r),
          Text(title, style: TextStyle(fontSize: 10.sp, color: color)),
        ],
      ),
    );
  }
}

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userInfoProvider);
    return Container(
      color: bkgColor,
      child: Padding(
        padding: EdgeInsets.only(left: 10.0.w, right: 10.w, top: 5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            userAsync.when(
              data: (data) {
                if (data.isVendor) {
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/vendorStore'),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        Icons.auto_awesome_outlined,
                        size: 18.r,
                        color: iconColor,
                      ),
                    ),
                  );
                } else {
                  return SizedBox(width: 50); // Or any other Widget for non-vendors
                }
              },
              error: (error, stackTrace) => Text(
                ''
              ),
              loading: () => CircularProgressIndicator(),
            ),
            SizedBox(
              height: 28.h,
              width: 100.w,
              child: Image(
                image: AssetImage('assets/images/logo.png'),
                fit: BoxFit.scaleDown,
              ),
            ),
            userAsync.when(
              data:
                  (user) => GestureDetector(
                    // onTap: () => Navigator.pushNamed(context, '/profileEdit'),
                    child: CircleAvatar(
                      radius: 18.r,
                      backgroundImage:
                          user.profilePic.isNotEmpty
                              ? MemoryImage(base64Decode(user.profilePic))
                              : null,
                      child:
                          user.profilePic.isEmpty
                              ? Icon(Icons.person, size: 30)
                              : null,
                    ),
                  ),
              loading:
                  () => CircleAvatar(
                    radius: 18.r,
                    child: CircularProgressIndicator(),
                  ),
              error:
                  (e, _) =>
                      CircleAvatar(radius: 18.r, child: Icon(Icons.error)),
            ),
          ],
        ),
      ),
    );
  }
}

class DynamicCountdownDisplay extends StatefulWidget {
  final int
  initialHours; // Kept for potential future use, but not directly used for starting time now
  final int
  initialMinutes; // Kept for potential future use, but not directly used for starting time now
  final int
  initialSeconds; // Kept for potential future use, but not directly used for starting time now

  const DynamicCountdownDisplay({
    super.key,
    required this.initialHours,
    required this.initialMinutes,
    required this.initialSeconds,
  });

  @override
  State<DynamicCountdownDisplay> createState() =>
      _DynamicCountdownDisplayState();
}

class _DynamicCountdownDisplayState extends State<DynamicCountdownDisplay> {
  late Timer _timer;
  late Duration _remainingTime;

  @override
  void initState() {
    super.initState();
    _calculateTimeUntilNextMidnight(); // Calculate time to next midnight on init
    _startTimer(); // Start the countdown timer
  }

  // Method to calculate the duration until the next midnight (00:00:00 of the next day)
  void _calculateTimeUntilNextMidnight() {
    final now = DateTime.now();
    // Get the start of the next day (midnight)
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    _remainingTime = nextMidnight.difference(now);
  }

  // Method to start the periodic timer
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          // Decrement the time by one second
          _remainingTime = _remainingTime - const Duration(seconds: 1);
        } else {
          // If time runs out (it's midnight), recalculate for the *new* next day
          _timer.cancel(); // Cancel current timer
          _calculateTimeUntilNextMidnight(); // Recalculate for the next 24-hour cycle
          _startTimer(); // Restart the timer
        }
      });
    });
  }

  @override
  void dispose() {
    _timer
        .cancel(); // Cancel the timer to prevent memory leaks when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate hours, minutes, and seconds from the remaining Duration
    int hours = _remainingTime.inHours;
    int minutes = _remainingTime.inMinutes.remainder(60);
    int seconds = _remainingTime.inSeconds.remainder(60);

    // Format the time to ensure two digits for minutes and seconds (e.g., 05 instead of 5)
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = seconds.toString().padLeft(2, '0');

    return Row(
      mainAxisSize:
          MainAxisSize
              .min, // Make the row only take up as much space as its children
      children: <Widget>[
        // Alarm clock icon
        Icon(
          Icons.alarm, // Using the built-in alarm icon
          color: Colors.white,
          size: 13.r, // Adjust size to match the text
        ),
        const SizedBox(width: 8), // Space between icon and text
        // Time remaining text
        Text(
          '$hours'
          'h '
          '$formattedMinutes'
          'm '
          '$formattedSeconds'
          's remaining',
          style: TextStyle(
            color: Colors.white,
            fontSize: 11.sp, // Adjust font size to match the image
            fontWeight: FontWeight.w400, // Bold text as in the image
            fontFamily:
                'Montserrat', // Use the same font family as in the image
          ),
        ),
      ],
    );
  }
}

class ProductCard extends ConsumerStatefulWidget {
  const ProductCard({super.key, required this.product});

  // final int? index;
  final Product product;

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

bool isFavorite = false; // Initialize with product's liked status

class _ProductCardState extends ConsumerState<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final likedProductsAsyncValue = ref.watch(likedProductsProvider);

    // Determine if the current product is liked by the current user
    // This assumes likedProductsAsyncValue has data and contains the product
    bool isLikedByUser = likedProductsAsyncValue.when(
      data: (likedProducts) {
        // Check if this specific product is in the list of liked products
        // by comparing product IDs.
        return likedProducts.any(
          (likedProduct) => likedProduct.id == widget.product.id,
        );
      },
      loading:
          () => false, // While loading, assume not liked or handle as needed
      error: (err, stack) {
        print("Error checking liked status: $err");
        return false; // On error, assume not liked
      },
    );
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 5.w),
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),

              child: Stack(
                children: [
                  Image.network(
                    widget.product.imageUrl, // Placeholder image URL
                    // Replace with actual image URL
                    height: 90.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 100.h,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 50,
                          ),
                        ),
                      ); // Fallback for image loading error
                    },
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () async {
                        // isFavorite = widget.product.likedBy.contains(FirebaseAuth.instance.currentUser!.uid); // Update local state

                        // isFavorite = !isFavorite;
                        // isFavorite = !isFavorite;fd
                        await toggleLikeStatus(
                          widget.product.id,
                          widget.product.likedBy,
                          isLikedByUser,
                        );
                        // ref.refresh(likedProductsProvider);
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.8),
                        radius: 16.r,
                        child: Icon(
                          isLikedByUser
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isLikedByUser ? Colors.red : Colors.grey,
                          size: 18.r,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0), // Padding for text content
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Product Title
                  Text(
                    widget.product.name,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                    ),
                  ),
                  5.customh,
                  // Product Description
                  Text(
                    widget.product.description,
                    maxLines: 2,
                    style: TextStyle(
                      overflow: TextOverflow.fade,
                      fontSize: 10.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Montserrat',
                    ),
                  ),

                  10.customh,
                  Row(
                    children: <Widget>[
                      Text(
                        'FCFA ${widget.product.price}', // Current price
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat',
                          color: Colors.black,
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
    );
  }
}

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    required this.searchController,
    this.hintText,
    this.onChanged,
  });

  final TextEditingController searchController;
  final void Function(String)? onChanged;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade50,
            spreadRadius: 2,
            blurRadius: 20,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        onChanged: (query) => onChanged!(query),
        maxLines: 1,
        style: TextStyle(fontSize: 12.sp, fontFamily: 'Montserrat'),
        cursorColor: Colors.black,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Icon(Icons.search, size: 20.r, color: Colors.black26),
          ),

          hintText: hintText ?? 'Search any Product...',
          hintStyle: TextStyle(color: Colors.black26, fontFamily: 'Montserrat'),
          border: InputBorder.none,
          // prefixIcon: Icon(Icons.search_rounded, size: 40),
        ),
      ),
    );
  }
}

class CustomProfileInput extends StatelessWidget {
  CustomProfileInput({
    super.key,
    required this.title,
    required this.hint,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.inputFormatter,
    required this.controller,
  });

  final TextEditingController controller;
  final String title;
  final String hint;
  final Widget? prefix;
  final Widget? suffix;
  List<TextInputFormatter>? inputFormatter;
  void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            fontSize: 12.sp,
          ),
        ),
        4.customh,
        Container(
          width: double.infinity,
          height: 45.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            border: Border.all(width: 1.r, color: iconColor),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: SizedBox(
              width: double.infinity,
              height: 25.h,
              child: TextField(
                // enabled: false,
                controller: controller,
                style: TextStyle(fontSize: 13.sp, letterSpacing: 3.w),

                keyboardType: TextInputType.phone,
                inputFormatters: inputFormatter,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  // contentPadding: EdgeInsets.zero,
                  prefix: prefix,
                  suffixIcon: suffix,
                  hintText: hint,
                  hintStyle: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.black26,
                    letterSpacing: 1.w,
                  ),
                ),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
