//import packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//Views
import '../Views/Calendar_Screen.dart';
import '../Views/Profile_Screen_Setup.dart';
import '../Views/My_Trips_Home_Screen.dart';
//ViewModel
import '../ViewModels/Profile_Personal_View_Model.dart';
//Widget
import '../Widgets/My_Trips_Top_Navigation_Bar.dart';

// Class to represent a Trip entity with all necessary information
class Trip {
  final String pickupTime;
  final String pickupLocation;
  final String dropOffTime;
  final String dropOffDestination;
  final List<bool> frequency;
  final List<DateTime> dates;
  final List<String> transportationModes;
  Trip({
    required this.pickupTime,
    required this.pickupLocation,
    this.dropOffTime = '',
    this.dropOffDestination = '',
    required this.frequency,
    required this.dates,
    this.transportationModes = const []
  });
}

// Singleton class to manage date selection across different screens
class DateSelectionManager {
  static final DateSelectionManager _instance = DateSelectionManager._internal();

  factory DateSelectionManager() {
    return _instance;
  }
  // Private constructor for singleton pattern
  DateSelectionManager._internal();
  // State for selected dates
  List<DateTime> _selectedDates = [];

  // Getter for selected dates
  List<DateTime> get selectedDates => _selectedDates;

  // Method to update selected dates
  void updateDates(List<DateTime> dates) {
    _selectedDates = dates;
  }
}
// Main StatefulWidget for the MatchMe screen
class MatchMeScreen extends StatefulWidget {
  final List<DateTime>? initialSelectedDates;
  const MatchMeScreen({
    Key? key,
    this.initialSelectedDates
  }) : super(key: key);

  @override
  _MatchMeScreenState createState() => _MatchMeScreenState();
}

class _MatchMeScreenState extends State<MatchMeScreen> {
  // Tab controller
  int _selectedTabIndex = 0;
  final List<String> _tabTitles = ['MATCH ME', 'MY TRIPS', 'FIND FRIENDS'];

  // Matching mode
  bool _isAIMatching = false;

  // Date range
  String _dateRange = 'SELECT DATES';
  List<DateTime> _selectedDates = [];

  List<Trip> _submittedTrips = [];

  void _saveCurrentTrip() {
    // Create a new trip with current form values
    final viewModel = context.read<ProfilePersonalSetUpViewModel>();
    final newTrip = Trip(
      pickupTime: _pickupTime ?? '',
      pickupLocation: _pickupLocationController.text,
      dropOffTime: _dropOffTime ?? '',
      dropOffDestination: _dropOffLocationController.text,
      frequency: List.from(_selectedDays),
      dates: List.from(_selectedDates),
      transportationModes: List.from(viewModel.transportationModes),
    );


    setState(() {
      _submittedTrips.add(newTrip);
    });
  }
  String _formatSelectedDateRange(List<DateTime> dates) {
    if (dates.isEmpty) {
      return "No dates selected";
    }

    // Sort dates to find earliest and latest
    dates.sort((a, b) => a.compareTo(b));
    DateTime firstDate = dates.first;
    DateTime lastDate = dates.last;

    // Format the dates with proper ordinal suffixes (1ST, 2ND, 3RD, 4TH, etc.)
    String formatDay(DateTime date) {
      String day = date.day.toString();
      String suffix;

      if (day.endsWith('1') && day != '11') {
        suffix = 'ST';
      } else if (day.endsWith('2') && day != '12') {
        suffix = 'ND';
      } else if (day.endsWith('3') && day != '13') {
        suffix = 'RD';
      } else {
        suffix = 'TH';
      }
      return "$day$suffix";
    }
    // Get month names
    List<String> months = [
      'JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE',
      'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER'
    ];

    // Format as "MONTH DAY - DAY" if in same month, otherwise "MONTH DAY - MONTH DAY"
    if (firstDate.month == lastDate.month && firstDate.year == lastDate.year) {
      return "${months[firstDate.month - 1]} ${formatDay(firstDate)} - ${formatDay(lastDate)}";
    } else {
      return "${months[firstDate.month - 1]} ${formatDay(firstDate)} - ${months[lastDate.month - 1]} ${formatDay(lastDate)}";
    }
  }

  @override
  void initState() {
    super.initState();

    // First, check if dates were passed directly to the constructor
    _selectedDates = widget.initialSelectedDates ?? [];

    // If no dates were passed, check the global manager
    if (_selectedDates.isEmpty) {
      _selectedDates = DateSelectionManager().selectedDates;
    }
    // Update date range if dates exist
    if (_selectedDates.isNotEmpty) {
      _dateRange = _formatDateRange(_selectedDates);
    }


  }

  // Helper method to format date range
  String _formatDateRange(List<DateTime> dates) {
    if (dates.isEmpty) return 'SELECT DATES';

    dates.sort((a, b) => a.compareTo(b));

    final first = dates.first;
    final last = dates.last;

    return '${_getMonthName(first.month).toUpperCase()} ${first.day} - ${_getMonthName(last.month).toUpperCase()} ${last.day}';
  }
  String _getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }
  String? _pickupTime;
  String? _dropOffTime;

  final TextEditingController _pickupLocationController = TextEditingController();
  final TextEditingController _dropOffLocationController = TextEditingController();

  final List<String> _days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
  final List<bool> _selectedDays = [false, false, false, false, false, false, false];

  bool _showSubmissionConfirmation = false;

  // Generate time options between 6 AM and 10 PM
  List<String> _generateTimeOptions() {
    List<String> times = [];
    for (int hour = 6; hour <= 22; hour++) {
      final int displayHour = hour > 12 ? hour - 12 : hour;
      final String amPm = hour >= 12 ? 'PM' : 'AM';
      times.add('$displayHour:00 $amPm');
      times.add('$displayHour:15 $amPm');
      times.add('$displayHour:30 $amPm');
      times.add('$displayHour:45 $amPm');
    }
    return times;
  }
  void _navigateToCalendar() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarScreen(
          initialSelectedDates: _selectedDates, // Pass current selected dates
          onDateSelectionComplete: (selectedDates) {
            setState(() {
              _selectedDates = selectedDates;
              _dateRange = _formatDateRange(selectedDates);
            });
          },
        ),
      ),
    );
  }
  @override
  void dispose() {
    _pickupLocationController.dispose();
    _dropOffLocationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfilePersonalSetUpViewModel>();
  final List<String> timeOptions = _generateTimeOptions();

    return Scaffold(
        body: SafeArea(
        child: Column(
        children: [
        // Use the new TopNavigationBar widget
        TopNavigationBar(
        selectedIndex: _selectedTabIndex,
        onTap: (index) {
      setState(() {
        _selectedTabIndex = index;
      });
    },
    ),

          Expanded(
            child: Stack(
            children: [ SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_submittedTrips.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF8BC34A)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            ..._submittedTrips.map((trip) {
                              // Get days of the week that are selected
                              List<String> selectedDays = [];
                              for (int i = 0; i < trip.frequency.length; i++) {
                                if (trip.frequency[i]) {
                                  selectedDays.add(_days[i]);
                                }
                              }

                              return Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey.shade300),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _formatSelectedDateRange(trip.dates),
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        Text('Pick Up: ${trip.pickupTime}'),
                                        const SizedBox(width: 10),
                                        if (trip.dropOffTime.isNotEmpty)
                                          Text('Drop Off: ${trip.dropOffTime}'),
                                      ],
                                    ),

                                    if (trip.dropOffDestination.isNotEmpty)
                                      Text('To: ${trip.dropOffDestination}'),
                                    Text('Days: ${selectedDays.join(", ")}'),

                                    if (trip.transportationModes.isNotEmpty)
                                      Row(
                                        children: [
                                          Text('Transport: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text(trip.transportationModes.join(", ")),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    // AI/Manual Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //AI/Manual toggle
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isAIMatching = true;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: _isAIMatching ? const Color(0xFF8BC34A) : Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                    border: Border.all(color: const Color(0xFF8BC34A)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'AI Matching',
                                      style: TextStyle(
                                        color: _isAIMatching ? Colors.white : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isAIMatching = false;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: !_isAIMatching ? const Color(0xFF8BC34A) : Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    border: Border.all(color: const Color(0xFF8BC34A)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Manual Search',
                                      style: TextStyle(
                                        color: !_isAIMatching ? Colors.white : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                    // Date Selection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'THE WEEK OF',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.arrow_back_ios, size: 14),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CalendarScreen(
                                        initialSelectedDates: _selectedDates, // Pass current selected dates
                                        onDateSelectionComplete: (selectedDates) {
                                          setState(() {
                                            _selectedDates = selectedDates;
                                            _dateRange = _formatDateRange(selectedDates);
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  _dateRange,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 14),
                              GestureDetector(
                                onTap: () {
                                  // Navigate to CalendarScreen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CalendarScreen(
                                        initialSelectedDates: _selectedDates,
                                        onDateSelectionComplete: (selectedDates) {
                                          setState(() {
                                            _selectedDates = selectedDates;
                                            _dateRange = _formatDateRange(selectedDates);
                                          });
                                        },
                                      ),
                                      maintainState: true,
                                    ),
                                  );
                                },
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    Colors.blue,
                                    BlendMode.srcIn,
                                  ),
                                  child: Image.asset(
                                    'Assets/Tab_Bar_Calendar_Icon.png',
                                    width: 16,
                                    height: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Pick Up Time and Location
                    const Text(
                      'Pick Up Time',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _pickupTime,
                          hint: Text('Select a time'),
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                          onChanged: (String? newValue) {
                            setState(() {
                              _pickupTime = newValue;
                            });
                          },
                          items: timeOptions.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  Row(
                    children: [
                      Image.asset(
                        'Assets/matchme_location.png',
                        width: 25,
                        height: 25,
                      ),

                      Text(
                        'Pick Up Location',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: _pickupLocationController,
                    decoration: InputDecoration(
                      hintText: 'Type Location Here',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Drop Off Time and Location
                  const Text(
                    'Drop Off Time',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _dropOffTime,
                        hint: Text('Select a Time'),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                        onChanged: (String? newValue) {
                          setState(() {
                            _dropOffTime = newValue;
                          });
                        },
                        items: timeOptions.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'Assets/matchme_location.png',
                        width: 25,
                        height: 25,
                      ),
                      Text(
                        'Drop Off Destination',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  TextField(
                    controller: _dropOffLocationController,
                    decoration: InputDecoration(
                      hintText: 'Type Location Here',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                    // Frequency Selection
                      Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Frequency',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            _days.length,
                                (index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedDays[index] = !_selectedDays[index];
                                });
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFF8BC34A)),
                                  color: _selectedDays[index] ? const Color(0xFF8BC34A) : Colors.white,
                                ),
                                child: Center(
                                  child: Text(
                                    _days[index],
                                    style: TextStyle(
                                      color: _selectedDays[index] ? Colors.white : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
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
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Submit Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                              _saveCurrentTrip();

                              setState(() {
                                _showSubmissionConfirmation = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8BC34A),
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),

                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),


          if (_showSubmissionConfirmation)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    width: 300,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Trip Availability Submitted',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        // Done Button
                        ElevatedButton(
                          onPressed: () {
                            // Hide confirmation dialog
                            setState(() {
                              _showSubmissionConfirmation = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8BC34A),
                            minimumSize: const Size(double.infinity, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Done',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Add Another Trip Button
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showSubmissionConfirmation = false;
                              // Reset form fields for a new trip
                              _pickupTime = null;
                              _dropOffTime = null;
                              _pickupLocationController.clear();
                              _dropOffLocationController.clear();
                              // Optionally reset other fields
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFA500), // Orange color
                            minimumSize: const Size(double.infinity, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Add Another Trip',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],

                    ),
                  ),
                ),
              ),
            ),
              ],
            ),
    ),
    ],
    ),
    ),
      // Bottom Navigation Bar
      bottomNavigationBar:BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) => _handleNavTap(context, index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('Assets/Tab_Bar_Home_Icon.png'),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('Assets/Tab_Bar_Calendar_Icon.png'),
            ),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('Assets/Tab_Bar_Add_Icon.png'),
            ),
            label: 'My Trip',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('Assets/Tab_Bar_Chat_Icon.png'),
            ),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

void _handleNavTap(BuildContext context, int index) {
  switch (index) {
    case 0:
    // TODO: Navigate to Home
      break;
    case 1:
    // TODO: Navigate to Calendar
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CalendarScreen()),
      );
      break;
    case 2:
    // Already on My Trips – do nothing
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyTripsHomeScreen()),
      );
      break;
    case 3:
    // TODO: Navigate to Chat
      break;
    case 4:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfileSetUp()),
      );
      break;
  }
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
        color: isSelected ? Color(0xFF188ECE) : Colors.transparent,  // Blue background when selected
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
              isSelected ? Colors.white : Colors.black,  // White icon when selected
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
