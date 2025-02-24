import 'package:flutter/material.dart';

class ProfilePersonalSetUpViewModel extends ChangeNotifier {
  // Tab navigation selection
  int tab_Index = 0;
  int get TabIndex => tab_Index;

  //Storing User information
  String email_Address = '';
  String phone_Number = '';
  Set<String> transportation_Modes = {};

  String get emailAddress => email_Address;
  String get phoneNumber => phone_Number;
  Set<String> get transportationModes => transportation_Modes;


  //Save Button variables
  bool is_Saved = false;
  bool get isSaved => is_Saved;
  //updating the user information

  //updating email
  void updateEmail(String email) {
    email_Address = email;
    notifyListeners();
  }
  //updating phone number
  void updatePhone(String phone) {
    phone_Number = phone;
    notifyListeners();
  }
  //selecting the transportation method
  void toggleTransportationMode(String mode) {
    if (transportation_Modes.contains(mode)) {
      transportation_Modes.remove(mode);
    } else {
      transportation_Modes.add(mode);
    }
    notifyListeners();
  }

  void setSelectedTab(int index) {
    tab_Index = index;
    notifyListeners();
  }

  //Car Information Section
  String? car_Year;
  String? car_Make;
  String? car_Model;
  String passenger_Count = '';

  final List<String> years = List.generate(30, (index) => (2024 - index).toString());
  // final List<String> makes =  ['Acura', 'Adkins', 'Airstream', 'Altec', 'Amera-Lite', 'Ameritrans', 'Aston Martin', 'Audi'];
  // final List<String> models = ['ILX','MDX','NSX','RDX','RLX','MDX Sport Hybrid'];

  final Map<String, List<String>> carModels = {
    'Acura': ['ILX', 'MDX', 'NSX', 'RDX', 'RLX', 'MDX Sport Hybrid'],
    'Adkins':[''],
    'Airstream':[''],
    'Altec':[''],
    'Amera-Lite':[''],
    'Ameritrans':[''],
    'Aston Martin':[''],
    'Audi': ['A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'Q3', 'Q5', 'Q7', 'Q8'],
    'BMW': ['1 Series', '2 Series', '3 Series', '4 Series', '5 Series', 'X1', 'X3', 'X5'],
    'Honda': ['Accord', 'Civic', 'CR-V', 'HR-V', 'Odyssey', 'Pilot'],
    'Toyota': ['Camry', 'Corolla', 'Highlander', 'RAV4', 'Tacoma', 'Tundra'],
    'Tesla': ['Model 3', 'Model S', 'Model X', 'Model Y'],
  };

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
  //update functions for year, make, model
  //Note: they should only be saved once the save button has been pressed
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
    //only allow number entries
    if (count.isEmpty || int.tryParse(count) != null) {
      passenger_Count = count;
      notifyListeners();
    }
  }
  bool get isCarInfoComplete {
    return carYear != null &&
        carMake != null &&
        carModel != null &&
        passengerCount.isNotEmpty;
  }

  void saveCarInformation() {
    if (isCarInfoComplete) {
      is_Saved = true;
      notifyListeners();
    }
  }

}