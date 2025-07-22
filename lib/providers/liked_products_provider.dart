// lib/product_data_source.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';

final likedProductsProvider = StreamProvider<List<Product>>((ref) {
  try {
    return FirebaseFirestore.instance
        .collection('products')
        .where(
          'likedBy',
          arrayContains: FirebaseAuth.instance.currentUser!.uid.toString(),
        )
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            return snapshot.docs.map((doc) {
              return Product(
                id: doc.id,
                name: doc['name'],
                description: doc['description'],
                imageUrl: doc['image'],
                price: doc['price'].toDouble(),
                likedBy: doc['likedBy'] ?? [],
              );
            }).toList();
          } else {
            final userId = FirebaseAuth.instance.currentUser?.uid;
            print("Error: No liked products found for user $userId");
            print("No products found.");
            return []; // Return empty list if no data
          }
        });
  } catch (e) {
    print("Error fetching products: $e");
    throw e; // Re-throw to let the provider handle the error
  }
});

Future<void> toggleLikeStatus(
  String productId,
  List likedBy,
  bool isLiked,
) async {
  if (isLiked == false) {
    try {
      final updatedLikedBy = List.from(likedBy)
        ..add(FirebaseAuth.instance.currentUser!.uid);
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .update({'likedBy': updatedLikedBy});
    } catch (e) {
      print('Error updating like status: $e');
    }
  } else {
    try {
      final updatedLikedBy = List.from(likedBy)
        ..remove(FirebaseAuth.instance.currentUser!.uid);
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .update({'likedBy': updatedLikedBy});

      isLiked = false; // Update local state if needed
    } catch (e) {
      print('Error updating like status: $e');
    }
    
  }
}
