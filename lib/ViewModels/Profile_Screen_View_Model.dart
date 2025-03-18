import 'package:flutter/material.dart';
import 'dart:io';
// Firebase Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileViewModel extends ChangeNotifier {
  //fields for step 1
  String user_name = 'Unknown_User'; // Placeholder
  List<String> your_friends = []; //data structure storing list of friends
  int completed_rides = 0; // Placeholder
  bool is_Profile_Complete = false; // Placeholder for profile completion check
  String _profileImagePath = '';

  String get userName => user_name;
  List<String> get yourFriends => your_friends;
  int get completedRides => completed_rides;
  bool get isProfileComplete => is_Profile_Complete;
  String get profileImagePath => _profileImagePath;

  int _currentStep = 0;
  final int totalSteps = 4;
  int get currentStep => _currentStep;

  ProfileViewModel() {
    fetchUserName(); // Fetch user data when the ViewModel is created
  }

  //updates the User Name
  void updateUserName(String name) {
    user_name = name;
    notifyListeners();
  }

//updates the number of rides completed
  void updateRidesCompleted(int rides) {
    completed_rides = rides;
    notifyListeners();
  }

//updates the completion of profile page
  void completeProfileSetup() {
    is_Profile_Complete = true;
    notifyListeners();
  }

  void nextStep() {
    if (_currentStep < totalSteps - 1) {
      _currentStep++;
      notifyListeners();
    }
  }

  /// -------- Firebase Methods ------
  Future<void> updateProfileImage(String imagePath) async {
    _profileImagePath = imagePath;
    notifyListeners();
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
          user_name =
              data['firstName'] ?? "User"; // Default to "User" if missing
          notifyListeners();
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }
}
