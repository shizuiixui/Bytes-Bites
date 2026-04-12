import 'package:bytes_and_bites/core/widgets/bottom_nav_bar.dart';
import 'package:bytes_and_bites/features/home/widgets/homepage_helpers.dart';
import 'package:flutter/material.dart';
import 'package:bytes_and_bites/features/home/widgets/month_picker_sheet.dart';

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
      backgroundColor:
          Colors.transparent, 
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
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 20, 24, 10),
                child: HomeHeader(
                  userName: 'User',
                  onProfileTap: widget.onProfileTap,
                  currentDate: _selectedDate,
                  onCalendarTap: _openMonthPicker,
                ),
              ),
            ),
          ),

          // Total Spent
          const SliverToBoxAdapter(child: TotalSpent()),
          // Carousel
          const SliverToBoxAdapter(child: HomeCarousel()),

          // Body
        ],
      ),
    );
  }
}
