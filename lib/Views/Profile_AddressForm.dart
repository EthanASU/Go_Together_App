//import packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModels/Profile_Personal_View_Model.dart';
import 'Profile_Screen_Setup.dart';

class AddressFormScreen extends StatelessWidget {
  // const AddressFormScreen({Key? key}) : super(key: key);

  final ProfilePersonalSetUpViewModel viewModel;

  const AddressFormScreen({
    Key? key,
    required this.viewModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //final viewModel = context.watch<ProfilePersonalSetUpViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Address Form
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Pick-up/Drop-off Location',
              style: TextStyle(
                color: Color(0xFF188ECE),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Street Address
            TextField(
              onChanged: viewModel.updateStreetAddress,
              decoration: InputDecoration(
                hintText: 'Street Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Apt, Suite (Optional)
            TextField(
              onChanged: viewModel.updateAptSuite,
              decoration: InputDecoration(
                hintText: 'Apt, suite, etc. (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // City, State, Zip Row
            Row(
              children: [
                // City
                Expanded(
                  child: TextField(
                    onChanged: viewModel.updateCity,
                    decoration: InputDecoration(
                      hintText: 'City',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // State
                SizedBox(
                  width: 100,
                  child: DropdownButtonFormField<String>(
                    value: viewModel.state.isEmpty ? null : viewModel.state,
                    decoration: InputDecoration(
                      hintText: 'State',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: viewModel.states.map((String state) {
                      return DropdownMenuItem<String>(
                        value: state,
                        child: Text(state),
                      );
                    }).toList(),
                    onChanged: viewModel.updateState,
                  ),
                ),
                const SizedBox(width: 8),

                // Zip Code
                SizedBox(
                  width: 100,
                  child: TextField(
                    onChanged: viewModel.updateZipCode,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Zip Code',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Name this address (Optional)
            TextField(
              onChanged: viewModel.updateAddressName,
              decoration: InputDecoration(
                hintText: 'Name this address (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Default Address Checkbox
            Row(
              children: [
                Checkbox(
                  value: viewModel.isDefaultAddress,
                  onChanged: viewModel.toggleDefaultAddress,
                ),
                const Text(
                  'Default Address',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Add Button
            Center(
              child: ElevatedButton(
                onPressed: viewModel.isAddressFormValid
                    ? viewModel.saveAddress
                    : null, // Button disabled when form invalid
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF8BC541), // Color when enabled
                  disabledBackgroundColor:
                      const Color(0x808BC541), // Color when disabled
                  padding: const EdgeInsets.symmetric(
                    horizontal: 55,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(23),
                  ),
                ),
                child: const Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
