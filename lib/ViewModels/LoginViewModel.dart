import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginViewModel extends ChangeNotifier {
  User? currentUser = null;

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
      // Authenticate user with credentials
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _studentId, password: _password);

      // TODO: Navigate user to the profile page and load their information
      currentUser = userCredential.user;
      print("Login successful!");
    } catch (e) {
      print("Login failed: $e");
      // Show an error message to the user
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
