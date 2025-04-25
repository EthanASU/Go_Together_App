import 'package:flutter/material.dart';
import 'package:go_together_app/ViewModels/Create_Account_Flow_View_Model.dart';
import 'package:go_together_app/Views/Create_Account_Flow.dart';
import 'package:provider/provider.dart';
import '../ViewModels/LoginViewModel.dart';
import 'Profile_Screen_Setup.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    ),
  );
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 150),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Text(
                    "Welcome to",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Image.asset(
                    'Assets/go_together_logo.png',
                    height: 100,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  TextField(
                    onChanged: viewModel.updateStudentId,
                    decoration: InputDecoration(
                      labelText: "Student ID or email",
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    onChanged: viewModel.updatePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(fontSize: 16),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Forgot password logic
                      },
                      child: Text("Forgot your password?"),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (viewModel.errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        viewModel.errorMessage,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  if (viewModel.isLoading)
                    CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: () {
                        if (viewModel.canSignIn) {
                          viewModel.login(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: viewModel.canSignIn
                            ? Colors.green
                            : Colors.transparent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      // Navigate the Create account flow
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                            create: (_) =>
                                CreateAccountFlowViewModel(), // Provide the required ViewModel
                            child: const CreateAccountFlowScreen(),
                          ),
                        ),
                      );
                    },
                    child:
                        Text("Don't have an account? Create an account here!",
                            style: TextStyle(
                              fontSize: 16,
                            )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
