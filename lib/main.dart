import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Make sure this import works
import 'ViewModels/LoginViewModel.dart'; // Adjust the path as per your project structure
import 'Views/LoginView.dart'; // Adjust the path for your login page
import 'Views/Splash_Screen.dart';
import 'Views/profile_screen_setup.dart';
import 'Views/Profile_Personal_SetUp.dart';
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
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Set ProfileScreen as the home widget instead of your login/create account flow
      home: const ProfileSetUp(),  // Update this to match your class name
    );
  }
}
