import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModels/Profile_Screen_View_Model.dart';
import '../ViewModels/Profile_Personal_View_Model.dart';
import 'Profile_Personal_SetUp.dart';
import '../Views/LoginView.dart';
import '../Views/My_Trips_Home_Screen.dart';
import 'calendar_screen.dart';
//import 'package:google_fonts/google_fonts.dart';
// Firebase Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Views/create_new_trip_screen.dart';
import '../Views/My_Trips_Home_Screen.dart';
import '../Views/HomeScreen.dart';

class ProfileSetUp extends StatelessWidget {
  const ProfileSetUp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // No ChangeNotifierProvider here - use the one from main.dart
//      return const ProfileScreenContent();
//     // return ChangeNotifierProvider(
//     //   create: (_) => ProfileViewModel(),
//     //   child: const ProfileScreenContent(),
//     // );
//   }
// }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: const ProfileScreenContent(),
    );
  }
}

class ProfileScreenContent extends StatelessWidget {
  const ProfileScreenContent({super.key});

  void _handleNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Navigate to Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              create: (_) => ProfileViewModel(),
              child: const HomeScreen(),
            ),
          ),
        );
        break;
      case 1:
        // TODO: Navigate to Calendar
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MyTripsHomeScreen()),
        );
        break;
      case 3:
        // TODO: Navigate to Chat
        break;
      case 4:
        // Already on Profile
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // Added back for scrolling
          child: Column(
            children: [
              const SizedBox(height: 150),
              Padding(
                padding: const EdgeInsets.only(top: 16, right: 16),
                child: Align(
                  alignment: Alignment.topRight,
                  child: viewModel.isProfileComplete
                      ? ElevatedButton(
                          onPressed: () {
                            final setupViewModel =
                                ProfilePersonalSetUpViewModel();
                            // Initialize with existing data
                            setupViewModel.initializeFromMainProfile(viewModel);

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChangeNotifierProvider.value(
                                  value: setupViewModel,
                                  child: const ProfileCompletionScreen(),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8BC541),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        )
                      : Container(), // Empty container when button shouldn't show
                ),
              ),

              const SizedBox(
                  height: 30), // Space between edit button and username

              // Username centered
              Center(
                child: Text(
                  viewModel.userName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              //TODO: Rides complete counter and Your friends button functionality
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
                        style: TextStyle(
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
              //const Spacer(),
              const SizedBox(height: 30),

              // Conditional Content: Either Go Button or User Information
              if (!viewModel.isProfileComplete) ...[
                // Go Button Section
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
                    await FirebaseAuth.instance
                        .signOut(); // Sign Out of Firebase
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MyHomePage()), // Navigate back to login screen
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
              ] else ...[
                // User Information Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 65), // Wider side margins
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Left align all content
                    children: [
                      // Email
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 30), // Space between items
                        child: Row(
                          children: [
                            Image.asset(
                              'Assets/Mail_icon.png',
                              width: 24,
                              height: 24,
                              color: Color(0xFF188ECE),
                            ),
                            SizedBox(width: 10),
                            Text(
                              viewModel.emailAddress,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Phone - centered with icon
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 30), // Space between items
                        child: Row(
                          children: [
                            Image.asset(
                              'Assets/Phone_icon.png',
                              width: 24,
                              height: 24,
                              color: Color(0xFF188ECE),
                            ),
                            SizedBox(width: 10),
                            Text(
                              viewModel.phoneNumber,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Addresses - with larger spacing
                      if (viewModel.addresses.isNotEmpty) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'Assets/Location_icon.png',
                              width: 24,
                              height: 24,
                              color: Color(0xFF188ECE),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Iterate through addresses without repeating the icon
                                  ...viewModel.addresses
                                      .map((address) => Padding(
                                            padding: const EdgeInsets.only(
                                                bottom:
                                                    20), // Space between addresses
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  address['isDefault']
                                                      ? 'Home (Default)'
                                                      : address['name'] ??
                                                          'Address',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFF188ECE),
                                                  ),
                                                ),
                                                // For the street address line with optional apt/suite
                                                address['aptSuite'] != null &&
                                                        address['aptSuite']
                                                            .isNotEmpty
                                                    ? Text(
                                                        "${address['streetAddress']}, ${address['aptSuite']}",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontFamily: 'Poppins',
                                                        ),
                                                      )
                                                    : Text(
                                                        address[
                                                            'streetAddress'],
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontFamily: 'Poppins',
                                                        ),
                                                      ),

                                                Text(
                                                  '${address['city']}, ${address['state']} ${address['zipCode']}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                      // Emergency Contacts
                      if (viewModel.emergencyContacts.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          child: Text(
                            'Emergency contact',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF188ECE),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        ...viewModel.emergencyContacts
                            .map((contact) => Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, left: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${contact['firstName']} ${contact['lastName']} (${contact['relationship']})',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      Text(
                                        contact['phone'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ],
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 300),

              // Bottom Navigation Bar
              BottomNavigationBar(
                currentIndex: 4,
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
                  switch (index) {
                    case 0:
                      // TODO: Navigate to Home
                      break;
                    case 1:
                      // TODO: Navigate to Calendar
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CalendarScreen()),
                      );
                      break;
                    case 2: // My Trip tab
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const MyTripsHomeScreen()),
                      );
                      break;
                    case 3:
                      // TODO: Navigate to Chat
                      break;
                    case 4:
                      // Already on Profile, maybe no nav needed
                      break;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
