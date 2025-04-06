import 'package:flutter/material.dart';
import '../Models/TripModel.dart';

class TripCard extends StatefulWidget {
  final TripModel trip;
  final VoidCallback onDelete;

  const TripCard({super.key, required this.trip, required this.onDelete});

  @override
  State<TripCard> createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.green.shade200),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          // Top row with trip name and icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                trip.tripName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  Icon(
                    trip.selectedTransport == "Drive"
                        ? Icons.directions_car
                        : trip.selectedTransport == "Bike"
                        ? Icons.directions_bike
                        : Icons.directions_walk,
                    color: Colors.black,
                  ),
                  IconButton(
                    icon: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: widget.onDelete,
                  ),
                ],
              )
            ],
          ),

          if (isExpanded) const SizedBox(height: 16),

          // Expanded Details
          if (isExpanded) ...[
            Row(
              children: const [
                Icon(Icons.access_time, size: 18),
                SizedBox(width: 8),
                Text("20 minutes until meet up!", style: TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                Icon(Icons.location_on, color: Colors.green),
                SizedBox(width: 8),
                Text("Meet up", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 28.0),
              child: Text(trip.stop1),
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                Icon(Icons.location_on, color: Colors.blue),
                SizedBox(width: 8),
                Text("Final Destination", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 28.0),
              child: Text(trip.stop2),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Start your trip",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  trip.status.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: trip.status == "approved" ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}