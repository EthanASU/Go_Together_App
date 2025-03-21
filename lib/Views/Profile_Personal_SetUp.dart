//import packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModels/Profile_Personal_View_Model.dart';
import '../Views/Profile_AddressForm.dart';
import '../Views/Profile_Contact_Form.dart';
import 'Profile_Screen_Setup.dart';
import '../Widgets/address_card.dart';
import 'package:flutter/services.dart';

//View for the three tabs in the profile page section (personal, address, contact)
class ProfileCompletionScreen extends StatelessWidget {
  const ProfileCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfilePersonalSetUpViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Done button at top right
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ProfileSetUp(), // Your initial profile page
                        ),
                      );
                    },
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Color(0xFF8BC541),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 200),

            //------------- Navigation Tab Bar -------------//
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFF8BC541), width: 2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTab(context, 'Personal', 0),
                  _buildTab(context, 'Address', 1),
                  _buildTab(context, 'Contact', 2),
                ],
              ),
            ),

            //------------- Personal Tab -------------//
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(45),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Email Field
                    if (viewModel.TabIndex == 0) ...[
                      const Text(
                        'Email address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: viewModel.updateEmail,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Phone Number Field
                      const Text(
                        'Phone number',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: viewModel.updatePhone,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      //Select Transportation Method
                      Row(
                        children: const [
                          Text(
                            'I will ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            '(Select all that apply)',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTransportOption(
                            context,
                            'Carpool',
                            'Assets/Drive_icon.png',
                            viewModel,
                          ),
                          _buildTransportOption(
                            context,
                            'Bike',
                            'Assets/Bike_icon.png',
                            viewModel,
                          ),
                          _buildTransportOption(
                            context,
                            'Walk',
                            'Assets/Pedestrian_icon.png',
                            viewModel,
                          ),
                        ],
                      ),
                      //----------------------Idea 2 -----------------------//
                      if (viewModel.transportationModes
                          .contains('Carpool')) ...[
                        const SizedBox(height: 30),
                        Row(
                          children: const [
                            Text(
                              'Car Information ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              '*',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Display Previously Added Cars
                        const Text(
                          'Cars Added',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Display added cars
                        if (viewModel.savedCars.isNotEmpty) ...[
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: viewModel.savedCars.length,
                            itemBuilder: (context, index) {
                              final car = viewModel.savedCars[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  title: Text(
                                      '${car.year} ${car.make} ${car.model}'),
                                  subtitle: Text(
                                      'Available Seats: ${car.passengerCount}'),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      viewModel.removeCar(index);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                        ] else ...[
                          Container(
                            alignment: Alignment.center,
                            child: const Text(
                              'No Cars Added',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        // Show car form only when adding a car
                        if (viewModel.isAddingCar) ...[
                          // Car Information Form
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Year Dropdown
                              const Text(
                                'Year',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 16),

                              DropdownButtonFormField<String>(
                                value: viewModel.carYear,
                                decoration: const InputDecoration(
                                  labelText: 'Select',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                items: viewModel.years.map((String year) {
                                  return DropdownMenuItem<String>(
                                    value: year,
                                    child: Text(year),
                                  );
                                }).toList(),
                                onChanged: viewModel.updateCarYear,
                              ),
                              const SizedBox(height: 16),

                              // Make Dropdown
                              const Text(
                                'Make',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: viewModel.carMake,
                                decoration: const InputDecoration(
                                  labelText: 'Select',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                items: viewModel.makes.map((String make) {
                                  return DropdownMenuItem<String>(
                                    value: make,
                                    child: Text(make),
                                  );
                                }).toList(),
                                onChanged: viewModel.updateCarMake,
                              ),
                              const SizedBox(height: 16),

                              // Model Dropdown
                              const Text(
                                'Model',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: viewModel.carModel,
                                decoration: const InputDecoration(
                                  labelText: 'Select',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                items: viewModel.models.map((String model) {
                                  return DropdownMenuItem<String>(
                                    value: model,
                                    child: Text(model),
                                  );
                                }).toList(),
                                onChanged: viewModel.updateCarModel,
                              ),
                              const SizedBox(height: 16),

                              //Seat Count
                              Row(
                                children: [
                                  const Text(
                                    'Available seats',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  SizedBox(
                                    width: 50,
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                      ),
                                      onChanged: viewModel.updatePassengerCount,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Add Car Button (when form is showing)
                              Center(
                                child: ElevatedButton.icon(
                                  onPressed: viewModel.isCarInfoComplete
                                      ? () {
                                          viewModel.addCar();
                                          viewModel
                                              .toggleAddCarForm(); // Hide form after adding
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text('Car Added!'),
                                              backgroundColor:
                                                  Color(0xFF8BC541),
                                            ),
                                          );
                                        }
                                      : null,
                                  icon: const Icon(Icons.add,
                                      color: Colors.white),
                                  label: const Text(
                                    'Add Car',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: viewModel.isCarInfoComplete
                                        ? Colors.blue
                                        : Colors.grey,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(23),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],

                        // Show list of added cars and "Add Another Car" button when not adding
                        if (!viewModel.isAddingCar) ...[
                          // "Add Another Car" button
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () => viewModel.toggleAddCarForm(),
                              icon: const Icon(Icons.add, color: Colors.white),
                              label: Text(
                                viewModel.savedCars.isEmpty
                                    ? 'Add Car'
                                    : 'Add Another Car',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(23),
                                ),
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 20),
                        // Save Button
                        if (!viewModel.isSaved) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: ElevatedButton(
                                onPressed: viewModel.savedCars.isNotEmpty
                                    ? () {
                                        viewModel.saveCarInformation();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Saved!'),
                                            backgroundColor: Color(0xFF8BC541),
                                          ),
                                        );
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      viewModel.savedCars.isNotEmpty
                                          ? const Color(0xFF8BC541)
                                          : Colors.grey,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 55,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(23),
                                  ),
                                ),
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Text(
                                'Saved!',
                                style: TextStyle(
                                  color: Color(0xFF8BC541),
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 40),
                      ] // End of Drive section
                    ]
                    //------------------ Address Tab Section ------------------//
                    else if (viewModel.TabIndex == 1) ...[
                      if (!viewModel.showAddressForm) ...[
                        // Show existing addresses
                        ...viewModel.addresses.map((address) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        address['isDefault']
                                            ? 'Home (Default)'
                                            : address['name'],
                                        style: const TextStyle(
                                          color: Color(0xFF188ECE),
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        address['aptSuite'].isEmpty
                                            ? '${address['streetAddress']}'
                                            : '${address['streetAddress']}, ${address['aptSuite']}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      Text(
                                        '${address['city']}, ${address['state']} ${address['zipCode']}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Handle edit
                                  },
                                  child: const Text(
                                    'Edit',
                                    style: TextStyle(
                                      color: Color(0xFF188ECE),
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),

                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(
                            left: 10,
                            top: 10,
                          ),
                          child: InkWell(
                            onTap: () {
                              viewModel.toggleAddressForm();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Horizontal line
                                      Container(
                                        height: 5,
                                        width: 16,
                                        color: Color(0xFF188ECE),
                                      ),
                                      // Vertical line
                                      Container(
                                        width: 5,
                                        height: 16,
                                        color: Color(0xFF188ECE),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  viewModel.addresses.isEmpty
                                      ? 'Add address'
                                      : 'Add another address',
                                  style: TextStyle(
                                    color: Color(0xFF188ECE),
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ] else ...[
                        AddressFormScreen(
                          viewModel: viewModel,
                        ),
                      ]
                    ]
                    //------------------ End of Address Tab Section ---------------//

                    //------------------ Emergency Contact Section ----------------//
                    else if (viewModel.TabIndex == 2) ...[
                      if (!viewModel.showContactForm) ...[
                        // Store Created Contacts
                        ...viewModel.emergencyContacts.map((contact) {
                          int index =
                              viewModel.emergencyContacts.indexOf(contact) + 1;
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Emergency Contact $index',
                                      style: const TextStyle(
                                        color: Color(0xFF188ECE),
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '${contact['firstName']} ${contact['lastName']} (${contact['relationship']})',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    Text(
                                      contact['phone'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Handle edit
                                  },
                                  child: const Text(
                                    'Edit',
                                    style: TextStyle(
                                      color: Color(0xFF188ECE),
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),

                        // Add emergency contact button
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(
                            left: 10,
                            top: 10,
                          ),
                          child: InkWell(
                            onTap: () {
                              viewModel.clearContactForm();
                              viewModel.toggleContactForm();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Horizontal line
                                      Container(
                                        height: 5, // Thickness of the plus
                                        width: 16,
                                        color: Color(0xFF188ECE),
                                      ),
                                      // Vertical line
                                      Container(
                                        width: 5, // Thickness of the plus
                                        height: 16,
                                        color: Color(0xFF188ECE),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  viewModel.addresses.isEmpty
                                      ? 'Add emergency contact'
                                      : 'Add emergency contact',
                                  style: TextStyle(
                                    color: Color(0xFF188ECE),
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Warning message - only show if no contacts
                        if (viewModel.emergencyContacts.isEmpty) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(Icons.warning,
                                    color: Colors.red, size: 24),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'You must add an emergency contact before scheduling any trips',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else if (viewModel.emergencyContacts.length == 1) ...[
                          // New warning for single contact
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(Icons.warning,
                                    color: Colors.red, size: 24),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'We recommend adding at least 2 emergency contacts',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ] else ...[
                        // Emergency Contact Form
                        ContactFormScreen(
                          viewModel: viewModel,
                        ),
                      ],
                    ]
                  ],
                ),
              ),
            ),
            //------------------ End of Emergency Tab Section ---------------//

            // Bottom Navigation Bar
            BottomNavigationBar(
              currentIndex: 4,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'Assets/Tab_Bar_Home_Icon.png',
                    height: 24,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'Assets/Tab_Bar_Calendar_Icon.png',
                    height: 24,
                  ),
                  label: 'Calendar',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'Assets/Tab_Bar_Add_Icon.png',
                    height: 24,
                  ),
                  label: 'My Trip',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'Assets/Tab_Bar_Chat_Icon.png',
                    height: 24,
                  ),
                  label: 'Chat',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, String title, int index) {
    final viewModel = context.watch<ProfilePersonalSetUpViewModel>();
    final isSelected = viewModel.TabIndex == index;

    return GestureDetector(
      onTap: () => viewModel.setSelectedTab(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFF188ECE) : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  Widget _buildTransportOption(
    BuildContext context,
    String mode,
    String iconPath,
    ProfilePersonalSetUpViewModel viewModel,
  ) {
    final isSelected = viewModel.transportationModes.contains(mode);

    return GestureDetector(
      onTap: () => viewModel.toggleTransportationMode(mode),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? Color(0xFF188ECE)
              : Colors.transparent, // Blue background when selected
          border: Border.all(
            color: isSelected ? Color(0xFF188ECE) : Colors.grey,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                isSelected
                    ? Colors.white
                    : Colors.black, // White icon when selected
                BlendMode.srcIn,
              ),
              child: Image.asset(
                iconPath,
                height: 60,
                width: 60,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              mode,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 13,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
