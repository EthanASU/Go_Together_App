import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Make sure this import works
import 'ViewModels/LoginViewModel.dart'; // Adjust the path as per your project structure
import 'Views/LoginView.dart'; // Adjust the path for your login page
import 'Views/Splash_Screen.dart';
import 'Views/profile_screen_setup.dart';
import 'Views/Profile_Personal_SetUp.dart';
// Firebase Imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (_) => LoginViewModel(),
//       child: MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: SplashScreenWithDelay(),
//     );
//   }
// }
//
// class SplashScreenWithDelay extends StatefulWidget {
//   @override
//   _SplashScreenWithDelayState createState() => _SplashScreenWithDelayState();
// }
//
// class _SplashScreenWithDelayState extends State<SplashScreenWithDelay> {
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => MyHomePage()),
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SplashScreen();
//   }
// }
Future<void> main() async {
  // Must use this to initialize Firebase; must be async
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoTogether',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Set ProfileScreen as the home widget instead of your login/create account flow
      home: MyHomePage(), // Start at login screen
    );
  }
}
