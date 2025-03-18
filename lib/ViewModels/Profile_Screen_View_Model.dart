import 'package:flutter/material.dart';
// Firebase Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileViewModel extends ChangeNotifier {
  String userName = ''; // Placeholder
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
          userName =
              data['firstName'] ?? "User"; // Default to "User" if missing
          notifyListeners();
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }
}

/*  OLD CLASS (DEPRICATED)
import 'package:flutter/material.dart';
import 'dart:io';
// Firebase Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileViewModel extends ChangeNotifier {
  // Firestore Reference
  final firestoreDB =
      FirebaseFirestore.instance; // Reference to the Firestore Database

  //fields for step 1
  String user_name = "N/A"; //store username for user profile
  List<String> your_friends = []; //data structure storing list of friends
  int completed_rides = 0;
  bool is_Profile_Complete = false;
  String _profileImagePath = '';

  String get userName => user_name;
  List<String> get yourFriends => your_friends;
  int get completedRides => completed_rides;
  bool get isProfileComplete => is_Profile_Complete;
  String get profileImagePath => _profileImagePath;

  int _currentStep = 0;
  final int totalSteps = 4;

  int get currentStep => _currentStep;

  Future<void> updateProfileImage(String imagePath) async {
    _profileImagePath = imagePath;
    notifyListeners();
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
  Future<void> completeProfileSetup() async {
    is_Profile_Complete = true;
    user_name =
        await grabUserFirstNameFromFirestore(); // Grab first name from Firestore
    notifyListeners();
  }

  void nextStep() {
    if (_currentStep < totalSteps - 1) {
      _currentStep++;
      notifyListeners();
    }
  }

  //--------------- Fire Store Methods ---------------//
  /// Retrieve User's First Name from database
  Future<String> grabUserFirstNameFromFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot documentSnapshot = await firestoreDB
            .collection('users') // Collection name
            .doc(user.uid) // Document ID, typically the User UID
            .get(); // Retrieves the document

        if (documentSnapshot.exists) {
          // Check if the document exists and read the "firstName" field
          String firstName =
              documentSnapshot.get('firstName') ?? 'No name found';
          return firstName;
        } else {
          return 'No user document found';
        }
      } catch (e) {
        // Handle any errors here
        return 'Error fetching user name: $e';
      }
    } else {
      return 'No user logged in';
    }
  }
}
 */
