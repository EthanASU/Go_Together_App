import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, bool> checkBoxValues = {
    'Carpooling': false,
    'Walking': false,
    'Biking': false,
    'A student who needs a ride': false,
    'Someone to drive my student': false,
  };

  String? selectedDistance;
  String? selectedStartingPoint;
  String? selectedDestination;

  final List<String> distances = ['1 mile', '5 miles', '10 miles', '20 miles'];
  final List<String> locations = ['School', 'Library', 'Mall', 'Park'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('MATCH ME',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            Text('MY TRIPS',
                style: TextStyle(color: Colors.black, fontSize: 16)),
            Text('FIND FRIENDS',
                style: TextStyle(color: Colors.black, fontSize: 16)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back_ios, size: 16),
                Text(' APRIL 5TH - 11TH ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Icon(Icons.calendar_today, size: 16),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text('AI Matching'),
                ),
                SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () {},
                  child: Text('Manual Search'),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildOutlinedSection(
              child: Column(
                children: [
                  _buildSectionTitle(
                      'I’m interested in', 'Select all that apply'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: checkBoxValues.keys
                        .take(3)
                        .map((label) => Expanded(child: _buildCheckbox(label)))
                        .toList(),
                  ),
                  _buildSectionTitle(
                      'I’m looking for', 'Select all that apply'),
                  Column(
                    children: checkBoxValues.keys
                        .skip(3)
                        .map((label) => _buildCheckbox(label))
                        .toList(),
                  ),
                  _buildDropdown(
                      'Find match within',
                      'Select a Distance',
                      distances,
                      selectedDistance,
                      (value) => setState(() => selectedDistance = value)),
                  _buildDropdown(
                      'Starting Point',
                      'Select a Location',
                      locations,
                      selectedStartingPoint,
                      (value) => setState(() => selectedStartingPoint = value)),
                  _buildDropdown(
                      'Destination',
                      'Select a Location',
                      locations,
                      selectedDestination,
                      (value) => setState(() => selectedDestination = value)),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Search', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Calendar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle, color: Colors.orange),
              label: 'My Trip'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.black,
      ),
    );
  }

  Widget _buildOutlinedSection({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(subtitle, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildCheckbox(String label) {
    return Row(
      children: [
        Theme(
          data: ThemeData(
            unselectedWidgetColor: Colors.green,
          ),
          child: Checkbox(
            value: checkBoxValues[label],
            activeColor: Colors.green,
            checkColor: Colors.white,
            side: BorderSide(color: Colors.green, width: 2),
            onChanged: (value) {
              setState(() {
                checkBoxValues[label] = value!;
              });
            },
          ),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildDropdown(String title, String hint, List<String> items,
      String? selectedItem, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
            ),
            value: selectedItem,
            hint: Text(hint),
            items: items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
