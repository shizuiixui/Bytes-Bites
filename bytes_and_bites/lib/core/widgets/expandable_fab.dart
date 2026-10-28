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
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _expandAnimation = CurvedAnimation(
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeIn,
      parent: _controller,
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
    return SizedBox(
      width: 250,
      height: 250,
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          // Dismiss tap detector when open
          if (_isOpen)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _toggleOpen,
                child: const SizedBox.expand(),
              ),
            ),

          // Inventory
          _buildExpandingAction(
            label: "Inventory",
            bottomOffset: 180, // Highest up
            icon: Image.asset(
              'assets/images/bottom_nav_bar/fab_inventory.png',
              width: 20,
              height: 20,
              color: const Color(0xFFB0DB9C),
            ),
            onPressed: () => Navigator.pushNamed(context, 'add_inventory'),
          ),

          // Subscriptions
          _buildExpandingAction(
            label: "Subscriptions",
            bottomOffset: 120,
            icon: const Icon(Icons.event_repeat, color: Color(0xFFB0DB9C)),
            onPressed: () => Navigator.pushNamed(context, 'add_subscription'),
          ),

          // Expenses
          _buildExpandingAction(
            label: "Transactions",
            bottomOffset: 60,
            icon: Image.asset(
              'assets/images/bottom_nav_bar/fab_transactions.png',
              width: 20,
              height: 20,
              color: const Color(0xFFB0DB9C),
            ),
            onPressed: () => Navigator.pushNamed(context, 'add_expense'),
          ),

          // Main Bottom FAB
          FloatingActionButton(
            backgroundColor: const Color(0xFFB0DB9C),
            shape: const CircleBorder(
              side: BorderSide(color: Colors.white, width: 1.5),
            ),
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
      ),
    );
  }

  Widget _buildExpandingAction({
    required String label,
    required double bottomOffset,
    required Widget icon,
    required VoidCallback onPressed,
  }) {
    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        return Positioned(
          right: 4,
          bottom: 4,
          child: Transform.translate(
            offset: Offset(0, -bottomOffset * _expandAnimation.value),
            child: Transform.scale(
              scale: _expandAnimation.value,
              child: Opacity(opacity: _expandAnimation.value.clamp(0.0, 1.0),
               child: child),
            ),
          ),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text Label Pill Badge
          GestureDetector(
            onTap: () {
              _controller.reverse();
              setState(() => _isOpen = false);
              onPressed();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Colors.black.withOpacity(0.05),
                  width: 1,
                ),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Mini FAB
          FloatingActionButton.small(
            heroTag: null,
            backgroundColor: Colors.white,
            elevation: 3,
            onPressed: () {
              _controller.reverse();
              setState(() => _isOpen = false);
              onPressed();
            },
            child: icon,
          ),
        ],
      ),
    );
  }
}
