// lib/product_data_source.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';

final productsProvider = StreamProvider<List<Product>>((ref) {
  try {
    return FirebaseFirestore.instance
        .collection('products').snapshots()
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
      print("No products found.");
      return []; // Return empty list if no data
    }});
  } catch (e) {
    print("Error fetching products: $e");
    throw e; // Re-throw to let the provider handle the error
  }
});

