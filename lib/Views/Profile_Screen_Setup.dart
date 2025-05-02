//import packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//ViewModels
import '../ViewModels/Profile_Screen_View_Model.dart';
import '../ViewModels/Profile_Personal_View_Model.dart';
//Views
import '../Views/My_Trips_Home_Screen.dart';
import '../Views/Profile_Personal_SetUp.dart';
import '../Views/calendar_screen.dart';

/// Main widget for the Profile Setup screen
/// This is the parent widget that sets up the provider for the profile view model
class ProfileSetUp extends StatelessWidget {
  const ProfileSetUp({super.key});

  @override
  Widget build(BuildContext context) {
    // No ChangeNotifierProvider here - using the one from main.dart
    // This approach allows the profile data to be persisted across the app
    return const ProfileScreenContent();
  }
}

/// The main content widget for the profile screen
/// This displays user information and provides navigation to profile editing
class ProfileScreenContent extends StatelessWidget {
  const ProfileScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the profile view model from the provider
    final viewModel = context.watch<ProfileViewModel>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(  // Enables scrolling for content that may overflow
          child: Column(
            children: [
              const SizedBox(height: 150), // Space at the top of the screen

              // Edit Button (only shown if profile is complete)
              Padding(
                padding: const EdgeInsets.only(top: 16, right: 16),
                child: Align(
                  alignment: Alignment.topRight,
                  child: viewModel.isProfileComplete
                      ? ElevatedButton(
                    onPressed: () {
                      // Create a new view model for profile editing and initialize it
                      // with data from the main profile view model
                      final setupViewModel = ProfilePersonalSetUpViewModel();
                      setupViewModel.initializeFromMainProfile(viewModel);

                      // Navigate to the profile completion screen with the initialized view model
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider.value(
                            value: setupViewModel,
                            child: const ProfileCompletionScreen(),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8BC541), // Primary green color
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Rounded corners
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
                      : Container(), // Empty container when profile isn't complete (button not shown)
                ),
              ),

              const SizedBox(height: 30), // Space between edit button and username

              // Username displayed at the top center of the screen
              Center(
                child: Text(
                  viewModel.userName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 30), // Space after username

              // Statistics section: Rides completed and History button
              //TODO: Rides complete counter and Your friends button functionality
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Rides completed counter
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
                    // Vertical divider between counter and history button
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      height: 40,
                      width: 1,
                      color: Colors.grey,
                    ),
                    // History button
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to history screen
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

              const SizedBox(height: 20), // Space after statistics section

              // Friends list button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to friends list screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size.fromHeight(50), // Full width button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
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

              const SizedBox(height: 30), // Space after friends button

              // Conditional Content: Show either "Go" button or User Information
              // depending on whether the profile is complete
              if (!viewModel.isProfileComplete) ...[
                // Profile not complete - Show setup prompt and "Go" button
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
                // "Go" button to navigate to profile completion
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
                    backgroundColor: const Color(0xFF8BC541), // Primary green color
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Rounded corners
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
                // Profile is complete - Show user information
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 65), // Wider side margins
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Left align all content
                    children: [
                      // Email information with icon
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30), // Space between items
                        child: Row(
                          children: [
                            Image.asset(
                              'Assets/Mail_icon.png',
                              width: 24,
                              height: 24,
                              color: Color(0xFF188ECE), // Blue icon color
                            ),
                            SizedBox(width: 10), // Space between icon and text
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

                      // Phone information with icon
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30), // Space between items
                        child: Row(
                          children: [
                            Image.asset(
                              'Assets/Phone_icon.png',
                              width: 24,
                              height: 24,
                              color: Color(0xFF188ECE), // Blue icon color
                            ),
                            SizedBox(width: 10), // Space between icon and text
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

                      // Addresses section - only shown if addresses exist
                      if (viewModel.addresses.isNotEmpty) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Location icon for addresses
                            Image.asset(
                              'Assets/Location_icon.png',
                              width: 24,
                              height: 24,
                              color: Color(0xFF188ECE), // Blue icon color
                            ),
                            SizedBox(width: 10), // Space between icon and addresses
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Map through all addresses in the viewModel
                                  ...viewModel.addresses.map((address) => Padding(
                                    padding: const EdgeInsets.only(bottom: 20), // Space between addresses
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Address title (Home/Default or custom name)
                                        Text(
                                          address['isDefault'] ? 'Home (Default)' : address['name'] ?? 'Address',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF188ECE), // Blue text color
                                          ),
                                        ),
                                        // Street address with optional apartment/suite
                                        address['aptSuite'] != null && address['aptSuite'].isNotEmpty
                                            ? Text(
                                          "${address['streetAddress']}, ${address['aptSuite']}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Poppins',
                                          ),
                                        )
                                            : Text(
                                          address['streetAddress'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        // City, State and Zip code
                                        Text(
                                          '${address['city']}, ${address['state']} ${address['zipCode']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                  )).toList(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],

                      // Emergency Contacts section
                      if (viewModel.emergencyContacts.isNotEmpty) ...[
                        // Emergency contact header
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          child: Text(
                            'Emergency contact',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF188ECE), // Blue text color
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        // Map through all emergency contacts in the viewModel
                        ...viewModel.emergencyContacts.map((contact) => Padding(
                          padding: const EdgeInsets.only(bottom: 10, left: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Contact name and relationship
                              Text(
                                '${contact['firstName']} ${contact['lastName']} (${contact['relationship']})',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              // Contact phone number
                              Text(
                                contact['phone'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                      ],
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 300), // Large space before bottom navigation

              // Bottom Navigation Bar for app-wide navigation
              BottomNavigationBar(
                currentIndex: 4, // Profile tab is selected (index 4)
                type: BottomNavigationBarType.fixed, // Prevents shifting behavior with more than 3 items
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
                // Handle bottom navigation tab selection
                onTap: (index) {
                  switch (index) {
                    case 0:
                    // TODO: Navigate to Home screen
                      break;
                    case 1:
                    // Navigate to Calendar screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CalendarScreen()),
                      );
                      break;
                    case 2:
                    // Navigate to My Trips screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const MyTripsHomeScreen()),
                      );
                      break;
                    case 3:
                    // TODO: Navigate to Chat screen
                      break;
                    case 4:
                    // Already on Profile screen, no navigation needed
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