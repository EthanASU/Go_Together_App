import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModels/Profile_Screen_View_Model.dart';
import '../ViewModels/Profile_Personal_View_Model.dart';
import 'Profile_Personal_SetUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Views/LoginView.dart';

class ProfileSetUp extends StatelessWidget {
  const ProfileSetUp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: const ProfileScreenContent(),
    );
  }
}

class ProfileScreenContent extends StatefulWidget {
  const ProfileScreenContent({super.key});

  @override
  _ProfileScreenContentState createState() => _ProfileScreenContentState();
}

class _ProfileScreenContentState extends State<ProfileScreenContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileViewModel>(context, listen: false).fetchUserName();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 115),
            // User Name section
            Text(
              viewModel.userName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            // rides completed and history section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        viewModel.completedRides.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('rides completed'),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 40,
                    width: 1,
                    color: Colors.grey,
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to history
                    },
                    child: const Text(
                      'History',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Friends Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to friends list
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your friends',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            //Go Button Section
            if (!viewModel.isProfileComplete) ...[
              const Text(
                'Finish setting up',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.pink,
                ),
              ),
              const Text(
                'your profile',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()), // Navigate back to login screen
                  );
                },
                child: Text("Logout"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (_) => ProfilePersonalSetUpViewModel(),
                        child: const ProfileCompletionScreen(),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8BC541),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Go',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 300),

            //Navigation Bar
            BottomNavigationBar(
              currentIndex: 4, // Profile tab
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage('Assets/Tab_Bar_Home_Icon.png'),
                  ),
                  label: 'Home',
                ),

                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage('Assets/Tab_Bar_Calendar_Icon.png'),
                  ),
                  label: 'Calendar',
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage('Assets/Tab_Bar_Add_Icon.png'),
                  ),
                  label: 'My Trip',
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage('Assets/Tab_Bar_Chat_Icon.png'),
                  ),
                  label: 'Chat',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              onTap: (index) {
                // Handle navigation
              },
            ),
          ],
        ),
      ),
    );
  }
}

