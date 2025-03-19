//import packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//View Model for the three tabs in the profile setup section (Personal/Address/Contact)
class ProfilePersonalSetUpViewModel extends ChangeNotifier {
  // Firestore Reference
  final firestoreDB =
      FirebaseFirestore.instance; // Reference to the Firestore Database

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
    updateEmailOnFirebase(email); // Store info in db
    notifyListeners();
  }

  //update phone number
  void updatePhone(String phone) {
    phone_Number = phone;
    updatePhoneNumberOnFirebase(phone); // Store info in db
    notifyListeners();
  }

  //selecting the transportation method
  void toggleTransportationMode(String mode) {
    if (transportation_Modes.contains(mode)) {
      transportation_Modes.remove(mode);
      updateTransportationInfoOnFirebase(mode, false); // Store info in db
    } else {
      transportation_Modes.add(mode);
      updateTransportationInfoOnFirebase(mode, true); // Store info in db
    }
    notifyListeners();
  }

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

  // Saved data structure
  Map<String, dynamic> savedCarInfo = {};

  List<String> get makes => carModels.keys.toList()..sort();
  List<String> get models {
    if (car_Make != null && carModels.containsKey(car_Make)) {
      return carModels[car_Make]!;
    }
    return ['Select Make First'];
  }

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
  List<Map<String, dynamic>> addresses = [];
  bool _showAddressForm = false;

  String _streetAddress = '';
  String _aptSuite = '';
  String _city = '';
  String _state = '';
  String _zipCode = '';
  String _addressName = '';
  bool _isDefaultAddress = false;

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

  void saveAddress() {
    final newAddress = {
      'streetAddress': _streetAddress,
      'aptSuite': _aptSuite,
      'city': _city,
      'state': _state,
      'zipCode': _zipCode,
      'name': _addressName.isEmpty ? 'Home' : _addressName,
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
    clearAddressForm();
    _showAddressForm = false;
    notifyListeners();
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

  void saveEmergencyContact() {
    final newContact = {
      'firstName': _contactFirstName,
      'lastName': _contactLastName,
      'phone': _contactPhone,
      'relationship': _relationship,
    };
    emergencyContacts.add(newContact);
    clearContactForm();
    _showContactForm = false;
    notifyListeners();
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

  //--------------- Fire Store Methods ---------------//
  /// Update Phone Number in database
  Future<void> updatePhoneNumberOnFirebase(String phoneNum) async {
    User? user = FirebaseAuth.instance.currentUser;

    // Store email as a pair to parse database
    final data = {"phoneNumber": phoneNum};

    // Store in database
    await firestoreDB
        .collection('users') // Document "transPrefs
        .doc(user!.uid) // User UID
        .set(data, SetOptions(merge: true)); // Set data in existing doc

    print("User phone number stored in db as $phoneNum");
  }

  /// Update Email in database
  Future<void> updateEmailOnFirebase(String email) async {
    User? user = FirebaseAuth.instance.currentUser;

    // Store email as a pair to parse database
    final data = {"email": email};

    // Store in database
    await firestoreDB
        .collection('users') // Document "transPrefs
        .doc(user!.uid) // User UID
        .set(data, SetOptions(merge: true)); // Set data in existing doc

    print("User email number stored in db as $email");
  }

  /// Update transportation prefs in database
  Future<void> updateTransportationInfoOnFirebase(
      String type, bool setting) async {
    User? user = FirebaseAuth.instance.currentUser;

    // Store pref as a pair to parse database
    final data = {type: setting};

    // Store in database
    await firestoreDB
        .collection('transPrefs') // Document "transPrefs
        .doc(user!.uid) // User UID
        .set(data, SetOptions(merge: true)); // Set data in existing doc

    print("User transportation prefs $type stored in db as $setting");
  }

  Future<void> fetchTransportationPrefsFromFirebase() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('transPrefs')
            .doc(user.uid)
            .get();

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
