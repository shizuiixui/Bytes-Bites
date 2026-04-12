import 'package:bytes_and_bites/core/widgets/background_card.dart';
import 'package:bytes_and_bites/core/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';

import 'package:bytes_and_bites/core/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onProfileTap;
  final DateTime currentDate;
  final VoidCallback onCalendarTap;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.onProfileTap,
    required this.currentDate, 
    required this.onCalendarTap,
  });

  String _formatDate() {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return "${months[currentDate.month - 1]} ${currentDate.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ProfileAvatar(typedName: userName, onProfileTap: onProfileTap),

          // Calendar View
          GestureDetector(
            onTap: onCalendarTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_month_rounded,
                  size: 18,
                  color: Colors.black87,
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDate(),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: Colors.black87,
                ),
              ],
            ),
          ),

          // Notification Icon
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const Icon(Icons.notifications_outlined, size: 25),
          ),
        ],
      ),
    );
  }
}

// Total Spent
class TotalSpent extends StatefulWidget {
  const TotalSpent({super.key});

  @override
  State<TotalSpent> createState() => _TotalSpentState();
}

class _TotalSpentState extends State<TotalSpent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        height: 110,
        decoration: BoxDecoration(
          color: const Color(0xFFB0DB9C),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Total Spent This Month",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "\u20B1 1,250.00",
                style: TextStyle(
                  fontSize: 35,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Carousel
class HomeCarousel extends StatefulWidget {
  const HomeCarousel({super.key});

  @override
  State<HomeCarousel> createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<HomeCarousel> {
  double _currentPage = 0;
  final PageController _pageController = PageController(viewportFraction: 0.85);

  @override
  void initState() {
    _pageController.addListener(() {
      if (mounted) {
        setState(() {
          _currentPage = _pageController.page!;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleCarouselTap(int index) {
    switch (index) {
      case 0:
        // Navigate to Subscriptions
        break;
      case 1:
        // Navigate to Subscriptions
        break;
      case 2:
        // Navigate to Subscriptions
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Text(
            "Upcoming Subscriptions",
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: _pageController,
            itemCount: 3,
            itemBuilder: (context, index) {
              double relativePosition = index - _currentPage;
              [index];

              return Transform(
                transform: Matrix4.identity()
                  ..translate(relativePosition * -20.0)
                  ..scale(1 - (relativePosition.abs() * 0.1)),
                child: Opacity(
                  opacity: (1 - (relativePosition.abs() * 0.3)).clamp(0.0, 1.0),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ItemCard(
                      title: "$index Subscription",
                      color: Colors.white,
                      boxShadow: BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                      dueDate: 3,
                      price: 150,
                      imagePath: "",
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 6),

        // Pagination Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            bool isActive = _currentPage.round() == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive ? Color(0xFFB0DB9C) : Colors.grey,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}
