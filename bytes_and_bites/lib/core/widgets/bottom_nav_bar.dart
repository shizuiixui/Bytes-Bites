import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color(0xFFB0DB9C),
      unselectedItemColor: Color(0xFFB0B0B0),
      selectedLabelStyle: TextStyle(
        fontSize: 12,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
      ),
      items: [
        // Home
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/bottom_nav_bar/home.png',
            width: 24,
            height: 24,
          ),
          activeIcon: Image.asset(
            'assets/images/bottom_navbar/active_home.png',
            width: 24,
            height: 24,
          ),
        ),

        // Transactions
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/bottom_nav_bar/transactions.png',
            width: 24,
            height: 24,
          ),
          activeIcon: Image.asset(
            'assets/images/bottom_nav_bar/active_transactions/png',
          ),
        ),

        // Inventory
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/bottom_nav_bar/inventory.png',
            width: 24,
            height: 24,
          ),
          activeIcon: Image.asset(
            'assets/images/bottom_nav_bar/active_inventory.png',
            width: 24,
            height: 24,
          ),
        ),

        // Profile
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/bottom_nav_bar/profile.png',
            width: 24,
            height: 24,
          ),
          activeIcon: Image.asset(
            'assets/images/bottom_nav_bar/active_profile.png',
            width: 24,
            height: 24,
          ),
        ),
      ],
    );
  }
}
