import 'package:flutter/material.dart';

class AddressCard extends StatelessWidget {
  final Map<String, dynamic> address;
  final VoidCallback onEdit;

  const AddressCard({
    required this.address,
    required this.onEdit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address['name'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    '${address['streetAddress']}, ${address['aptSuite']}'.trim(),
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  Text(
                    '${address['city']}, ${address['state']} ${address['zipCode']}',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  if (address['isDefault'])
                    Text(
                      'Default Address',
                      style: TextStyle(
                        color: Color(0xFF8BC541),
                        fontFamily: 'Poppins',
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: onEdit,
            ),
          ],
        ),
      ),
    );
  }
}
