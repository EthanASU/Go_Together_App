class TripModel {
  final String tripName;
  final String stop1;
  final String stop2;
  final String selectedTransport;
  final String status;
  final String time;
  final String day;

  TripModel({
    required this.tripName,
    required this.stop1,
    required this.stop2,
    required this.selectedTransport,
    this.status = "Pending",
    this.time = "00.00",
    this.day = "Monday",
  });
}