import 'package:bytes_and_bites/core/widgets/expandable_fab.dart';
import 'package:bytes_and_bites/features/inventory/screens/inventory_page.dart';
import 'package:bytes_and_bites/features/profile/screens/profile_page.dart';
import 'package:bytes_and_bites/features/transactions/screens/expense_page.dart';
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
  bool _isFabOpen = false;
  final GlobalKey<ExpandableFabState> _fabKey = GlobalKey<ExpandableFabState>();

  void _onItemTapped(int index) {
    if (_isFabOpen) {
      _fabKey.currentState?.close();
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: [
              HomePage(
                onProfileTap: () => _onItemTapped(3),
                onTransactionsTap: () => _onItemTapped(1),
                onInventoryTap: () => _onItemTapped(2),
              ),

              // Index 1 : Transaction Page
              const ExpensePage(),

              // Index 2 : Inventory Page
              const InventoryPage(),

              // Index 3 : Profile Page
              const ProfilePage(),
            ],
          ),

          // Gentle scrim that closes the FAB when tapping anywhere outside
          if (_isFabOpen)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _fabKey.currentState?.close();
                },
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
            ),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),

      // Floating Action Button
      floatingActionButton: ExpandableFab(
        key: _fabKey,
        onOpenChanged: (isOpen) {
          setState(() {
            _isFabOpen = isOpen;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
