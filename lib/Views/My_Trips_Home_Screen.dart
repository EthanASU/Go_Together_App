import 'package:flutter/material.dart';
import 'package:go_together_app/Storage/TripStorage.dart';
import '../Views/Profile_Screen_Setup.dart';
import '../Views/Create_New_Trip_Screen.dart';
import '../Views/Calendar_Screen.dart';
import '../Models/TripModel.dart';
import '../Widgets/TripCard.dart';
import '../Widgets/My_Trips_Top_Navigation_Bar.dart';

// Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyTripsHomeScreen extends StatefulWidget {
  const MyTripsHomeScreen({super.key});

  @override
  State<MyTripsHomeScreen> createState() => _MyTripsHomeScreenState();
}

class _MyTripsHomeScreenState extends State<MyTripsHomeScreen> {
  List<TripModel> scheduledTrips = TripStorage.scheduledTrips;
  List<TripModel> pendingTrips = TripStorage.pendingTrips;
  bool showScheduled = true;
  bool showPending = true;
  int _selectedTabIndex = 1;

  // Maximum number of trips Firebase can hold for one account
  int numberOfAllowedTrips = 10;

  _MyTripsHomeScreenState() // Constructor
  {
    // Fetch Trips From Firebase
    fetchTripsFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Tabs
            // Use the new TopNavigationBar widget
            TopNavigationBar(
              selectedIndex: _selectedTabIndex,
              onTap: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
            ),
            const SizedBox(height: 12),
            _buildTabs(),

            // Trip Lists
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    _buildSection(
                        "Scheduled Trips", showScheduled, scheduledTrips, () {
                      setState(() => showScheduled = !showScheduled);
                    }),
                    const SizedBox(height: 16),
                    _buildSection("Pending Trips", showPending, pendingTrips,
                        () {
                      setState(() => showPending = !showPending);
                    }),
                  ],
                ),
              ),
            ),

            const Divider(height: 1),

            // Create New Trip Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("CREATE NEW TRIP",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateNewTripScreen(
                            onTripCreated: (newTrip) {
                              setState(() {
                                TripStorage.pendingTrips.add(newTrip);
                              });
                            },
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 10),
                    ),
                    child: const Text("ADD",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) => _handleNavTap(context, index),
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
        ], // Your existing bottom navigation bar items
      ),
    );
  }

  Widget _buildTripCard(TripModel trip, bool isPending) {
    return TripCard(
      trip: trip,
      onDelete: () {
        setState(() {
          if (isPending) {
            TripStorage.pendingTrips.remove(trip);
          } else {
            TripStorage.scheduledTrips.remove(trip);
          }
        });
      },
    );
  }

  Widget _buildSection(String title, bool expanded, List<TripModel> trips,
      VoidCallback onTapHeader) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTapHeader,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 18, color: Colors.blue)),
                Icon(expanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (expanded)
            trips.isEmpty
                ? const Text("No trips", style: TextStyle(color: Colors.grey))
                : Column(
                    children: trips
                        .map((trip) =>
                            _buildTripCard(trip, title.contains("Pending")))
                        .toList()),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        Text(
          "MATCH ME",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          "MY TRIPS",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        ),
        Text(
          "FIND FRIENDS",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _handleNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        // TODO: Navigate to Home
        break;
      case 1:
        // TODO: Navigate to Calendar
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CalendarScreen()),
        );
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

  // *************** Firebase Methods **************
  /// Fetch all user trips from Firebase at once
  Future<void> fetchTripsFromFirebase() async {
    try {
      User? user = FirebaseAuth.instance.currentUser; // User Reference
      if (user != null) {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance // Get the User's data
                .collection('users')
                .doc(user.uid)
                .get();

        if (userDoc.exists && userDoc.data() != null) {
          // Check if the user exists
          final userData = userDoc.data() as Map<String, dynamic>;

          // Iterate through trip IDs and update them sequentially in the trip screen
          var tripIDs = List<String>.filled(numberOfAllowedTrips, "Null");
          for (int i = 0; i < (tripIDs.length + 1); i++) {
            String tripKey = "trip" + i.toString();
            String tripID = // Get the tripID for each address
                userData[tripKey] ?? "Null"; // Default to Null if missing

            if (tripID != "Null") {
              // Check if the ID is valid
              // Update Trip
              DocumentSnapshot tripDoc =
                  await FirebaseFirestore.instance // Get the trip's data
                      .collection('trips')
                      .doc(tripID)
                      .get();

              if (tripDoc.exists && tripDoc.data() != null) {
                // Check if the user exists
                final tripData = tripDoc.data() as Map<String, dynamic>;

                // Assuming TripModel has a constructor that allows direct setting of properties
                TripModel newTrip = TripModel(
                    tripName: tripData['tripName'] ?? "Unnamed Trip",
                    status: tripData['tripStatus'] ?? "Pending",
                    selectedTransport: tripData['transPrefs'] ?? "Pending",
                    stop1: tripData['stop1'] ?? "Unknown_Stop",
                    stop2: tripData['stop2'] ?? "Unknown_Stop");

                // Store trip based on status
                if (newTrip.status == "Scheduled") {
                  scheduledTrips.add(newTrip);
                  print(
                      "Scheduled Trip retrieved ${newTrip.tripName} from Firestore db!");
                } else {
                  pendingTrips.add(newTrip);
                  print(
                      "Pending Trip retrieved ${newTrip.tripName} from Firestore db!");
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print("Error fetching user address data: $e");
    }
  }
}
