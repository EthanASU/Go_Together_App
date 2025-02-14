import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Models/step_data.dart';

class User {
  final String firstName;
  final String lastName;
  final String studentNumber;
  final String emailAddress;
  final String phoneNumber;

  final String password;
  String? _selectedRole;
  String? _selectedSchool;

  // Constructor and required fields
  User(
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

  // Fields for third step
  String firstName = '';
  String lastName = '';
  String studentNumber = '';
  String emailAddress = '';
  String phoneNumber = '';

  // Fields for fourth step
  String password = '';
  String confirmPassword = '';

  String? _selectedRole;
  String? _selectedSchool;
  List<String> schools = [
    "Thomas Gregg",
    "Matchbook Learning",
    "Kinedezi Academy",
    "Carl Wilde"
  ];

  int get currentStep => _currentStep;
  String? get selectedRole => _selectedRole;
  String? get selectedSchool => _selectedSchool;
  // Check if password match
  bool get passwordsMatch => password.isNotEmpty && password == confirmPassword;

  // Create a new User object
  User createUser() {
    // TODO: perform checks on user credentials to make sure nothing critical is missing

    // Create a new User object to store in database
    User user = User(
        firstName: firstName,
        lastName: lastName,
        studentNumber: studentNumber,
        emailAddress: emailAddress,
        phoneNumber: phoneNumber,
        password: password);

    return user;
  }

  // Store new user in Firebase
  void passUserToFirebase(User user) {
    final credential = FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.emailAddress, password: user.password);
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

  void createAccountOnFirebase() {
    User user = createUser();
    // TODO: perform checks on user credentials to make sure nothing critical is missing
    passUserToFirebase(user);
  }
}
