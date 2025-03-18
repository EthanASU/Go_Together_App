import 'package:flutter/material.dart';
import '../Views/Profile_Screen_Setup.dart';
// Firebase Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser = null;

  String _studentId = '';
  String _password = '';
  String _errorMessage = '';
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

  Future<void> login(BuildContext context) async {
    if (!canSignIn) return;

    _isLoading = true;
    notifyListeners();

    try {
      String email = studentId;

      // If the input isn't and email, assume it's a Student ID and fetch corresponding email from Firestore
      if (!studentId.contains('@')) {
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .where('studentNum', isEqualTo: studentId)
            .limit(1)
            .get();

        if (querySnapshot.docs.isEmpty) {
          throw Exception("No account found with this Student ID.");
        }

        email =
            querySnapshot.docs.first['email']; // Get the email from Firestore
      }

      // Firebase Authentication (Email & Password)
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("Login successful! User ID: ${userCredential.user?.uid}");
      Navigator.pushReplacementNamed(context, '/profile');
    } catch (e) {
      print("Login failed: $e");
      _errorMessage = "Invalid credentials. Please try again.";
      notifyListeners();
    }
    _isLoading = false;
    notifyListeners();
  }
}
