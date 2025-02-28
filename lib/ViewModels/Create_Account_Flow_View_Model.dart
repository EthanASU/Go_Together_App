import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Models/step_data.dart';

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
  final firebaseAuth =
      FirebaseAuth.instance; // Reference to the Firebase Auth Object
  final firestoreDB =
      FirebaseFirestore.instance; // Reference to the Firestore Database
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

  // Store new user in Firebase
  Future<void> passUserToFirebase(Account acc) async {
    // Assign Other User Properties
    User? user = null;

    try {
      // Create User Email and Password
      final UserCredential userCredential =
      await firebaseAuth.createUserWithEmailAndPassword(
          email: acc.emailAddress, password: acc.password);

      //  TODO: Verify Phone Number
      /* Attempt at adding phone number to account
      user = userCredential.user;
      if (user != null) {
        // Update Display Name
        String displayName = "${acc.firstName} ${acc.lastName}";
        await user.updateDisplayName(displayName);

        // Verify the phone number before it can be applied to the account
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await FirebaseAuth.instance.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            if (e.code == 'invalid-phone-number') {
              print('The provided phone number is not valid.');
            }
          },
          codeSent: (String verificationId, int? resendToken) async {
            // Update the UI - wait for the user to enter the SMS code
            String smsCode = 'xxxx';

            // Create a PhoneAuthCredential with the code
            PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: verificationId, smsCode: smsCode);

            // Sign the user in (or link) with the credential
            await FirebaseAuth.instance.signInWithCredential(credential);
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            // Auto-resolution timed out...
          },
        );
        */
      // TODO: Verify Email
    } catch (e) {
      print("Error creating account on Firebase");
    } finally {
      print(user);
    }
  }

  void storeUserDataInFirestore(Account acc) {
    final accInfo = <String, dynamic>{
      "first": firstName,
      "last": lastName,
      "studentNum": studentNumber,
      "email": emailAddress,
      "phone": phoneNumber,
      "password": password,
      "drivePref": false,
      "bikePref": false,
      "walkPref": false
    };

    try {
      firestoreDB.collection("userInfo").add(accInfo).then(
              (DocumentReference doc) =>
              print('DocumentSnapshot added with ID: ${doc.id}'));
    } catch (e) {
      print("Error adding document: $e");
    }
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

  Future<bool> createAccountOnFirebase() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      // Store user in details in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': emailAddress,
      });

      return true; // Account created
    } catch (e) {
      print("Error creating account: $e");
      return false; // Account creation failed
    }
  }
}
