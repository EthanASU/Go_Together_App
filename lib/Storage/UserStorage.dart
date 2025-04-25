/// Static class for storing user data *LOCALLY* in the application. Most if not all user data will be loaded
/// from login and storage will occur dynamically throughout using the application.
class UserStorage {
  static final NumOfAllowedAddresses = 5;
  static final NumOfAllowedContacts = 3;

  // Basic Information
  static String Role = "";
  static String School = "";
  static String FirstName = "";
  static String LastName = "";
  static int StudentNumber = 0;
  static String Email = "";
  static String PhoneNumber = "";
  static String Password = "";
  static bool DrivePref = false;
  static bool BikePref = false;
  static bool WalkPref = false;

  // Addresses
  static List<Map<String, dynamic>> Addresses = [];
  static List<Map<String, dynamic>> get addresses => Addresses;

  // Emergency Contacts
  static List<Map<String, dynamic>> EmergencyContacts = [];

  /// Clear all data off local object
  /// Preferably on logout
  static void ClearAll() {
    Role = "";
    School = "";
    FirstName = "";
    LastName = "";
    StudentNumber = 0;
    Email = "";
    PhoneNumber = "";
    Password = "";
    DrivePref = false;
    BikePref = false;
    WalkPref = false;

    Addresses.clear();
    EmergencyContacts.clear();
  }
}
