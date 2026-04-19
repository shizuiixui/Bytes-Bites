import 'package:bytes_and_bites/features/inventory/screens/inventory_page.dart';
import 'package:bytes_and_bites/features/transactions/screens/expense_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bytes_and_bites/features/home/widgets/month_picker_sheet.dart';
import 'package:bytes_and_bites/features/home/widgets/homepage_helpers.dart';
import 'package:bytes_and_bites/models/expense_model.dart';
import 'package:bytes_and_bites/features/transactions/widgets/transaction_card.dart';
import 'package:bytes_and_bites/models/inventory_model.dart';
import 'package:bytes_and_bites/features/inventory/widgets/inventory_card.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onTransactionsTap;
  final VoidCallback onInventoryTap;

  const HomePage({
    super.key,
    required this.onProfileTap,
    required this.onTransactionsTap,
    required this.onInventoryTap,
  });

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
      backgroundColor: Color(0XFFF9F9F9),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 10.h),
                child: ValueListenableBuilder<Box>(
                  valueListenable: Hive.box(
                    'settingsBox',
                  ).listenable(keys: ['userName']),
                  builder: (context, box, _) {
                    // Fetch name
                    String currentName = box.get(
                      'userName',
                      defaultValue: 'User',
                    );

                    return HomeHeader(
                      userName: currentName,
                      onProfileTap: widget.onProfileTap,
                      currentDate: _selectedDate,
                      onCalendarTap: _openMonthPicker,
                    );
                  },
                ),
              ),
            ),
          ),

          // Total Spent Card
          SliverToBoxAdapter(child: TotalSpent(selectedMonth: _selectedDate)),

          // Upcoming Subscriptions
          const SliverToBoxAdapter(child: HomeCarousel()),

          // Recent Transactions Header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: SectionHeader(
                title: "Recent Transactions",
                onSeeAllTap: widget.onTransactionsTap,
              ),
            ),
          ),

          // Recent Transactions List
          SliverToBoxAdapter(
            child: ValueListenableBuilder<Box<ExpenseModel>>(
              valueListenable: Hive.box<ExpenseModel>(
                'expensesBox',
              ).listenable(),
              builder: (context, box, _) {
                final expenses = box.values
                    .where(
                      (e) =>
                          e.date.month == _selectedDate.month &&
                          e.date.year == _selectedDate.year,
                    )
                    .toList();

                expenses.sort((a, b) => b.date.compareTo(a.date));
                final recentExpenses = expenses.take(3).toList();

                if (recentExpenses.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 10.h,
                    ),
                    child: Text(
                      "No transactions yet.",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.grey.shade500,
                      ),
                    ),
                  );
                }

                return Column(
                  children: recentExpenses
                      .map((tx) => TransactionCard(expense: tx))
                      .toList(),
                );
              },
            ),
          ),

          // Low Stock Inventory Header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: SectionHeader(
                title: "Low Stock Alerts",
                onSeeAllTap: widget.onInventoryTap,
              ),
            ),
          ),

          // Inventory List
          SliverToBoxAdapter(
            child: ValueListenableBuilder<Box<InventoryModel>>(
              valueListenable: Hive.box<InventoryModel>(
                'inventoryBox',
              ).listenable(),
              builder: (context, box, _) {
                final lowStockItems = box.values
                    .where((item) => item.quantity <= item.lowStockThreshold)
                    .toList();

                if (lowStockItems.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 10.h,
                    ),
                    child: Text(
                      "All stock levels are good!",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.grey.shade500,
                      ),
                    ),
                  );
                }

                return Column(
                  children: lowStockItems.take(3).map((item) {
                    return InventoryCard(item: item);
                  }).toList(),
                );
              },
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 120.h)),
        ],
      ),
    );
  }
}
