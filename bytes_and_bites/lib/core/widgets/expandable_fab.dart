import 'package:flutter/material.dart';

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({super.key});

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  void _toggleOpen() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (_isOpen) ...[
          // Transactions Button
          _buildMiniFab(
            customIcon: Image.asset(
              'assets/images/bottom_nav_bar/fab_transactions.png',
              width: 20,
              height: 20,
              color: const Color(
                0xFFB0DB9C,
              ),
            ),
            label: 'Transactions',
            onPressed: () {
              // Add navigation here
            },
          ),
          const SizedBox(height: 12),

          // Subscription Button
          _buildMiniFab(
            customIcon: const Icon(
              Icons.event_repeat,
              color: Color(0xFFB0DB9C),
            ),
            label: 'Subscription',
            onPressed: () {
              // Add navigation here
            },
          ),
          const SizedBox(height: 12),

          //  Inventory Button
          _buildMiniFab(
            customIcon: Image.asset(
              'assets/images/bottom_nav_bar/fab_inventory.png',
              width: 20,
              height: 20,
              color: const Color(0xFFB0DB9C),
            ),
            label: 'Inventory',
            onPressed: () {
              // Add navigation here
            },
          ),
          const SizedBox(height: 12),
        ],

        // FAB
        FloatingActionButton(
          backgroundColor: const Color(0xFFB0DB9C),
          shape: const CircleBorder(),
          elevation: 4,
          onPressed: _toggleOpen,
          child: AnimatedRotation(
            turns: _isOpen ? 0.125 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: Image.asset(
              'assets/images/bottom_nav_bar/fab.png',
              width: 24,
              height: 24,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // Helper
  Widget _buildMiniFab({
    required Widget customIcon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        // The Mini Button
        FloatingActionButton.small(
          heroTag: label,
          backgroundColor: Colors.white,
          onPressed: () {
            _toggleOpen();
            onPressed();
          },
          child: customIcon,
        ),
      ],
    );
  }
}
