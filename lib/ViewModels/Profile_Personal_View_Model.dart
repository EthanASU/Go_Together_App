// Import packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModels/Profile_Screen_View_Model.dart';

// Firebase Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//View Model for the three tabs in the profile setup section (Personal/Address/Contact)
class ProfilePersonalSetUpViewModel extends ChangeNotifier {
  // Constructor
  ProfilePersonalSetUpViewModel() {
    fetchTransportationPrefsFromFirebase(); // Update transportation preferences on frontend from backend
    fetchAddressesFromFirebase(); // Update address information on frontend from backend
    fetchContactsFromFirebase(); // Update contact information on frontend from backend
  }

  // Firestore Reference and settings
  final _firestoreDB =
      FirebaseFirestore.instance; // Reference to the Firestore Database
  final _numOfAllowedAddresses = 5;
  final _numOfAllowedContacts = 3;

  // Tab navigation selection
  int tab_Index = 0;
  int get TabIndex => tab_Index;

  //--------------- Personal Tab ---------------//
  String email_Address = '';
  String phone_Number = '';
  Set<String> transportation_Modes = {};

  String get emailAddress => email_Address;
  String get phoneNumber => phone_Number;
  Set<String> get transportationModes => transportation_Modes;

  //Save Button variables
  bool is_Saved = false;
  bool get isSaved => is_Saved;

  //*Methods*//
  //update email
  void updateEmail(String email) {
    email_Address = email;
    storeEmailOnFirebase(email); // Store info in db
    notifyListeners();
  }

  //update phone number
  void updatePhone(String phone) {
    phone_Number = phone;
    storePhoneNumberOnFirebase(phone); // Store info in db
    notifyListeners();
  }

  //selecting the transportation method
  void toggleTransportationMode(String mode) {
    if (transportation_Modes.contains(mode)) {
      transportation_Modes.remove(mode);
      storeTransportationPrefsOnFirebase(mode, false); // Store info in db
    } else {
      transportation_Modes.add(mode);
      storeTransportationPrefsOnFirebase(mode, true); // Store info in db
    }
    notifyListeners();
  }

  // TODO: This was removed by Raymond
  // Get a simple boolean value from a transportation mode entered
  void setTransportationMode(String mode, bool toggle) {
    if (!toggle) {
      // if false
      if (transportation_Modes.contains(mode)) {
        transportation_Modes.remove(mode); // Remove Mode
      }
    } else {
      // if true
      if (!transportation_Modes.contains(mode)) {
        transportation_Modes.add(mode); // Add Mode
      }
    }
  }

  //updating selected tab
  void setSelectedTab(int index) {
    if (tab_Index == 1 && _showAddressForm && index != 1) {
      _showAddressForm = false;
      clearAddressForm();
    }
    //reset the tab to default page
    if (tab_Index == 2 && _showContactForm && index != 2) {
      _showContactForm = false;
      clearContactForm();
    }
    tab_Index = index;
    notifyListeners();
  }

  //Car information section//
  String? car_Year;
  String? car_Make;
  String? car_Model;
  String passenger_Count = '';

  // List to store car entries
  List<CarEntry> savedCars = [];

  final List<String> years =
      List.generate(30, (index) => (2024 - index).toString());

  //List of make and model for each car
  //Note: connected to a database in the future that has list of all makes and models so it does not need to be constantly updated
  final Map<String, List<String>> carModels = {
    'Acura': ['ILX', 'MDX', 'NSX', 'RDX', 'RLX', 'MDX Sport Hybrid'],
    'Adkins': [''],
    'Airstream': [''],
    'Altec': [''],
    'Amera-Lite': [''],
    'Ameritrans': [''],
    'Aston Martin': [''],
    'Audi': ['A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'Q3', 'Q5', 'Q7', 'Q8'],
    'BMW': [
      '1 Series',
      '2 Series',
      '3 Series',
      '4 Series',
      '5 Series',
      'X1',
      'X3',
      'X5'
    ],
    'Honda': ['Accord', 'Civic', 'CR-V', 'HR-V', 'Odyssey', 'Pilot'],
    'Toyota': ['Camry', 'Corolla', 'Highlander', 'RAV4', 'Tacoma', 'Tundra'],
    'Tesla': ['Model 3', 'Model S', 'Model X', 'Model Y'],
  };

  // Getters (existing)
  String? get carYear => car_Year;
  String? get carMake => car_Make;
  String? get carModel => car_Model;
  String get passengerCount => passenger_Count;

  List<String> get makes => carModels.keys.toList()..sort();

  List<String> get models {
    if (car_Make != null && carModels.containsKey(car_Make)) {
      return carModels[car_Make]!;
    }
    return ['Select Make First'];
  }

  // TODO: Removed by Raymond
  Map<String, dynamic> savedCarInfo = {};

  //Update functions for Year, Make, Model
  void updateCarYear(String? year) {
    car_Year = year;
    notifyListeners();
  }

  void updateCarMake(String? make) {
    car_Make = make;
    car_Model = null;
    notifyListeners();
  }

  void updateCarModel(String? model) {
    car_Model = model;
    notifyListeners();
  }

  void updatePassengerCount(String count) {
    if (count.isEmpty || int.tryParse(count) != null) {
      passenger_Count = count;
      notifyListeners();
    }
  }

  //add a car to the saved cars list
  void addCar() {
    if (isCarInfoComplete) {
      final newCar = CarEntry(
        year: car_Year!,
        make: car_Make!,
        model: car_Model!,
        passengerCount: passenger_Count,
      );
      savedCars.add(newCar);

      car_Year = null;
      car_Make = null;
      car_Model = null;
      passenger_Count = '';

      notifyListeners();
    }
  }

  //delete car from list
  void removeCar(int index) {
    if (index >= 0 && index < savedCars.length) {
      savedCars.removeAt(index);
      notifyListeners();
    }
  }

  // Check if current car information is complete
  bool get isCarInfoComplete {
    return carYear != null &&
        carMake != null &&
        carModel != null &&
        passengerCount.isNotEmpty;
  }

  void saveCarInformation() {
    if (savedCars.isNotEmpty) {
      is_Saved = true;
      notifyListeners();
    }
  }

  bool _isAddingCar = false;
  bool get isAddingCar => _isAddingCar;

  void toggleAddCarForm() {
    _isAddingCar = !_isAddingCar;
    notifyListeners();
  }

  //--------------- Address Tab ---------------//
  // Storage for addresses
  List<Map<String, dynamic>> _addresses = [];
  List<Map<String, dynamic>> get addresses => _addresses;
  bool _showAddressForm = false;

  String _streetAddress = '';
  String _aptSuite = '';
  String _city = '';
  String _state = '';
  String _zipCode = '';
  String _addressName = '';
  bool _isDefaultAddress = false;
  bool _isProfileComplete = false;

  Map<String, dynamic>? currentEditingAddress;
  int currentEditingAddressIndex = -1;

  // States list for dropdown
  final List<String> states = [
    'AL',
    'AK',
    'AZ',
    'AR',
    'CA',
    'CO',
    'CT',
    'DE',
    'FL',
    'GA',
    'HI',
    'ID',
    'IL',
    'IN',
    'IA',
    'KS',
    'KY',
    'LA',
    'ME',
    'MD',
    'MA',
    'MI',
    'MN',
    'MS',
    'MO',
    'MT',
    'NE',
    'NV',
    'NH',
    'NJ',
    'NM',
    'NY',
    'NC',
    'ND',
    'OH',
    'OK',
    'OR',
    'PA',
    'RI',
    'SC',
    'SD',
    'TN',
    'TX',
    'UT',
    'VT',
    'VA',
    'WA',
    'WV',
    'WI',
    'WY'
  ];

  // Getters
  bool get showAddressForm => _showAddressForm;
  String get streetAddress => _streetAddress;
  String get aptSuite => _aptSuite;
  String get city => _city;
  String get state => _state;
  String get zipCode => _zipCode;
  String get addressName => _addressName;
  bool get isDefaultAddress => _isDefaultAddress;
  bool get isProfileComplete => _isProfileComplete;

  // Add this setter
  set showAddressForm(bool value) {
    _showAddressForm = value;
    notifyListeners();
  }

  set addressName(String value) {
    _addressName = value;
    notifyListeners();
  }

  set streetAddress(String value) {
    _streetAddress = value;
    notifyListeners();
  }

  //*Methods for updating the information entered into the address form section*//
  void toggleAddressForm() {
    _showAddressForm = !_showAddressForm;
    notifyListeners();
  }

  void updateStreetAddress(String value) {
    _streetAddress = value;
    notifyListeners();
  }

  void updateAptSuite(String value) {
    _aptSuite = value;
    notifyListeners();
  }

  void updateCity(String value) {
    _city = value;
    notifyListeners();
  }

  void updateState(String? value) {
    _state = value ?? '';
    notifyListeners();
  }

  void updateZipCode(String value) {
    _zipCode = value;
    notifyListeners();
  }

  void updateAddressName(String value) {
    _addressName = value;
    notifyListeners();
  }

  void toggleDefaultAddress(bool? value) {
    _isDefaultAddress = value ?? false;
    notifyListeners();
  }

  // TODO: Prompt something on the user's screen when they exceed the address amount;
  //  I made the function return a bool on whether or not they successfully added an address to make the implementation easier.
  bool saveAddress() {
    if (addresses.length > (_numOfAllowedAddresses - 1)) {
      print(
          "Exceeded the number of allowed addresses for this account. Address was not added");
      return false;
    }

    final newAddress = {
      'streetAddress': _streetAddress,
      'aptSuite': _aptSuite,
      'city': _city,
      'state': _state,
      'zipCode': _zipCode,
      'name': _addressName.isEmpty ? 'Saved Address' : _addressName,
      'isDefault': _isDefaultAddress,
    };

    //Setting the default address
    if (_isDefaultAddress || addresses.isEmpty) {
      for (var address in addresses) {
        address['isDefault'] = false;
      }
      newAddress['isDefault'] = true;
    }

    addresses.add(newAddress);
    storeAddressOnFirebase(newAddress);
    clearAddressForm();
    _showAddressForm = false;
    notifyListeners();
    return true;
  }

  void clearAddressForm() {
    _streetAddress = '';
    _aptSuite = '';
    _city = '';
    _state = '';
    _zipCode = '';
    _addressName = '';
    _isDefaultAddress = false;
  }

  bool get isAddressFormValid {
    return _streetAddress.isNotEmpty &&
        _city.isNotEmpty &&
        _state.isNotEmpty &&
        _zipCode.isNotEmpty;
  }

  // TODO: Implement Firebase with edits
  //Edit button for Address
  void editAddress(Map<String, dynamic> address, int index) {
    // Store the address being edited and its index
    currentEditingAddress = address;
    currentEditingAddressIndex = index;

    // Pre-populate the form fields with existing address data
    _addressName = address['name'] ?? '';
    _streetAddress = address['streetAddress'] ?? '';
    _aptSuite = address['aptSuite'] ?? '';
    _city = address['city'] ?? '';
    _state = address['state'] ?? '';
    _zipCode = address['zipCode'] ?? '';
    _isDefaultAddress = address['isDefault'] ?? false;

    // Show the address form
    _showAddressForm = true;
    notifyListeners();
  }

  void updateExistingAddress() {
    if (currentEditingAddressIndex != -1 && isAddressFormValid) {
      // Create updated address
      final updatedAddress = {
        'name': addressName,
        'streetAddress': streetAddress,
        'aptSuite': aptSuite,
        'city': city,
        'state': state,
        'zipCode': zipCode,
        'isDefault': isDefaultAddress,
      };

      // Update list
      final updatedAddresses = List<Map<String, dynamic>>.from(addresses);
      updatedAddresses[currentEditingAddressIndex] = updatedAddress;

      // If this is set as default, make sure others are not default
      if (isDefaultAddress) {
        for (int i = 0; i < updatedAddresses.length; i++) {
          if (i != currentEditingAddressIndex) {
            updatedAddresses[i] =
                Map<String, dynamic>.from(updatedAddresses[i]);
            updatedAddresses[i]['isDefault'] = false;
          }
        }
      }

      // Update address list
      _addresses = updatedAddresses;

      // Reset editing state
      currentEditingAddressIndex = -1;
      currentEditingAddress = null;

      // Clear form
      clearAddressForm();
      _showAddressForm = false;

      notifyListeners();
    }
  }

//--------------- Emergency Contact Tab ---------------//
  bool _showContactForm = false;
  List<Map<String, dynamic>> emergencyContacts = [];

  //Form Fields
  String _contactFirstName = '';
  String _contactLastName = '';
  String _contactPhone = '';
  String _relationship = '';

  // Relationship dropdown
  final List<String> relationships = [
    'Parent',
    'Guardian',
    'Sibling',
    'Grandparent',
    'Aunt/Uncle',
    'Other(specify)'
  ];

  bool get showContactForm => _showContactForm;
  String get contactFirstName => _contactFirstName;
  String get contactLastName => _contactLastName;
  String get contactPhone => _contactPhone;
  String get relationship => _relationship;

  //*Methods for the emergency contact form*//
  void toggleContactForm() {
    _showContactForm = !_showContactForm;
    notifyListeners();
  }

  void updateContactFirstName(String value) {
    _contactFirstName = value;
    notifyListeners();
  }

  void updateContactLastName(String value) {
    _contactLastName = value;
    notifyListeners();
  }

  void updateContactPhone(String value) {
    _contactPhone = value;
    notifyListeners();
  }

  void updateRelationship(String? value) {
    _relationship = value ?? '';
    notifyListeners();
  }

  // TODO: Prompt something on the user's screen when they exceed the address amount;
  //  I made the function return a bool on whether or not they successfully added an address to make the implementation easier.
  bool saveEmergencyContact() {
    if (emergencyContacts.length > (_numOfAllowedContacts - 1)) {
      print(
          "Exceeded the number of allowed emergency contacts for this account. Contact was not added");
      return false;
    }

    final newContact = {
      'firstName': _contactFirstName,
      'lastName': _contactLastName,
      'phone': _contactPhone,
      'relationship': _relationship,
    };
    emergencyContacts.add(newContact);
    clearContactForm();
    storeContactOnFirebase(newContact);
    _showContactForm = false;
    notifyListeners();
    return true;
  }

  void clearContactForm() {
    _contactFirstName = '';
    _contactLastName = '';
    _contactPhone = '';
    _relationship = '';
    phoneController.clear(); // Clear the phone controller
    phoneController.value = TextEditingValue(
      // Reset to empty with proper hint text
      text: '',
      selection: const TextSelection.collapsed(offset: 0),
    );
    notifyListeners();
  }

  //ensure that all fields are filled out before saving
  bool get isContactFormValid {
    return _contactFirstName.isNotEmpty &&
        _contactLastName.isNotEmpty &&
        _contactPhone.isNotEmpty &&
        _relationship.isNotEmpty;
  }

  //Method to ensure that phone number text field is filled in correctly
  //* only accepts digits, adds - where needed and is limited to 10 digits
  final phoneController = TextEditingController();
  String formatPhoneNumber(String input) {
    //only allow digits to be entered
    String digits = input.replaceAll(RegExp(r'[^\d]'), '');

    // Limit to 10 digits
    if (digits.length > 10) {
      digits = digits.substring(0, 10);
    }

    // Format the number as XXX-XXX-XXXX
    String formatted = '';
    for (int i = 0; i < digits.length; i++) {
      if (i == 3 || i == 6) {
        formatted += '-';
      }
      formatted += digits[i];
    }
    return formatted;
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  //-----updating information from the forms onto the main profile page-----//
// Update addresses
  void updateAddresses(List<Map<String, dynamic>> newAddresses) {
    _addresses = newAddresses;
    _isProfileComplete = true;
    notifyListeners();
  }

// Format address for display
  String formatAddressLine(Map<String, dynamic> address) {
    return '${address['streetAddress']}, ${address['city']}, ${address['state']} ${address['zipCode']}';
  }

  void initializeFromMainProfile(ProfileViewModel mainViewModel) {
    updateEmail(mainViewModel.emailAddress);
    updatePhone(mainViewModel.phoneNumber);
    _addresses = List.from(mainViewModel.addresses);

    emergencyContacts = List.from(mainViewModel.emergencyContacts);

    notifyListeners();
  }

  bool savePersonalInfo() {
    if (email_Address.isNotEmpty && phone_Number.isNotEmpty) {
      // Check transportation modes
      if (!transportation_Modes.contains('Carpool') ||
          (transportation_Modes.contains('Carpool') && savedCars.isNotEmpty)) {
        is_Saved = true;

        if (transportation_Modes.contains('Walk')) {}
        if (transportation_Modes.contains('Bike')) {}

        if (transportation_Modes.contains('Carpool')) {
          saveCarInformation();
        }
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  bool canSave() {
    if (email_Address.isEmpty || phone_Number.isEmpty) {
      return false;
    }
    if (transportation_Modes.isEmpty) {
      return false;
    }
    if (transportation_Modes.contains('Carpool') && savedCars.isEmpty) {
      return false;
    }

    return true;
  }

  // Methods to store information
  void storeEmailAndPhone(String email, String phoneNumber) {
    email_Address = email;
    phone_Number = phoneNumber;
    notifyListeners();
  }

  bool savePersonalInfoToMainProfile(BuildContext context) {
    // Validate information
    if (canSave()) {
      final mainViewModel =
          Provider.of<ProfileViewModel>(context, listen: false);

      mainViewModel.updateEmailAddress(email_Address);
      mainViewModel.updatePhoneNumber(phone_Number);
      is_Saved = true;
      notifyListeners();

      return true;
    }

    return false;
  }

  //--------------- Firebase ---------------//
  /// Store Phone Number in Firebase
  Future<void> storePhoneNumberOnFirebase(String phoneNum) async {
    User? user = FirebaseAuth.instance.currentUser; // User Reference

    // Store phone as a pair to parse database
    final data = {"phoneNumber": phoneNum};

    // Store in database
    await _firestoreDB
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
    await _firestoreDB
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
    await _firestoreDB
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
        _firestoreDB.collection("users").doc().id; // Generate random ID

    // Store the address in the right user data entry
    int addressNum = addresses.length;
    String addressKey = "address" + addressNum.toString();

    // Store address as a pair to parse database
    final data = {addressKey: randomId};

    // Store in database
    await _firestoreDB
        .collection('users') // Document "users"
        .doc(user!.uid) // User UID
        .set(data, SetOptions(merge: true)); // Set data in existing doc

    // Generate and store address with ID
    await _firestoreDB.collection('addresses').doc(randomId).set({
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
        _firestoreDB.collection("users").doc().id; // Generate random ID

    // Store the contact in the right user data entry
    int contactNum = emergencyContacts.length;
    String contactKey = "contact" + contactNum.toString();

    // Store contact as a pair to parse database
    final data = {contactKey: randomId};

    // Store in database
    await _firestoreDB
        .collection('users') // Document "users"
        .doc(user!.uid) // User UID
        .set(data, SetOptions(merge: true)); // Set data in existing doc

    // Generate and store contact with ID
    await _firestoreDB.collection('contacts').doc(randomId).set({
      'firstName': contactInfo['firstName'],
      'lastName': contactInfo['lastName'],
      'phone': contactInfo['phone'],
      'relationship': contactInfo['relationship']
    });

    print("User contact $contactKey stored in db as $randomId");
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
          setTransportationMode('Bike', bike);

          bool carpool =
              data['Carpool'] ?? false; // Default to false if missing
          setTransportationMode('Carpool', carpool);

          bool walk = data['Walk'] ?? false; // Default to false if missing
          setTransportationMode('Walk', walk);

          notifyListeners();
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
          var addressIDs = List<String>.filled(_numOfAllowedAddresses, "Null");
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

                addresses.add(address);
              }
            }
          }
        }
        notifyListeners();
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
          var contactIDs = List<String>.filled(_numOfAllowedContacts, "Null");
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

                emergencyContacts.add(contact);
              }
            }
          }
        }
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching user contact data: $e");
    }
  }
}

class CarEntry {
  final String year;
  final String make;
  final String model;
  final String passengerCount;

  CarEntry({
    required this.year,
    required this.make,
    required this.model,
    required this.passengerCount,
  });
}
