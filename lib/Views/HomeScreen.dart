import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/TripModel.dart';
import '../Storage/TripStorage.dart';
import '../ViewModels/Profile_Screen_View_Model.dart';
import '../Views/My_Trips_Home_Screen.dart';
import '../Views/Profile_Screen_Setup.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheduledTrips = TripStorage.scheduledTrips;
    final Name = context.watch<ProfileViewModel>().userName;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage("assets/images/profile.png"),
                    radius: 30,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "Hi $Name!",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text("Upcoming Trips", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (scheduledTrips.isNotEmpty)
                _buildTripCard(scheduledTrips.first)
              else
                const Text("No scheduled trips", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 32),
              const Text("Points & Rewards", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black12)],
                ),
                child: Row (
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.star_border, color: Colors.amber),
                        SizedBox(width: 8),
                        Text("You have 0 points", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
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
    );
  }

  Widget _buildTripCard(TripModel trip) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(trip.tripName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(children: [
            const Icon(Icons.location_on, color: Colors.orange),
            const SizedBox(width: 8),
            const Text("Start", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Text(trip.stop1),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.location_on, color: Colors.green),
            const SizedBox(width: 8),
            const Text("Destination", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Text(trip.stop2),
          ]),
          const SizedBox(height: 8),
          Row(children: const [Text("Total time", style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(width: 8), Text("10 minutes")]),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text("GO", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  void _handleNavTap(BuildContext context, int index) {
    switch (index) {
      case 0: // Home
      // Already on Home
        break;
      case 1: // Calendar (still TODO)
        break;
      case 2: // My Trip
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MyTripsHomeScreen()),
        );
        break;
      case 3: // Chat (still TODO)
        break;
      case 4: // Profile
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfileSetUp()),
        );
        break;
    }
  }
}