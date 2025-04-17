import 'package:flutter/material.dart';
import '../Views/Match_Me_Screen.dart';
import '../Views/My_Trips_Home_Screen.dart';

class TopNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const TopNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF8BC34A),
      ),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Row(
          children: [
            _buildNavItem(context, 'MATCH ME', 0),
            _buildNavItem(context, 'MY TRIPS', 1),
            _buildNavItem(context, 'FIND FRIENDS', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context,String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {

          onTap?.call(index);

          _navigateToScreen(context, index);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: selectedIndex == index ? Colors.blue : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 3,
                width: 60,
                color: selectedIndex == index ? Colors.blue : Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MatchMeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MyTripsHomeScreen()),
        );
        break;
      case 2:
        //TODO: Set-Up Find Friends Page
        break;
    }
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();