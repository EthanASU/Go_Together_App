import '../Models/TripModel.dart';

/// A static class for managing trip data during the app session.
///
/// Stores pending and scheduled trips locally.
/// Later, this can be extended to sync with Firebase.
class TripStorage {
  /// A list of trips that are currently awaiting approval or matching.
  ///
  /// Trips in this list typically have a status of "Pending".
  static List<TripModel> pendingTrips = [];

  /// A list of trips that have been approved or scheduled.
  ///
  /// Trips in this list are considered confirmed and ready for participation.
  static List<TripModel> scheduledTrips = [];
}