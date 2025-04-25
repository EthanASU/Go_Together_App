/// A static class for managing selected trip participants
/// and providing a mock user list for testing.
class ParticipantStorage {
  /// A list of participants selected by the user for a trip.
  ///
  /// Each participant is represented as a map containing:
  /// - 'name': The participant's full name.
  /// - 'imageUrl': A URL to the participant's profile picture.
  /// - 'userID': The unique identifier for the participant.
  static List<Map<String, String>> selectedParticipants = [];

  /// A mock list of available users to simulate friend selection.
  ///
  /// Used for testing the participant selection feature
  /// before integrating real Firebase user data.
  static List<Map<String, String>> mockUsers = [
    {
      'name': 'Mike N.',
      'imageUrl': 'https://i.pravatar.cc/150?img=5',
      'userID': 'user1',
    },
    {
      'name': 'Kaitlyn G.',
      'imageUrl': 'https://i.pravatar.cc/150?img=15',
      'userID': 'user2',
    },
    {
      'name': 'Phillip O.',
      'imageUrl': 'https://i.pravatar.cc/150?img=22',
      'userID': 'user3',
    },
  ];

  /// Clear all data off local object
  /// Preferably on logout
  static void ClearAll() {
    // TODO: Clear participant storage?
  }
}
