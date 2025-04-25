import 'package:flutter/material.dart';
import '../Views/Profile_Screen_Setup.dart';

import '../Storage/UserStorage.dart'; // Local Storage
import '../FirebaseInstance.dart'; // Remote Storage

class LoginViewModel extends ChangeNotifier {
  String _studentId = '';
  String _password = '';
  String _errorMessage = '';
  bool _isLoading = false;
  String get studentId => _studentId;
  String get password => _password;
  String get errorMessage => _errorMessage;

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

  // ********************** Firebase Methods *************************
  Future<void> login(BuildContext context) async {
    if (!canSignIn) return;

    _isLoading = true;
    notifyListeners();

    bool result = false;
    if (FirebaseInstance.Instance != null) {
      result = await FirebaseInstance.Instance!.Login(studentId, password);
    } else {
      print("Error: FirebaseInstance is null");
      result = false;
    }

    if (result) {
      // Fetch all user data from db in one call
      await FirebaseInstance.Instance?.fetchAllFromFirebase();
      Navigator.pushReplacementNamed(context, '/profile');
    } else {
      _errorMessage = "Invalid credentials. Please try again.";
      notifyListeners();
    }
    _isLoading = false;
    notifyListeners();
  }
}
