import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bytes_and_bites/features/home/widgets/month_picker_sheet.dart';
import 'package:bytes_and_bites/models/expense_model.dart';
import 'package:bytes_and_bites/features/transactions/widgets/transaction_card.dart'; 

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  DateTime _selectedDate = DateTime.now(); 

  void _onMonthPicker() async {
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
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.h),
            
            // Header Title
            Text(
              "Transaction History",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),
            
            // Month Picker 
            GestureDetector(
              onTap: _onMonthPicker,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                color: Colors.transparent, 
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_month_rounded, size: 20.sp, color: Colors.black87),
                    SizedBox(width: 8.w),
                    Text(
                      DateFormat('MMMM yyyy').format(_selectedDate),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.keyboard_arrow_down_rounded, size: 20.sp, color: Colors.black87),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            
            // Database Listener & Transaction List
            Expanded(
              child: ValueListenableBuilder<Box<ExpenseModel>>(
                valueListenable: Hive.box<ExpenseModel>('expensesBox').listenable(),
                builder: (context, box, _) {
                  final List<ExpenseModel> allExpenses = box.values.toList();
                  final List<ExpenseModel> filteredExpenses = allExpenses.where((expense) {
                    return expense.date.month == _selectedDate.month && 
                           expense.date.year == _selectedDate.year;
                  }).toList();

                  filteredExpenses.sort((a, b) => b.date.compareTo(a.date));

                  final Map<String, List<ExpenseModel>> groupedTransactions = {};
                  for (var expense in filteredExpenses) {
                    String dateString = DateFormat('MMMM dd, yyyy').format(expense.date);
                    if (!groupedTransactions.containsKey(dateString)) {
                      groupedTransactions[dateString] = [];
                    }
                    groupedTransactions[dateString]!.add(expense);
                  }

                  if (groupedTransactions.isEmpty) {
                    return Center(
                      child: Text(
                        "No transactions this month.",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: 100.h), 
                    itemCount: groupedTransactions.keys.length,
                    itemBuilder: (context, index) {
                      String date = groupedTransactions.keys.elementAt(index);
                      List<ExpenseModel> transactions = groupedTransactions[date]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 16.h, bottom: 8.h),
                            child: Text(
                              date,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          
                          ...transactions.map((tx) => TransactionCard(expense: tx)),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}