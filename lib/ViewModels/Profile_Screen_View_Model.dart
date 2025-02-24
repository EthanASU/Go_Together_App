import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier{
  String userName = 'Raymond';  // Placeholder
  int completedRides = 0; // Placeholder
  bool isProfileComplete = false; // Placeholder for profile completion check

  ProfileViewModel() {
    fetchUserName(); // Fetch user data when the ViewModel is created
  }

  Future<void> fetchUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          final data = userDoc.data() as Map<String, dynamic>;
          userName = data['firstName'] ?? "User"; // Default to "User" if missing
          notifyListeners();
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }
}