import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  String _studentId = '';
  String _password = '';
  bool _isLoading = false;
  String get studentId => _studentId;
  String get password => _password;

  bool get isLoading => _isLoading;
  bool get canSignIn => _studentId.isNotEmpty && _password.isNotEmpty;

  void updateStudentId(String value) {
    _studentId = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    _password = value;
    notifyListeners();
  }

 Future<void> login() async {
    if (!canSignIn) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate a network request with a delay
      await Future.delayed(Duration(seconds: 2));

      // Replace with actual authentication logic
      if (_studentId == "test@example.com" && _password == "password123") {
        print("Login successful!");
        // Navigate to the next screen or update the UI
      } else {
        throw Exception("Invalid credentials");
      }
    } catch (e) {
      print("Login failed: $e");
      // Show an error message to the user
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}