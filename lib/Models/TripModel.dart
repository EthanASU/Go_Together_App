/// A model representing a trip created by the user.
class TripModel {
  final String tripKey;

  /// The name/title of the trip (e.g., "Morning School Run").
  final String tripName;

  /// The starting location (pickup point) for the trip.
  final String stop1;

  /// The destination location (drop-off point) for the trip.
  final String stop2;

  /// The selected mode of transportation (e.g., "Drive", "Bike", "Walk").
  final String selectedTransport;

  /// The status of the trip (e.g., "Pending", "Approved"). Defaults to "Pending".
  final String status;

  /// The time the trip is scheduled to start (default "00.00").
  final String time;

  /// The day of the week the trip occurs (default "Monday").
  final String day;

  /// The list of participants in the trip (default is an empty list).
  final List<Map<String, String>> participants;

  /// Creates a [TripModel] with the given trip information.
  TripModel({
    required this.tripKey,
    required this.tripName,
    required this.stop1,
    required this.stop2,
    required this.selectedTransport,
    this.status = "Pending",
    this.time = "00.00",
    this.day = "Monday",
    this.participants = const [],
  });
}
