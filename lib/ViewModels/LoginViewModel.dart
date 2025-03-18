import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser;

  String studentIdOrEmail = '';
  String password = '';
  bool isLoading = false;
  String errorMessage = '';

  void updateStudentId(String value) {
    studentIdOrEmail = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    password = value;
    notifyListeners();
  }

  bool get canSignIn => studentIdOrEmail.isNotEmpty && password.isNotEmpty;

  // This login function will handle email & student ID
  Future<void> login(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      String email = studentIdOrEmail;

      // If the input isn't and email, assume it's a Student ID and fetch corresponding email from Firestore
      if (!studentIdOrEmail.contains('@')) {
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .where('studentNum', isEqualTo: studentIdOrEmail)
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
      errorMessage = "Invalid credentials. Please try again.";
      notifyListeners();
    }
    isLoading = false;
    notifyListeners();
  }
}
