// lib/product_data_source.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stylish/models/user_model.dart';
import '../models/product_model.dart';

final userInfoProvider = StreamProvider<UserModel>((ref) {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  try {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
          final data = snapshot.data();

          if (data != null) {
            return UserModel(
              isVendor: data['isVendor'],
              location: data['location'],
              phone: data['phone'],
              profilePic: data['profilePic'],
              username: data['username'],
              // id: data['id'],
            );
          } else {
            print("No User found.");
            return UserModel(
              username: '',
              phone: '',
              profilePic: '',
              isVendor: false,
              location: "",
            ); // Return empty list if no data
          }
        });
  } catch (e) {
    print("Error fetching User: $e");
    throw e; // Re-throw to let the provider handle the error
  }
});
