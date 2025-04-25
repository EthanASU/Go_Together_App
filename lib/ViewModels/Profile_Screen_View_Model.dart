import 'package:flutter/material.dart';
import 'dart:io';

import '../Storage/UserStorage.dart'; // Local Storage
import '../FirebaseInstance.dart'; // Remote Storage

class ProfileViewModel extends ChangeNotifier {
  //fields for step 1
  String _userName = 'Unknown_User'; // Placeholder
  List<String> _yourFriends = []; //data structure storing list of friends
  int _completedRides = 0; // Placeholder
  bool _isProfileComplete = false; // Placeholder for profile completion check
  String _profileImagePath = '';

  int _currentStep = 0;
  final int totalSteps = 4;

  // Profile Information
  String _emailAddress = '';
  String _phoneNumber = '';

  // Getters for Basic Information
  String get userName => _userName;
  List<String> get yourFriends => _yourFriends;
  int get completedRides => _completedRides;
  String get profileImagePath => _profileImagePath;
  int get currentStep => _currentStep;

  // Getters for Profile Information
  String get emailAddress => _emailAddress;
  String get phoneNumber => _phoneNumber;
  List<Map<String, dynamic>> get addresses => UserStorage.Addresses;
  List<Map<String, dynamic>> get emergencyContacts =>
      UserStorage.EmergencyContacts;

  // Constructor
  ProfileViewModel() {
    _userName =
        UserStorage.FirstName; // Fetch user data when the ViewModel is created
    _emailAddress = UserStorage.Email;
    _phoneNumber = UserStorage.PhoneNumber;
  }

  // Profile Completion Status
  bool get isProfileComplete {
    return _emailAddress.isNotEmpty ||
        _phoneNumber.isNotEmpty ||
        UserStorage.Addresses.isNotEmpty ||
        UserStorage.EmergencyContacts.isNotEmpty;
  }

  // Update Methods
  Future<void> updateProfileImage(String imagePath) async {
    _profileImagePath = imagePath;
    notifyListeners();
  }

  void updateUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void updateRidesCompleted(int rides) {
    _completedRides = rides;
    notifyListeners();
  }

  void completeProfileSetup() {
    _isProfileComplete = true;
    notifyListeners();
  }

  void nextStep() {
    if (_currentStep < totalSteps - 1) {
      _currentStep++;
      notifyListeners();
    }
  }

  // Update Profile Information Methods
  void updateEmailAddress(String email) {
    print('Updating email in Main VM: $email');
    _emailAddress = email;
    notifyListeners();
  }

  void updatePhoneNumber(String phone) {
    print('Updating phone in Main VM: $phone');
    _phoneNumber = phone;
    notifyListeners();
  }

  void addAddress(Map<String, dynamic> address) {
    UserStorage.Addresses.add(address);
    notifyListeners();
  }

  void addEmergencyContact(Map<String, dynamic> contact) {
    UserStorage.EmergencyContacts.add(contact);
    notifyListeners();
  }

  // Helper Methods
  String formatAddress(Map<String, dynamic> address) {
    return '${address['streetAddress']}\n${address['city']}, ${address['state']} ${address['zipCode']}';
  }

  Map<String, dynamic>? get schoolAddress {
    return null;
  }

  void updateAddresses(List<Map<String, dynamic>> newAddresses) {
    UserStorage.Addresses = List.from(newAddresses);
    _isProfileComplete = true;
    notifyListeners();
  }

  void updateUserInfo({required List<Map<String, dynamic>> addresses}) {
    UserStorage.Addresses = List.from(addresses);
    _isProfileComplete = true;
    notifyListeners();
  }

  void updateEmergencyContacts(List<Map<String, dynamic>> newContacts) {
    UserStorage.EmergencyContacts = List.from(newContacts);
    notifyListeners();
  }

  Future<void> logout() async {
    await FirebaseInstance.Instance?.Logout(); // Logout of Firebase
    UserStorage.ClearAll(); // Clear all local storage
    notifyListeners();
  }
}
