import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Make sure this import works
import 'ViewModels/LoginViewModel.dart'; // Adjust the path as per your project structure
import 'Views/LoginView.dart'; // Adjust the path for your login page
import 'Views/Splash_Screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenWithDelay(),
    );
  }
}

class SplashScreenWithDelay extends StatefulWidget {
  @override
  _SplashScreenWithDelayState createState() => _SplashScreenWithDelayState();
}

class _SplashScreenWithDelayState extends State<SplashScreenWithDelay> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
