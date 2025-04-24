import 'package:flutter/material.dart';
import '../Models/TripModel.dart';
import '../Storage/TripStorage.dart';
import '../Storage/ParticipantStorage.dart';

/// A screen that allows users to create a new trip by selecting
/// transportation mode, naming the trip, setting stops, and adding participants.
///
/// Upon submission, the created trip is passed back to the parent widget
/// through the [onTripCreated] callback.
class CreateNewTripScreen extends StatefulWidget {
  /// Callback that triggers when a new trip is successfully created.
  final Function(TripModel) onTripCreated;
  const CreateNewTripScreen({super.key, required this.onTripCreated});

  @override
  State<CreateNewTripScreen> createState() => _CreateNewTripScreenState();
}

class _CreateNewTripScreenState extends State<CreateNewTripScreen> {
  String selectedTransport = 'Drive';
  String tripName = '';
  String stop1 = '';
  String stop2 = '';
  /// List of saved addresses (replace later with Firebase data).
  List<String> savedAddresses = ["123 Main St", "456 Elm St", "789 Maple St"]; // TODO: Replace with firebase\

  /// Updates the selected transportation mode (Drive, Bike, Walk).
  void selectTransport(String mode) {
    setState(() {
      selectedTransport = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Trip"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transportation selection
            const Text(
              "I will (choose one):",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTransportOption('Drive', Icons.directions_car),
                _buildTransportOption('Bike', Icons.directions_bike),
                _buildTransportOption('Walk', Icons.directions_walk),
              ],
            ),
            const SizedBox(height: 24),
            // Display selected transport
            Text(
              "Selected: $selectedTransport",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            // Trip Name Field
            const Text(
              "Trip Name",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) {
                setState(() {
                  tripName = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Enter a name for your trip",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            // Participants Section
            const SizedBox(height: 24),
            const Text(
              "Participants",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ParticipantStorage.selectedParticipants.map((participant) {
                return Chip(
                  label: Text(participant['name'] ?? ''),
                  avatar: CircleAvatar(
                    backgroundImage: NetworkImage(participant['imageUrl'] ?? ''),
                  ),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () {
                    setState(() {
                      ParticipantStorage.selectedParticipants.remove(participant);
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 12),

            // Add Participant Button
            ElevatedButton.icon(
              onPressed: _showParticipantPicker,
              icon: const Icon(Icons.person_add),
              label: const Text("Add Participant"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),

            // Stop 1 Selection
            const SizedBox(height: 24),
            const Text("Stop 1 (Pick-up Location)",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: savedAddresses.contains(stop1) ? stop1 : null,
              hint: const Text("Select or enter address"),
              items: savedAddresses.map((address) {
                return DropdownMenuItem(
                  value: address,
                  child: Text(address),
                );
              }).toList()
                ..add(const DropdownMenuItem(value: 'manual', child: Text('Enter address manually'))),
              onChanged: (value) {
                if (value == 'manual') {
                  _showManualAddressDialog(1);
                } else {
                  setState(() {
                    stop1 = value ?? '';
                  });
                }
              },
            ),
            // Stop 2 Selection
            const SizedBox(height: 24),
            const Text("Stop 2 (Drop-off Location)",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: savedAddresses.contains(stop2) ? stop2 : null,
              hint: const Text("Select or enter address"),
              items: savedAddresses.map((address) {
                return DropdownMenuItem(
                  value: address,
                  child: Text(address),
                );
              }).toList()
                ..add(const DropdownMenuItem(value: 'manual', child: Text('Enter address manually'))),
              onChanged: (value) {
                if (value == 'manual') {
                  _showManualAddressDialog(2);
                } else {
                  setState(() {
                    stop2 = value ?? '';
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            // Submit Trip Button
            Center(
              child: ElevatedButton(
                onPressed: _submitTripRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Send Request',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Displays a dialog allowing the user to manually enter an address.
  void _showManualAddressDialog(int stopNumber) {
    String tempAddress = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter address for stop $stopNumber'),
          content: TextField(
            onChanged: (value) {
              tempAddress = value;
            },
            decoration: const InputDecoration(hintText: "Enter address"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (stopNumber == 1) {
                    stop1 = tempAddress;
                  } else {
                    stop2 = tempAddress;
                  }
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  /// Validates the trip form and creates a new trip if all fields are filled.
  void _submitTripRequest() {
    if (tripName.isEmpty || stop1.isEmpty || stop2.isEmpty || selectedTransport.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all trip fields")),
      );
      return;
    }

    print("Trip Created!");
    print("Mode: $selectedTransport");
    print("Name: $tripName");
    print("Stop 1: $stop1");
    print("Stop 2: $stop2");

    // Save trip to local storage
    widget.onTripCreated(
      TripModel(
        tripName: tripName,
        stop1: stop1,
        stop2: stop2,
        selectedTransport: selectedTransport,
        participants: ParticipantStorage.selectedParticipants,
      ),
    );

    Navigator.pop(context); // Return to MyTripsHomeScreen

    // TODO: Send trip request to firebase
  }

  /// Displays a bottom sheet allowing the user to select friends as participants.
  void _showParticipantPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: ParticipantStorage.mockUsers.map((user) {
            bool alreadyAdded = ParticipantStorage.selectedParticipants.any(
                    (p) => p['userID'] == user['userID']);

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user['imageUrl'] ?? ''),
              ),
              title: Text(user['name'] ?? ''),
              trailing: alreadyAdded
                  ? const Icon(Icons.check, color: Colors.green)
                  : const Icon(Icons.add),
              onTap: () {
                if (!alreadyAdded) {
                  setState(() {
                    ParticipantStorage.selectedParticipants.add(user);
                  });
                }
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  /// Builds a selectable transport option (Drive, Bike, Walk).
  Widget _buildTransportOption(String label, IconData icon) {
    final isSelected = selectedTransport == label;

    return GestureDetector(
      onTap: () => selectTransport(label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade100 : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade400,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, size: 36, color: isSelected ? Colors.green : Colors.black),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.green.shade800 : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}