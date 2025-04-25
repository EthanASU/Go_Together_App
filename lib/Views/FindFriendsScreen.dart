import 'package:flutter/material.dart';
import '../Views/My_Trips_Home_Screen.dart';
import '../Views/Profile_Screen_Setup.dart';

/// A screen that displays a list of nearby or same-school users for friendship.
///
/// Allows users to send friend requests and view placeholder UI for chat.
/// Navigation tabs at the top and bottom help users move across app sections.
class FindFriendsScreen extends StatelessWidget {
  const FindFriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy list of users for now
    // TODO: Replace with actual data from Firebase
    //Dummy data for demonstration purposes. Replace with Firebase query later.
    final List<Map<String, String>> mockUsers = [
      {
        'name': 'John Doe',
        'userID': 'user1',
        'imageUrl': 'https://example.com/image1.jpg',
      },
      {
        'name': 'Jane Smith',
        'userID': 'user2',
        'imageUrl': 'https://example.com/image2.jpg',
      },
      {
        'name': 'Alice Johnson',
        'userID': 'user3',
        'imageUrl': 'https://example.com/image3.jpg',
      }
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            _buildTabs(context), // 👈 include this!
            const SizedBox(height: 20),
            // List of potential friends
            Expanded(
              child: ListView.builder(
                itemCount: mockUsers.length,
                itemBuilder: (context, index) {
                  final user = mockUsers[index];
                  return FriendCard(
                    name: user['name']!,
                    userID: user['userID']!,
                    imageUrl: user['imageUrl']!,
                    onAddFriend: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Friend request sent to ${user['name']}")),
                      );
                    },
                  );
                },
              ),
            ),
            // Bottom navigation bar
            BottomNavigationBar(
              currentIndex: 2,
              onTap: (index) => _handleNavTap(context, index),
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
                BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'My Trip'),
                BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the top navigation tabs for switching between related views.
  Widget _buildTabs(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text(
          "MATCH ME",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyTripsHomeScreen()),
            );
          },
          child: const Text(
            "MY TRIPS",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              decoration: TextDecoration.underline, // Optional styling
            ),
          ),
        ),
        const Text(
          "FIND FRIENDS",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        ),
      ],
    );
  }

  /// Handles taps on the bottom navigation bar.
  void _handleNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
      // TODO: Navigate to Home
        break;
      case 1:
      // TODO: Navigate to Calendar
        break;
      case 2:
      // Already on My Trips – do nothing
        break;
      case 3:
      // TODO: Navigate to Chat
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfileSetUp()),
        );
        break;
    }
  }
}

/// A reusable widget representing a friend card in the list.
///
/// Displays the user's name, profile picture, and two buttons:
/// - 'Add Friend': triggers the provided callback
/// - 'Chat': placeholder for future chat integration
class FriendCard extends StatelessWidget {
  final String name;
  final String userID;
  final String imageUrl;
  final VoidCallback onAddFriend;

  const FriendCard({
    required this.name,
    required this.userID,
    required this.imageUrl,
    required this.onAddFriend,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: onAddFriend,
              child: const Text('Add Friend'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {}, // Placeholder for the button action
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              child: const Text('Chat'),
            ),
          ],
        ),
      ),
    );
  }
}