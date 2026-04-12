import 'package:flutter/material.dart';
import 'dart:math' as math;

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
    return Padding(
      padding: const EdgeInsets.only(bottom: 45),
      child: SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // Transactions
            _buildExpandingAction(
              angle: math.pi / 4 * 3,
              distance: 80,
              icon: Image.asset(
                'assets/images/bottom_nav_bar/fab_transactions.png',
                width: 20,
                height: 20,
                color: const Color(0xFFB0DB9C),
              ),
              onPressed: () {},
            ),

            // Subscriptions
            _buildExpandingAction(
              angle: math.pi / 2,
              distance: 80,
              icon: const Icon(Icons.event_repeat, color: Color(0xFFB0DB9C)),
              onPressed: () {},
            ),

            // Inventory
            _buildExpandingAction(
              angle: math.pi / 4,
              distance: 80,
              icon: Image.asset(
                'assets/images/bottom_nav_bar/fab_inventory.png',
                width: 20,
                height: 20,
                color: const Color(0xFFB0DB9C),
              ),
              onPressed: () {},
            ),

            // Main Bottom FAB
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: _isOpen
                      ? [
                          BoxShadow(
                            color: const Color(0xFFB0DB9C).withOpacity(0.8),
                            blurRadius: 15,
                            spreadRadius: 0.3,
                            offset: const Offset(0, -3),
                          ),
                        ]
                      : [],
                ),
                child: FloatingActionButton(
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandingAction({
    required double angle,
    required double distance,
    required Widget icon,
    required VoidCallback onPressed,
  }) {
    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        final offset = Offset(
          distance * math.cos(angle),
          -distance * math.sin(angle),
        );
        return Positioned(
          bottom: 0,
          child: Transform.translate(
            offset: offset * _expandAnimation.value,
            child: Transform.scale(scale: _expandAnimation.value, child: child),
          ),
        );
      },
      child: FloatingActionButton.small(
        heroTag: null,
        backgroundColor: Colors.white,
        onPressed: () {
          _toggleOpen();
          onPressed();
        },
        child: icon,
      ),
    );
  }
}
