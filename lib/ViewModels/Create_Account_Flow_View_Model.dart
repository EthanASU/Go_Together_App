import 'dart:ffi';

import 'package:flutter/material.dart';
import '../Models/step_data.dart';

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
  List<String> schools = ["Thomas Gregg", "Matchbook Learning", "Kinedezi Academy", "Carl Wilde"];

  int get currentStep => _currentStep;
  String? get selectedRole => _selectedRole;
  String? get selectedSchool => _selectedSchool;
  // Check if password match
  bool get passwordsMatch => password.isNotEmpty && password == confirmPassword;

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
    if (arrowIndex == 1) return _currentStep >= 1 ? Colors.green : Colors.grey.shade300;
    if (arrowIndex == 2) return _currentStep >= 2 ? Colors.amber.shade900 : Colors.grey.shade300;
    if (arrowIndex == 3) return _currentStep >= 3 ? Colors.lightBlue.shade700 : Colors.grey.shade300;
    return Colors.grey.shade300;
  }

  void nextStep() {
    if (_currentStep < totalSteps - 1) {
      _currentStep++;
      notifyListeners();
    }
  }
}