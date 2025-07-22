import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stylish/colors.dart';
import 'package:stylish/extensions/space_exs.dart';
import 'package:stylish/services/product_data_source.dart';
import 'package:stylish/services/vendors_service.dart';
import 'package:stylish/widgets.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  int currentIndex = 1;
  PageController productPageController = PageController(viewportFraction: 0.5);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: bkgColor,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 15.w,
                      right: 15.w,
                      top: 60.h,
                    ),
                    child: Text(
                      'All Featured',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                  20.customh,
                  vendorList(),
                  20.customh,
                  adSlider(),
                  15.customh,
                  dealOfTheDayTimer(),
                  15.customh,
                  homeProductCards(),
                  15.customh,
                  specialOffer(),
                ],
              ),
            ),
            Column(
              children: [CustomAppBar(), Spacer(), CustomNavBar(whatPage: 0)],
            ),
          ],
        ),
      ),
    );
  }

  Widget vendorList() {
    final vendors = ref.watch(vendorsProvider);
    return vendors.when(
      data: (vendor) {
        return Container(
          width: double.infinity,
          height: 80.h,
          margin: EdgeInsets.only(left: 15.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.horizontal(left: Radius.circular(10.r)),
            // boxShadow: [
            //   BoxShadow(
            //     spreadRadius: 3,
            //     color: Colors.grey.shade50,
            //     blurRadius: 5,
            //     // offset: Offset(10, 10),
            //   ),
            // ],
          ),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 25.r,
                      backgroundColor: mainColorFade,
                      foregroundImage:
                          vendor[index].profilePic.isNotEmpty
                              ? MemoryImage(
                                base64Decode(vendor[index].profilePic),
                              )
                              : null,
                      child: Icon(Icons.person, size: 20.r),
                    ),
                    Text(
                      vendor[index].username,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: vendor.length,
            scrollDirection: Axis.horizontal,
          ),
        );
      },
      error: (error, stackTrace) => Text("Error: $error"),
      loading: () => CircularProgressIndicator(),
    );
  }

  Container specialOffer() {
    return Container(
      width: double.infinity,
      height: 65.h,
      margin: EdgeInsets.only(bottom: 60.w, left: 15.w, right: 15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(spreadRadius: 3, color: Colors.grey.shade50, blurRadius: 5),
        ],
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/special_offer.png',
                width: 60.w,
                height: 60.h,
              ),
              10.customw,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Special Offer',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  Text(
                    'We make sure you get the \noffer you need at the best prices',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget homeProductCards() {
    final product = ref.watch(productsProvider);
    return product.when(
      data:
          (products) => Stack(
            alignment: Alignment.centerRight,
            children: [
              SizedBox(
                // margin: EdgeInsets.only(bottom: 60.h),
                // padding: EdgeInsets.symmetric(horizontal: 10.w),
                width: double.infinity,
                height: 200.h,
                child: PageView.builder(
                  controller: productPageController,
                  padEnds: false,

                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: products[index]);
                  },
                ),
              ),
              Container(
                height: 35.h,
                width: 35.w,
                margin: EdgeInsets.only(right: 10.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // color: Color(0xFFBBBBBB),
                  gradient: RadialGradient(
                    colors: [
                      Color.fromARGB(32, 187, 187, 187),
                      Color.fromARGB(151, 187, 187, 187),
                    ],
                  ),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.shade200,
                  //     blurRadius: 5,
                  //     offset: Offset(0, 3),
                  //   ),
                  // ],
                ),
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 15.r,
                      color: iconColor,
                    ),
                    onPressed: () {
                      productPageController.nextPage(
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
      error:
          (error, stack) => Center(
            child: Text(
              'Error loading products: $error',
              style: TextStyle(fontSize: 16.sp, color: Colors.red),
            ),
          ),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }

  Widget dealOfTheDayTimer() {
    return Container(
      width: double.infinity,
      height: 50.h,
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        color: mainBlue,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(spreadRadius: 3, color: Colors.grey.shade50, blurRadius: 5),
        ],
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deal of the Day',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  DynamicCountdownDisplay(
                    initialHours: DateTime.now().hour,
                    initialMinutes: DateTime.now().minute,
                    initialSeconds: DateTime.now().second,
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 10.w),
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.5.h),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.5),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    5.customw,
                    Icon(Icons.arrow_forward, color: Colors.white, size: 14.r),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget adSlider() {
    return Column(
      children: [
        CarouselSlider.builder(
          options: CarouselOptions(
            initialPage: 1,
            autoPlayInterval: const Duration(seconds: 10),
            height: 150.h,
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            viewportFraction: 1,

            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          itemCount: 3,
          itemBuilder: (
            BuildContext context,
            int itemIndex,
            int pageViewIndex,
          ) {
            return Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 15.w),
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(itemIndex.toString()),
            );
          },
        ),
        Container(
          width: double.infinity,
          height: 6.h,
          // color: Colors.black,
          margin: EdgeInsets.only(top: 5.h),
          alignment: Alignment.center,
          child: ListView.builder(
            shrinkWrap: true,

            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Container(
                  width: currentIndex == index ? 15.w : 5.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color:
                        currentIndex == index
                            ? mainColorFade
                            : Colors.grey.shade300,
                    shape:
                        currentIndex == index
                            ? BoxShape.rectangle
                            : BoxShape.circle,
                    borderRadius:
                        currentIndex == index
                            ? BorderRadius.circular(3.r)
                            : null,
                  ),
                ),
              );
            },
            itemCount: 3,
            scrollDirection: Axis.horizontal,
          ),
        ),
      ],
    );
  }
}
