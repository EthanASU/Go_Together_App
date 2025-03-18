import 'package:flutter/material.dart';
import 'package:go_together_app/ViewModels/Create_Account_Flow_View_Model.dart';
import 'package:go_together_app/Views/Create_Account_Flow.dart';
import 'package:provider/provider.dart';
import '../ViewModels/LoginViewModel.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    ),
  );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

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
            const SizedBox(height: 150),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  const Text(
                    "Welcome to",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Image.asset(
                    'Assets/go_together_logo.png',
                    height: 100,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  TextField(
                    onChanged: viewModel.updateStudentId,
                    decoration: const InputDecoration(
                      labelText: "Student ID or email",
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    onChanged: viewModel.updatePassword,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Forgot password logic
                      },
                      child: const Text("Forgot your password?"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (viewModel.errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        viewModel.errorMessage,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),

                  if (viewModel.isLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: () {
                        if (viewModel.canSignIn) {
                          viewModel.login(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: viewModel.canSignIn ? Colors.green : Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Text(
                        "Sign in",
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      // Navigate the Create account flow
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                            create: (_) => CreateAccountFlowViewModel(), // Provide the required ViewModel
                            child: const CreateAccountFlowScreen(),
                          ),
                        ),
                      );
                    },
                    child: const Text(
                        "Don't have an account? Create an account here!",
                        style: TextStyle(
                          fontSize: 16,
                        )
                    ),
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