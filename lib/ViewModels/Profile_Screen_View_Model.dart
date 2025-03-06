import 'package:flutter/material.dart';
import 'dart:io';

class ProfileViewModel extends ChangeNotifier{

  //fields for step 1
  String user_name = 'Raymond';          //store username for user profile
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
  void updateUserName(String name){
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
}