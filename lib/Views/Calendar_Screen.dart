//import package
import 'package:flutter/material.dart';
//Views
import '../Views/Match_Me_Screen.dart';
import '../Views/profile_screen_setup.dart';
import '../Views/Create_New_Trip_Screen.dart';
import '../Views/My_Trips_Home_Screen.dart';

/// A stateful widget that displays a custom calendar interface for trip date selection.
///
/// This widget allows users to select multiple dates to define their trip duration.
/// It provides month/year navigation and displays selected dates with visual indicators.
class CalendarScreen extends StatefulWidget {
  // Optional callback that receives the list of selected dates when selection is complete
  final Function(List<DateTime>)? onDateSelectionComplete;
  final List<DateTime>? initialSelectedDates;

  const CalendarScreen({
    Key? key,
    this.onDateSelectionComplete,
    this.initialSelectedDates,
  }) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
  }

class _CalendarScreenState extends State<CalendarScreen> {
  // Current viewing month and year
  DateTime _currentMonth = DateTime.now();
  // Selected dates
  late List<DateTime> _selectedDates;
  // Year options - dynamically generated
  List<int> _yearOptions = [];
  int _selectedYear = DateTime.now().year;


  // This can be populated from backend or other sources
  List<DateTime> _highlightedDates = [];

  @override
  void initState() {
    super.initState();

    // Initialize selected dates with provided dates or empty list
    _selectedDates = widget.initialSelectedDates ?? [];
    // Generate year options: current year and 2 years forward
    final currentYear = DateTime.now().year;
    _yearOptions = [currentYear - 1, currentYear, currentYear + 1];
    _selectedYear = currentYear;
    // Set the current month to the current year and month
    _currentMonth = DateTime(currentYear, DateTime.now().month);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App bar with go together logo and help icon
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFF8BC34A),
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Image.asset(
                    'Assets/go_together_logo.png',
                    height: 20,
                  ),

                  // TODO: implement the functionality of this button
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFF8BC34A)),
                    ),
                    child: Center(
                      child: Text(
                        '?',
                        style: TextStyle(
                          color: Color(0xFF8BC34A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Back button navigation
            // currently takes user to the My trips page match me section
            Container(
              padding: const EdgeInsets.only(left: 16, top: 12, bottom: 4),
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_ios, size: 18, color: Color(0xFF8BC34A)),
                    Text(
                      'BACK',
                      style: TextStyle(
                        color: Color(0xFF8BC34A),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //Select Duration of Trip
            Container(
              padding: const EdgeInsets.only(bottom: 12),
              alignment: Alignment.center,
              child: Text(
                'Select Duration of Trip',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Year Selection
            //Note: Get the previous year plus next year of current year
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _yearOptions.map((year) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedYear = year;
                        _currentMonth = DateTime(year, _currentMonth.month);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedYear == year ? Color(0xFF8BC34A) : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        year.toString(),
                        style: TextStyle(
                          color: _selectedYear == year ? Color(0xFF8BC34A) : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Month Navigation
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentMonth = DateTime(
                          _currentMonth.year,
                          _currentMonth.month - 1,
                        );
                        if (_currentMonth.month == 12) {
                          _selectedYear = _currentMonth.year;
                        }
                      });
                    },
                    child: Icon(Icons.chevron_left, color: Color(0xFF8BC34A), size: 30),
                  ),
                  Text(
                    _getMonthName(_currentMonth.month).toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentMonth = DateTime(
                          _currentMonth.year,
                          _currentMonth.month + 1,
                        );
                        if (_currentMonth.month == 1) {
                          _selectedYear = _currentMonth.year;
                        }
                      });
                    },
                    child: Icon(Icons.chevron_right, color: Color(0xFF8BC34A), size: 30),
                  ),
                ],
              ),
            ),

            // Calendar Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDayLabel('Mo'),
                  _buildDayLabel('Tu'),
                  _buildDayLabel('We'),
                  _buildDayLabel('Th'),
                  _buildDayLabel('Fr'),
                  _buildDayLabel('Sa'),
                  _buildDayLabel('Su'),
                ],
              ),
            ),

            // Calendar Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildCalendarGrid(),
              ),
            ),

            // Next Button
            // can only be pressed when the user has selected two dates
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: _selectedDates.isNotEmpty
                    ? () {
                  // Update the global date selection manager
                  DateSelectionManager().updateDates(_selectedDates);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MatchMeScreen(
                        initialSelectedDates: _selectedDates,
                      ),
                      maintainState: true,
                    ),
                  );
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8BC34A),
                  minimumSize: Size(175, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            /// Bottom Navigation Bar for app-wide navigation
            BottomNavigationBar(
              currentIndex: 1,
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


          ],

        ),
      ),
    );
  }

  /// Widgets
  Widget _buildDayLabel(String day) {
    return SizedBox(
      width: 32,
      child: Text(
        day,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.grey.shade700,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Get month name without using DateFormat
  String _getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }

  /// Builds and returns the interactive calendar grid widget
  ///
  /// This method constructs the main calendar UI component that displays the days of the month
  /// in a grid format and handles date selection interactions. The grid automatically adjusts
  /// to show the correct days for the current month and year being viewed.
  Widget _buildCalendarGrid() {
    // Calculate the total number of days in the current month
    // We do this by creating a DateTime for the first day of the next month
    // and then going back one day (setting day to 0)
    final daysInMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    ).day;
    // Determine the first day of the current month
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    // Get the weekday of the first day (1=Monday, 2=Tuesday, ..., 7=Sunday)
    // This tells us which column the first day should appear in
    final firstWeekdayOfMonth = firstDayOfMonth.weekday; // 1 for Monday, 7 for Sunday

    // Calculate total cells needed (previous month days + current month days)
    // We need empty cells for any days from the previous month (firstWeekdayOfMonth - 1)
    // plus all the days in the current month
    final totalCells = ((firstWeekdayOfMonth - 1) + daysInMonth);
    final totalRows = (totalCells / 7).ceil();

    // Create a scrollable grid with 7 columns (for 7 days of the week)
    return GridView.builder(
      // Ensure the grid only takes the space it needs
      shrinkWrap: true,
      // Disable scrolling since we want the grid to be part of the page layout
      physics: NeverScrollableScrollPhysics(),
      // Configure the grid layout with 7 columns of equal width/height
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: totalRows * 7,
      // Builder function to create each individual day cell
      itemBuilder: (context, index) {
        // Calculate the adjusted index to account for empty cells at beginning of month
        // We subtract (firstWeekdayOfMonth - 1) to account for empty cells from previous month
        final adjustedIndex = index - (firstWeekdayOfMonth - 1);

        // This creates an empty cell for days outside current month
        if (adjustedIndex < 0 || adjustedIndex >= daysInMonth) {
          // Empty cell (previous or next month)
          return Container();
        }

        final dayNumber = adjustedIndex + 1;
        // Create a DateTime object for this specific day
        final currentDate = DateTime(_currentMonth.year, _currentMonth.month, dayNumber);

        // Check if this date is in the user's selected dates list
        // We use .any() to check if any of the dates in _selectedDates matches currentDate
        // Comparing year, month, and day individually to ensure correct date matching
        final isSelected = _selectedDates.any((date) =>
        date.year == currentDate.year &&
            date.month == currentDate.month &&
            date.day == currentDate.day);

        final isToday = DateTime.now().year == currentDate.year &&
            DateTime.now().month == currentDate.month &&
            DateTime.now().day == currentDate.day;


        // Check if this date should be highlighted for any special reason
        // This can be used for marking dates with events or other significance
        // TODO: There should be other highlighted dates based on other trips or events set by the user
        // ------ Look in the figma for further details
        final isHighlighted = _highlightedDates.any((date) =>
        date.year == currentDate.year &&
            date.month == currentDate.month &&
            date.day == currentDate.day);
        // Create the interactive day cell with visual feedback for selection
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                // If this date is already selected, remove it and re-sort the remaining dates
                _selectedDates.removeWhere((date) =>
                date.year == currentDate.year &&
                    date.month == currentDate.month &&
                    date.day == currentDate.day);

                // After removal, ensure dates are sorted chronologically
                if (_selectedDates.length > 1) {
                  _selectedDates.sort((a, b) => a.compareTo(b));
                }
              } else {
                // If this date is not already selected
                if (_selectedDates.length == 0) {
                  // No dates selected yet, add this as the first one
                  _selectedDates.add(currentDate);
                } else if (_selectedDates.length == 1) {
                  // One date already selected, add this as the second one and sort
                  _selectedDates.add(currentDate);
                  _selectedDates.sort((a, b) => a.compareTo(b));
                } else if (_selectedDates.length >= 2) {
                  // Two dates already selected:
                  // Clear the existing selection and start over with this date
                  _selectedDates.clear();
                  _selectedDates.add(currentDate);
                }
              }
            });
          },
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isHighlighted ? Color(0xFF8BC34A) : Colors.transparent,
                width: 2,
              ),
              color: isSelected ? Color(0xFF8BC34A) : Colors.transparent,
            ),
            child: Center(
              child: Text(
                dayNumber.toString(),
                style: TextStyle(
                  // Add contrasting text color for better visibility when selected
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
/// helper methods
void _handleNavTap(BuildContext context, int index) {
  switch (index) {
    case 0:
    // TODO: Navigate to Home
      break;
    case 1:

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
