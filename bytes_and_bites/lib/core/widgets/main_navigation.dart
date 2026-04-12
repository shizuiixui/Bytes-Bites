import 'package:bytes_and_bites/core/widgets/expandable_fab.dart';
import 'package:flutter/material.dart';

import 'package:bytes_and_bites/core/widgets/bottom_nav_bar.dart';
import 'package:bytes_and_bites/features/home/screens/homepage.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomePage(
            onProfileTap: () {
              setState(() {
                _selectedIndex = 3;
              });
            },
          ),

          // Index 1 : Transaction Page
          const Center(
            child: Text("Transaction Page", style: TextStyle(fontSize: 24)),
          ),
          // Index 2 : Inventory Page
          const Center(
            child: Text("Inventory Page", style: TextStyle(fontSize: 24)),
          ),
          // Index 3 : Profile Page
          const Center(
            child: Text("Profile Page", style: TextStyle(fontSize: 24)),
          ),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),

      // Floating Action Button
      floatingActionButton: const ExpandableFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
