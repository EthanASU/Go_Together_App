import 'dart:ffi';

import 'package:flutter/material.dart';
import '../Models/step_data.dart';

import '../Storage/UserStorage.dart'; // Local Storage
import '../FirebaseInstance.dart'; // Remote Storage

class Account {
  final String firstName;
  final String lastName;
  final String studentNumber;
  final String emailAddress;
  final String phoneNumber;

  final String password;
  String? _selectedRole;
  String? _selectedSchool;

  // Constructor and required fields
  Account(
      {required this.firstName,
      required this.lastName,
      required this.studentNumber,
      required this.emailAddress,
      required this.phoneNumber,
      required this.password});
}

class CreateAccountFlowViewModel extends ChangeNotifier {
  int _currentStep = 0;
  final int totalSteps = 4;

  // Step 1: User role
  String? _selectedRole;

  // Step 2: School selection
  String? _selectedSchool;
  List<String> schools = [
    "Thomas Gregg",
    "Matchbook Learning",
    "Kinedezi Academy",
    "Carl Wilde"
  ];

  // Step 3: User info
  String firstName = '';
  String lastName = '';
  String studentNumber = '';
  String emailAddress = '';
  String phoneNumber = '';

  // Step 4: Passwords
  String password = '';
  String confirmPassword = '';

  int get currentStep => _currentStep;
  String? get selectedRole => _selectedRole;
  String? get selectedSchool => _selectedSchool;
  // Check if password match
  bool get passwordsMatch => password.isNotEmpty && password == confirmPassword;

  // Possibly unused method below
  // Create a new User object
  Account createUser() {
    // Perform checks on user credentials to make sure nothing critical is missing

    // Create a new User object to store in database
    Account account = Account(
        firstName: firstName,
        lastName: lastName,
        studentNumber: studentNumber,
        emailAddress: emailAddress,
        phoneNumber: phoneNumber,
        password: password);

    return account;
  }

  // Validation
  bool isStepValid() {
    switch (_currentStep) {
      case 0:
        return selectedRole != null;
      case 1:
        return selectedSchool != null;
      case 2:
        return firstName.isNotEmpty &&
            lastName.isNotEmpty &&
            studentNumber.isNotEmpty &&
            emailAddress.isNotEmpty &&
            phoneNumber.isNotEmpty;
      case 3:
        return passwordsMatch;
      default:
        return false;
    }
  }

  void updatePassword(String value) {
    password = value;
    notifyListeners();
  }

  void updateConfirmPassword(String value) {
    confirmPassword = value;
    notifyListeners();
  }

  void updateFirstName(String value) {
    firstName = value;
    notifyListeners();
  }

  void updateLastName(String value) {
    lastName = value;
    notifyListeners();
  }

  void updateStudentNumber(String value) {
    studentNumber = value;
    notifyListeners();
  }

  void updateEmailAddress(String value) {
    emailAddress = value;
    notifyListeners();
  }

  void updatePhoneNumber(String value) {
    phoneNumber = value;
    notifyListeners();
  }

  void selectSchool(String? school) {
    _selectedSchool = school;
    notifyListeners();
  }

  void setRole(String role) {
    _selectedRole = role;
    notifyListeners();
  }

  void previousStep() {
    if (currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  List<StepData> pageHeaders = [
    StepData('Thanks for choosing'),
    StepData('Create account'),
    StepData('Create account'),
    StepData(''),
  ];

  Color getArrowColor(int arrowIndex) {
    if (arrowIndex == 0) return Colors.orange.shade400;
    if (arrowIndex == 1)
      return _currentStep >= 1 ? Colors.green : Colors.grey.shade300;
    if (arrowIndex == 2)
      return _currentStep >= 2 ? Colors.amber.shade900 : Colors.grey.shade300;
    if (arrowIndex == 3)
      return _currentStep >= 3
          ? Colors.lightBlue.shade700
          : Colors.grey.shade300;
    return Colors.grey.shade300;
  }

  void nextStep() {
    if (_currentStep < totalSteps - 1) {
      _currentStep++;
      notifyListeners();
    }
  }

  // ******************** Firebase Methods *************************
  // Store new user in Firebase
  Future<bool> CreateAccount() async {
    // Assign Other User Properties

    // Store basic user information locally
    // in a static class
    UserStorage.FirstName = firstName;
    UserStorage.LastName = lastName;
    UserStorage.StudentNumber = int.parse(studentNumber);
    UserStorage.Email = emailAddress;
    UserStorage.PhoneNumber = phoneNumber;
    UserStorage.Password = password;

    if (FirebaseInstance.Instance != null) {
      return await FirebaseInstance.Instance!.CreateAccountOnFirebase();
    } else {
      print("Error: FirebaseInstance is null");
      return false;
    }
  }
}
