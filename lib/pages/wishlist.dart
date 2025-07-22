// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stylish/colors.dart';
import 'package:stylish/extensions/space_exs.dart';
import 'package:stylish/providers/liked_products_provider.dart';
// import 'package:stylish/products/product_model.dart';
import 'package:stylish/providers/search_query_provider.dart';
import 'package:stylish/widgets.dart';

class Wishlist extends ConsumerStatefulWidget {
  const Wishlist({super.key});

  @override
  ConsumerState<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends ConsumerState<Wishlist> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      if (searchController.text != ref.read(searchQueryProvider)) {
        ref.read(searchQueryProvider.notifier).state = searchController.text;
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the liked products from the provider
    final asyncLikedProducts = ref.watch(likedProductsProvider);
    // Watch the current search query from the provider
    final searchQuery = ref.watch(searchQueryProvider);
    // final likedProducts = ref.watch(likedProductsProvider);
    return Scaffold(
      // backgroundColor: bkgColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                60.customh,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                  child: CustomSearchBar(
                    hintText: 'Search Wishlist',
                    searchController: searchController,
                    onChanged: (query) {
                      // Update the search query provider whenever text changes

                      ref.read(searchQueryProvider.notifier).state = query;
                    },
                  ),
                ),
                20.customh,
                Padding(
                  padding: EdgeInsets.only(left: 10.0.w),
                  child: Text(
                    'Wishlist( ${asyncLikedProducts.asData?.value.length ?? 0} )',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                20.customh,

                Expanded(
                  child: asyncLikedProducts.when(
                    data: (allLikedProducts) {
                      final filteredProducts =
                          allLikedProducts.where((product) {
                            final productNameLower = product.name.toLowerCase();
                            final searchQueryLower = searchQuery.toLowerCase();
                            return productNameLower.contains(searchQueryLower);
                          }).toList();

                      if (searchQuery.isEmpty) {
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisExtent: 200.h,
                              ),
                          itemCount: filteredProducts.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            // Replace with your product card widget
                            return ProductCard(
                              product: filteredProducts[index],
                            );
                          },
                        );
                        ;
                      }
                      return filteredProducts.isEmpty
                          ? Center(
                            child: Text(
                              'Nothing to Show',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          )
                          : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 200.h,
                                ),
                            itemCount: filteredProducts.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              // Replace with your product card widget
                              return ProductCard(
                                product: filteredProducts[index],
                              );
                            },
                          );
                    },

                    error:
                        (error, stack) => Center(
                          child: Text(
                            'Error loading products: $error',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.red,
                            ),
                          ),
                        ),
                    loading: () => Center(child: CircularProgressIndicator()),
                  ),
                ),
              ],
            ),
            Column(
              children: [CustomAppBar(), Spacer(), CustomNavBar(whatPage: 1)],
            ),
          ],
        ),
      ),
    );
  }
}
