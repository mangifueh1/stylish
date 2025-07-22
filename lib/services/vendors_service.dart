// lib/product_data_source.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stylish/models/user_model.dart';
import '../models/product_model.dart';

final vendorsProvider = StreamProvider<List<UserModel>>((ref) {
  try {
    return FirebaseFirestore.instance.collection('users').snapshots().map((
      snapshot,
    ) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          return UserModel(
            isVendor: doc['isVendor'],
            location: doc['location'],
            phone: doc['phone'],
            profilePic: doc['profilePic'],
            username: doc['username'],
          );
        }).toList();
      } else {
        print("No users found.");
        return []; // Return empty list if no data
      }
    });
  } catch (e) {
    print("Error fetching users: $e");
    throw e; // Re-throw to let the provider handle the error
  }
});
final singleVendorsProvider = FutureProvider<UserModel>((ref) async { // Changed to FutureProvider and added async
  final user = FirebaseAuth.instance.currentUser; // Get the current user
  if (user == null) {
    // Handle the case where there is no logged-in user
    print("No user logged in.");
    return UserModel( // Return a default UserModel or throw an error
      username: '',
      phone: '',
      profilePic: '',
      isVendor: false,
      location: "",
    );
  }

  try {
    // Await the document snapshot from Firestore
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid) // Use user.uid for the document ID
        .get(); // Use .get() for a single fetch

    final data = snapshot.data();

    if (data != null) {
      return UserModel(
        isVendor: (data as Map<String, dynamic>)['isVendor'], // Cast data to Map<String, dynamic>
        location: (data)['location'],
        phone: (data)['phone'],
        profilePic: (data)['profilePic'],
        username: (data)['username'],
      );
    } else {
      print("No User found for ID: ${user.uid}");
      return UserModel(
        username: '',
        phone: '',
        profilePic: '',
        isVendor: false,
        location: "",
      ); // Return a default UserModel if no data
    }
  } catch (e) {
    print("Error fetching User: $e");
    throw e; // Re-throw to let the provider handle the error
  }
});
