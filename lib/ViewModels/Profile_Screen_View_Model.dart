import 'package:flutter/material.dart';
import 'dart:io';

class ProfileViewModel extends ChangeNotifier{


  String _userName = 'Raymond'; //place holder for user's name
  List<String> _yourFriends = [];
  int _completedRides = 0;
  bool _isProfileComplete = false;
  String _profileImagePath = '';
  int _currentStep = 0;
  final int totalSteps = 4;

  // Profile Information
  String _emailAddress = '';
  String _phoneNumber = '';
  List<Map<String, dynamic>> _addresses = [];
  List<Map<String, dynamic>> _emergencyContacts = [];

  // Getters for Basic Information
  String get userName => _userName;
  List<String> get yourFriends => _yourFriends;
  int get completedRides => _completedRides;
  String get profileImagePath => _profileImagePath;
  int get currentStep => _currentStep;

  // Getters for Profile Information
  String get emailAddress => _emailAddress;
  String get phoneNumber => _phoneNumber;
  List<Map<String, dynamic>> get addresses => _addresses;
  List<Map<String, dynamic>> get emergencyContacts => _emergencyContacts;

  // Profile Completion Status
  bool get isProfileComplete {
    return _emailAddress.isNotEmpty ||
        _phoneNumber.isNotEmpty ||
        _addresses.isNotEmpty ||
        _emergencyContacts.isNotEmpty;
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
    _addresses.add(address);
    notifyListeners();
  }

  void addEmergencyContact(Map<String, dynamic> contact) {
    _emergencyContacts.add(contact);
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
    _addresses = List.from(newAddresses);
    _isProfileComplete = true;
    notifyListeners();
  }
  void updateUserInfo({

    required List<Map<String, dynamic>> addresses

  }) {

    _addresses = List.from(addresses);
    _isProfileComplete = true;
    notifyListeners();
  }

  void updateEmergencyContacts(List<Map<String, dynamic>> newContacts) {
    _emergencyContacts = List.from(newContacts);
    notifyListeners();
  }
}
