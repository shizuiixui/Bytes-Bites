import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:bytes_and_bites/models/expense_model.dart';
import 'package:bytes_and_bites/core/widgets/categories.dart';

class TransactionCard extends StatelessWidget {
  final ExpenseModel expense;

  const TransactionCard({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    // Format currency
    final formatCurrency = NumberFormat("#,##0.00", "en_US");
    final String amountStr = formatCurrency.format(expense.amount);
    final category = expenseCategories.firstWhere(
      (cat) => cat.name == expense.categoryName,
      orElse: () => ExpenseCategory(name: 'Other', icon: Icons.receipt_long_rounded),
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 6.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFFB0DB9C).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(category.icon, color: const Color(0xFF5A8C47), size: 24.sp),
          ),
          SizedBox(width: 16.w),
          
          // Transaction Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.description,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  expense.categoryName,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'Inter',
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          
          // Amount
          Text(
            "-₱$amountStr",
            style: TextStyle(
              fontSize: 15.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              color: Colors.black87, 
            ),
          ),
          SizedBox(width: 8.w),
          
          // Chevron
          Icon(
            Icons.chevron_right_rounded,
            color: Colors.grey.shade400,
            size: 20.sp,
          ),
        ],
      ),
    );
  }
}