import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../ViewModels/Profile_Personal_View_Model.dart';
import 'Profile_Screen_Setup.dart';

class ContactFormScreen extends StatelessWidget {
  final ProfilePersonalSetUpViewModel viewModel;

  const ContactFormScreen({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'New emergency contact',
              style: TextStyle(
                color: Color(0xFF188ECE),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Relationship Dropdown
            Row(
              children: const [
                Text(
                  'Relationship ',
                  style: TextStyle(
                    color: Color(0xFF188ECE),
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
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: viewModel.relationship.isEmpty
                  ? null
                  : viewModel.relationship,
              decoration: InputDecoration(
                hintText: 'Select',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: viewModel.relationships.map((String relationship) {
                return DropdownMenuItem<String>(
                  value: relationship,
                  child: Text(relationship),
                );
              }).toList(),
              onChanged: viewModel.updateRelationship,
            ),
            const SizedBox(height: 16),

            // Name Fields
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Text(
                            'First name ',
                            style: TextStyle(
                              color: Color(0xFF188ECE),
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
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: viewModel.updateContactFirstName,
                        decoration: InputDecoration(
                          hintText: 'Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Text(
                            'Last name ',
                            style: TextStyle(
                              color: Color(0xFF188ECE),
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
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: viewModel.updateContactLastName,
                        decoration: InputDecoration(
                          hintText: 'Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Phone Number
            Row(
              children: const [
                Text(
                  'Phone number ',
                  style: TextStyle(
                    color: Color(0xFF188ECE),
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
            const SizedBox(height: 8),

            TextField(
              controller: viewModel.phoneController,
              onChanged: (value) {
                final formattedNumber = viewModel.formatPhoneNumber(value);
                if (value != formattedNumber) {
                  viewModel.phoneController.value = TextEditingValue(
                    text: formattedNumber,
                    selection:
                        TextSelection.collapsed(offset: formattedNumber.length),
                  );
                }
                viewModel.updateContactPhone(formattedNumber);
              },
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d-]')),
                LengthLimitingTextInputFormatter(12), // 10 digits + 2 dashes
              ],
              decoration: InputDecoration(
                hintText: 'XXX-XXX-XXXX',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 30),
            //Add Button
            Center(
              child: ElevatedButton(
                onPressed: viewModel.isContactFormValid
                    ? viewModel.saveEmergencyContact
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
