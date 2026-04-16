import 'package:bytes_and_bites/features/home/widgets/homepage_helpers.dart';
import 'package:bytes_and_bites/core/widgets/background_card.dart';
import 'package:flutter/material.dart';
import 'package:bytes_and_bites/features/home/widgets/month_picker_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onProfileTap;

  const HomePage({super.key, required this.onProfileTap});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();

  void _openMonthPicker() async {
    final DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return MonthPickerSheet(initialDate: _selectedDate);
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 10.h),
                child: HomeHeader(
                  userName: 'User',
                  onProfileTap: widget.onProfileTap,
                  currentDate: _selectedDate,
                  onCalendarTap: _openMonthPicker,
                ),
              ),
            ),
          ),

          // Total Spent Card
          const SliverToBoxAdapter(child: TotalSpent()),

          // Upcoming Subscriptions
          const SliverToBoxAdapter(child: HomeCarousel()),

          // Recent Transactions Header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: SectionHeader(
                title: "Recent Transactions",
                onSeeAllTap: () {
                  // Navigate to full transaction history
                },
              ),
            ),
          ),

          // Recent Transactions List
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  ItemCard(
                    title: "SM Supermarket",
                    subtitle: "Today, 2:30 PM",
                    subtitleColor: Colors.grey.shade500,
                    color: Colors.white,
                    boxShadow: BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10.r,
                      offset: Offset(0, 4.h),
                    ),
                    price: 850,
                    imagePath: "",
                  ),
                  SizedBox(height: 10.h),
                  ItemCard(
                    title: "Spotify Premium",
                    subtitle: "Yesterday",
                    subtitleColor: Colors.grey.shade500,
                    color: Colors.white,
                    boxShadow: BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10.r,
                      offset: Offset(0, 4.h),
                    ),
                    price: 149,
                    imagePath: "",
                  ),
                ],
              ),
            ),
          ),

          // Low Stock Inventory Header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: SectionHeader(
                title: "Low Stock Alerts",
                onSeeAllTap: () {
                  // Navigate to full inventory
                },
              ),
            ),
          ),

          // Low Stock Inventory List
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  ItemCard(
                    title: "Lucky Me! Pancit Canton",
                    subtitle: "Only 2 packs left!",
                    subtitleColor: const Color(0xFFFF6B6B),
                    color: Colors.white,
                    boxShadow: BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10.r,
                      offset: Offset(0, 4.h),
                    ),
                    price: 40,
                    imagePath: "",
                  ),
                  SizedBox(height: 10.h),
                  ItemCard(
                    title: "Nescafe 3-in-1 Coffee",
                    subtitle: "Only 4 sticks left!",
                    subtitleColor: const Color(0xFFFF6B6B),
                    color: Colors.white,
                    boxShadow: BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10.r,
                      offset: Offset(0, 4.h),
                    ),
                    price: 60,
                    imagePath: "",
                  ),

                  SizedBox(height: 120.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
