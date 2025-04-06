import 'package:flutter/material.dart';
import '../Models/TripModel.dart';
import '../Storage/TripStorage.dart';

class CreateNewTripScreen extends StatefulWidget {
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
  List<String> savedAddresses = ["123 Main St", "456 Elm St", "789 Maple St"]; // TODO: Replace with firebase\


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
            Text(
              "Selected: $selectedTransport",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
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
      ),
    );

    Navigator.pop(context); // Return to MyTripsHomeScreen

    // TODO: Send trip request to firebase
  }

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