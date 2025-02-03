import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModels/Profile_Personal_View_Model.dart';

class ProfileCompletionScreen extends StatelessWidget {
  const ProfileCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfilePersonalSetUpViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 200),

            //Navigation Tab Bar
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

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(45),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Email Field
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
                          'Drive',
                          'Assets/Drive_Button.png',
                          viewModel,
                        ),
                        _buildTransportOption(
                          context,
                          'Bike',
                          'Assets/Bike_Button.png',
                          viewModel,
                        ),
                        _buildTransportOption(
                          context,
                          'Walk',
                          'Assets/person_icon.png',
                          viewModel,
                        ),
                      ],
                    ),
                    //-----------------Storing Car information Section------------------//
                    // Car Information Section (Appears only when the Drive Button is selected)
                    if (viewModel.transportationModes.contains('Drive')) ...[
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

                      //Year Label and DropDown
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,  // Makes dropdowns full width
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
                          const SizedBox(height: 16),  // Vertical spacing between dropdowns

                          //Make Label and DropDown
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
                          const SizedBox(height: 16),  // Vertical spacing between dropdowns

                          //Model Label and DropDown
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
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Passenger Counter
                      Row(
                        children: [
                          const Text(
                            'How many passengers?',
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
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              onChanged: viewModel.updatePassengerCount,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

            //           // Save Button(information should only be saved when button is pressed)
            //           Padding(
            //             padding: const EdgeInsets.symmetric(vertical: 20),
            //             child: Center(
            //               child: ElevatedButton(
            //                 onPressed: () {
            //                   viewModel.saveCarInformation();
            //                   ScaffoldMessenger.of(context).showSnackBar(
            //                     const SnackBar(
            //                       content: Text('Saved!'),
            //                       backgroundColor: Color(0xFF8BC541),
            //                     ),
            //                   );
            //                 },
            //                 style: ElevatedButton.styleFrom(
            //                   backgroundColor: const Color(0xFF8BC541),
            //                   padding: const EdgeInsets.symmetric(
            //                     horizontal: 55,
            //                     vertical: 10,
            //                   ),
            //                   shape: RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.circular(23),
            //                   ),
            //                 ),
            //                 child: const Text(
            //                   'Save',
            //                   style: TextStyle(
            //                     color: Colors.white,
            //                     fontSize: 23,
            //                     fontWeight: FontWeight.bold,
            //                     fontFamily: 'Poppins',
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ),
            //
            //           // Added bottom padding to ensure last elements are visible
            //           const SizedBox(height: 40),
            //         ],
            //       ],
            //     ),
            //   ),
            // ),
// Add save button section here
                      if (!viewModel.isSaved) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: viewModel.isCarInfoComplete
                                  ? () {
                                viewModel.saveCarInformation();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Saved!'),
                                    backgroundColor: Color(0xFF8BC541),
                                  ),
                                );
                              }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: viewModel.isCarInfoComplete
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
                    ], // End of Drive section
                  ],
                ),
              ),
            ),


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
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconPath,
              height: 60,  // Adjust size as needed
              width: 60,   // Adjust size as needed

            ),
            const SizedBox(height: 4),
            Text(
              mode,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.grey,
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}