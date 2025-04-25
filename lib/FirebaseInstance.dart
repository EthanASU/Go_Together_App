import '../Storage/UserStorage.dart';
import '../Storage/TripStorage.dart';
import '../Storage/ParticipantStorage.dart';
import '../Models/TripModel.dart';

// Firebase Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// All of Firebase's methods and calls centralized in one singleton unit
/// Call "Instance" from anywhere in the project
class FirebaseInstance {
  // Singleton Reference
  static FirebaseInstance? Instance;

  final firebaseAuth =
      FirebaseAuth.instance; // Reference to the Firebase Auth Object
  final firestoreDB =
      FirebaseFirestore.instance; // Reference to the Firestore Database

  /// ************** Authorization Methods **************
  Future<bool> Login(String studentId, String password) async {
    try {
      String email = studentId;

      // If the input isn't and email, assume it's a Student ID and fetch corresponding email from Firestore
      if (!studentId.contains('@')) {
        QuerySnapshot querySnapshot = await firestoreDB
            .collection('users')
            .where('studentNum', isEqualTo: studentId)
            .limit(1)
            .get();

        if (querySnapshot.docs.isEmpty) {
          throw Exception("No account found with this Student ID.");
        }

        email =
            querySnapshot.docs.first['email']; // Get the email from Firestore
      }

      // Firebase Authentication (Email & Password)
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("Login successful! User ID: ${userCredential.user?.uid}");
      return true;
    } catch (e) {
      print("Login failed: $e");
      return false;
    }
  }

  Future<void> Logout() async {
    await FirebaseAuth.instance.signOut(); // Sign Out of Firebase
  }

  // TODO: Handle Email and Phone number verification
  Future<bool> CreateAccountOnFirebase() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: UserStorage.Email,
        password: UserStorage.Password,
      );

      // Store basic user info in details in Firestore
      await firestoreDB.collection('users').doc(userCredential.user!.uid).set({
        'firstName': UserStorage.FirstName,
        'lastName': UserStorage.LastName,
        'email': UserStorage.Email,
        'phoneNumber': UserStorage.PhoneNumber,
        'studentID': UserStorage.StudentNumber,
        'school': UserStorage.School
      });

      // Initialize Transportation Prefs in DB; To be updated in Profile Personal View Model
      await firestoreDB
          .collection('transPrefs')
          .doc(userCredential.user!.uid)
          .set({
        'Bike': false,
        'Carpool': false,
        'Walk': false,
      });

      return true; // Account created
    } catch (e) {
      print("Error creating account: $e");
      return false; // Account creation failed
    }
  }

  /// ************** Storage Methods **************
  /// Store Phone Number in Firebase
  Future<void> storePhoneNumberOnFirebase(String phoneNum) async {
    User? user = FirebaseAuth.instance.currentUser; // User Reference

    // Store phone as a pair to parse database
    final data = {"phoneNumber": phoneNum};

    // Store in database
    await firestoreDB
        .collection('users') // Document "users"
        .doc(user!.uid) // User UID
        .set(data, SetOptions(merge: true)); // Set data in existing doc

    print("User phone number stored in db as $phoneNum");
  }

  /// Store Email in Firebase
  Future<void> storeEmailOnFirebase(String email) async {
    User? user = FirebaseAuth.instance.currentUser; // User Reference

    // Store email as a pair to parse database
    final data = {"email": email};

    // Store in database
    await firestoreDB
        .collection('users') // Document "users"
        .doc(user!.uid) // User UID
        .set(data, SetOptions(merge: true)); // Set data in existing doc

    print("User email stored in db as $email");
  }

  /// Store transportation prefs in Firebase
  Future<void> storeTransportationPrefsOnFirebase(
      String type, bool setting) async {
    User? user = FirebaseAuth.instance.currentUser; // User Reference

    // Store pref as a pair to parse database
    final data = {type: setting};

    // Store in database
    await firestoreDB
        .collection('transPrefs') // Document "transPrefs
        .doc(user!.uid) // User UID
        .set(data, SetOptions(merge: true)); // Set data in existing doc

    print("User transportation prefs $type stored in db as $setting");
  }

  /// Store a user address on Firebase
  Future<void> storeAddressOnFirebase(Map<String, dynamic> addressInfo) async {
    User? user = FirebaseAuth.instance.currentUser; // User Reference

    // Generate and store new Address ID
    String randomId =
        firestoreDB.collection("users").doc().id; // Generate random ID

    // Store the address in the right user data entry
    int addressNum = UserStorage.Addresses.length - 1;
    String addressKey = "address" + addressNum.toString();

    // Store address as a pair to parse database
    final data = {addressKey: randomId};

    // Store in database
    await firestoreDB
        .collection('users') // Document "users"
        .doc(user!.uid) // User UID
        .set(data, SetOptions(merge: true)); // Set data in existing doc

    // Generate and store address with ID
    await firestoreDB.collection('addresses').doc(randomId).set({
      'streetAddress': addressInfo['streetAddress'],
      'aptSuite': addressInfo['aptSuite'],
      'city': addressInfo['city'],
      'state': addressInfo['state'],
      'zipCode': addressInfo['zipCode'],
      'name': addressInfo['name'],
      'isDefault': addressInfo['isDefault']
    });

    print("User address $addressKey stored in db as $randomId");
  }

  /// Store a user contact on Firebase
  Future<void> storeContactOnFirebase(Map<String, dynamic> contactInfo) async {
    User? user = FirebaseAuth.instance.currentUser; // User Reference

    // Generate and store new Contact ID
    String randomId =
        firestoreDB.collection("users").doc().id; // Generate random ID

    // Store the contact in the right user data entry
    int contactNum = UserStorage.EmergencyContacts.length - 1;
    String contactKey = "contact" + contactNum.toString();

    // Store contact as a pair to parse database
    final data = {contactKey: randomId};

    // Store in database
    await firestoreDB
        .collection('users') // Document "users"
        .doc(user!.uid) // User UID
        .set(data, SetOptions(merge: true)); // Set data in existing doc

    // Generate and store contact with ID
    await firestoreDB.collection('contacts').doc(randomId).set({
      'firstName': contactInfo['firstName'],
      'lastName': contactInfo['lastName'],
      'phone': contactInfo['phone'],
      'relationship': contactInfo['relationship']
    });

    print("User contact $contactKey stored in db as $randomId");
  }

  /// Store a trip data to Firebase
  Future<void> storeTripOnFirebase(TripModel trip) async {
    User? user = FirebaseAuth.instance.currentUser; // User Reference

    // Generate and store new Trip ID
    String randomId =
        firestoreDB.collection("users").doc().id; // Generate random ID for trip

    // The next trip number is the total number of trips
    int tripNum =
        TripStorage.scheduledTrips.length + TripStorage.pendingTrips.length - 1;
    String tripKey = "trip" + tripNum.toString();

    // Store trip as a pair to parse database
    final tripData = {tripKey: randomId};

    // Store in database
    await firestoreDB
        .collection('users') // Document "users"
        .doc(user!.uid) // User UID
        .set(tripData, SetOptions(merge: true)); // Set data in existing doc

    // Generate and store contact with ID
    await firestoreDB.collection('trips').doc(randomId).set({
      'tripKey': trip.tripKey,
      'tripName': trip.tripName,
      'transPrefs': trip.selectedTransport,
      'tripStatus': trip.status,
      'stop1': trip.stop1,
      'stop2': trip.stop2,
      'time': trip.time,
      'day': trip.day,
    });

    // Store participants in trip
    for (int i = 0; i < ParticipantStorage.selectedParticipants.length; i++) {
      print("Adding participant$i to trip...");
      String participantKey = "participant" + i.toString();
      final participantData = {
        participantKey: ParticipantStorage.selectedParticipants[i]['name']
      }; // TODO: replace this with the friend's/participant's userID
      await firestoreDB
          .collection('trips')
          .doc(randomId)
          .set(participantData, SetOptions(merge: true));
      print("Participant$i added!");
    }

    print("Trip created $tripKey and stored in db as $randomId");
  }

  /// ************** Retrieval Methods **************
  // Fetch All Information About User From Firebase
  // Preferably used upon login
  Future<void> fetchAllFromFirebase() async {
    await fetchBasicUserInfoFromFirebase();
    await fetchTransportationPrefsFromFirebase();
    await fetchAddressesFromFirebase();
    await fetchContactsFromFirebase();
    await fetchTripsFromFirebase();
  }

  Future<void> fetchBasicUserInfoFromFirebase() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          final data = userDoc.data() as Map<String, dynamic>;
          UserStorage.FirstName =
              data['firstName'] ?? ""; // Default to "User" if missing
          UserStorage.LastName =
              data['lastName'] ?? ""; // Default to "User" if missing
          UserStorage.StudentNumber = int.parse(data['studentID']) ?? 0;
          UserStorage.School =
              data['school'] ?? "Missing"; // Default to "User" if missing
          UserStorage.Email =
              data['email'] ?? ""; // Default to "User" if missing
          UserStorage.PhoneNumber =
              data['phoneNumber'] ?? ""; // Default to "User" if missing
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  /// Fetch transportation prefs from Firebase
  Future<void> fetchTransportationPrefsFromFirebase() async {
    try {
      User? user = FirebaseAuth.instance.currentUser; // User Reference
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('transPrefs')
            .doc(user.uid)
            .get();

        // Check if a document exists for the user's transportation prefs
        if (userDoc.exists && userDoc.data() != null) {
          final data = userDoc.data() as Map<String, dynamic>;

          bool bike = data['Bike'] ?? false; // Default to false if missing
          UserStorage.BikePref = bike;

          bool carpool =
              data['Carpool'] ?? false; // Default to false if missing
          UserStorage.DrivePref = carpool;

          bool walk = data['Walk'] ?? false; // Default to false if missing
          UserStorage.WalkPref = walk;
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  /// Fetch all user addresses from Firebase
  Future<void> fetchAddressesFromFirebase() async {
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

          // Iterate through address IDs and update them sequentially in the "Address" tab
          var addressIDs =
              List<String>.filled(UserStorage.NumOfAllowedAddresses, "Null");
          for (int i = 0; i < (addressIDs.length + 1); i++) {
            String addressKey = "address" + i.toString();
            String addressID = // Get the addressID for each address
                userData[addressKey] ?? "Null"; // Default to Null if missing

            if (addressID != "Null") {
              // Check if the ID is valid
              // Update Address
              DocumentSnapshot addressDoc =
                  await FirebaseFirestore.instance // Get the address's data
                      .collection('addresses')
                      .doc(addressID)
                      .get();

              if (addressDoc.exists && addressDoc.data() != null) {
                // Check if the user exists
                final addressData = addressDoc.data() as Map<String, dynamic>;

                // Add address to list of addresses
                final address = {
                  'streetAddress':
                      addressData['streetAddress'] ?? "Unknown_Street",
                  'aptSuite': addressData['aptSuite'] ?? "",
                  'city': addressData['city'] ?? "Unknown_City",
                  'state': addressData['state'] ?? "Unknown_State",
                  'zipCode': addressData['zipCode'] ?? "Unknown_Zip",
                  'name': addressData['name'] ?? "Saved Address",
                  'isDefault': addressData['isDefault'] ?? false
                };

                UserStorage.Addresses.add(address);
              }
            }
          }
        }
      }
    } catch (e) {
      print("Error fetching user address data: $e");
    }
  }

  /// Fetch all user contacts from Firebase
  Future<void> fetchContactsFromFirebase() async {
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

          // Iterate through contact IDs and update them sequentially in the "Contact" tab
          var contactIDs =
              List<String>.filled(UserStorage.NumOfAllowedContacts, "Null");
          for (int i = 0; i < (contactIDs.length + 1); i++) {
            String contactKey = "contact" + i.toString();
            String contactID = // Get the contactID for each address
                userData[contactKey] ?? "Null"; // Default to Null if missing

            if (contactID != "Null") {
              // Check if the ID is valid
              // Update Contact
              DocumentSnapshot contactDoc =
                  await FirebaseFirestore.instance // Get the address's data
                      .collection('contacts')
                      .doc(contactID)
                      .get();

              if (contactDoc.exists && contactDoc.data() != null) {
                // Check if the user exists
                final contactData = contactDoc.data() as Map<String, dynamic>;

                // Add contact to list of contacts
                final contact = {
                  'firstName': contactData['firstName'] ?? "Unknown_FirstName",
                  'lastName': contactData['lastName'] ?? "Unknown_LastName",
                  'phone': contactData['phone'] ?? "???-???-????",
                  'relationship':
                      contactData['relationship'] ?? "Other(specify)"
                };

                UserStorage.EmergencyContacts.add(contact);
              }
            }
          }
        }
      }
    } catch (e) {
      print("Error fetching user contact data: $e");
    }
  }

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
          var tripIDs =
              List<String>.filled(TripStorage.NumberOfAllowedTrips, "Null");
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
                    tripKey: tripData['tripKey'] ?? "Unknown_Key",
                    tripName: tripData['tripName'] ?? "Unnamed Trip",
                    status: tripData['tripStatus'] ?? "Pending",
                    selectedTransport: tripData['transPrefs'] ?? "Pending",
                    stop1: tripData['stop1'] ?? "Unknown_Stop",
                    stop2: tripData['stop2'] ?? "Unknown_Stop");

                // Store trip based on status
                if (newTrip.status == "Scheduled") {
                  TripStorage.scheduledTrips.add(newTrip); // Store locally
                  print(
                      "Scheduled Trip retrieved ${newTrip.tripName} from Firestore db!");
                } else {
                  TripStorage.pendingTrips.add(newTrip); // Store locally
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

  /// ************** Removal Methods **************
  /// Remove Trip from Firebase
  Future<void> removeTripFromFirebase(String tripKey) async {
    print("Starting trip deletion from backend...");
    try {
      User? user = FirebaseAuth.instance.currentUser; // User Reference
      if (user != null) {
        print("user found");
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance // Get the User's data
                .collection('users')
                .doc(user.uid)
                .get();

        if (userDoc.exists && userDoc.data() != null) {
          print("user doc found");
          // Check if the user exists
          final userData = userDoc.data() as Map<String, dynamic>;

          // Get the tripID for the trip we want to delete
          String tripID =
              userData[tripKey] ?? "Null"; // Default to Null if missing

          print("tripKey = " + tripKey);

          if (tripID != "Null") {
            print("tripID not null");
            // Check if the ID is valid
            // Delete the trip document directly
            await FirebaseFirestore.instance
                .collection('trips')
                .doc(tripID)
                .delete();

            // Remove tripID from user document
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .update({tripKey: FieldValue.delete()});

            // TODO: Update all keys to make sure they are in sequential order

            print("Trip deleted from Firestore successfully!");
          }
        }
      }
    } catch (e) {
      print("Error deleting trip data: $e");
    }
  }
}
