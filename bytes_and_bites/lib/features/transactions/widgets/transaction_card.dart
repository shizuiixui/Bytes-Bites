import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:bytes_and_bites/models/expense_model.dart';
import 'package:bytes_and_bites/core/widgets/categories.dart';
import 'package:bytes_and_bites/features/transactions/screens/add_expense_page.dart';

class TransactionCard extends StatelessWidget {
  final ExpenseModel expense;

  const TransactionCard({super.key, required this.expense});

  // Delete Confirmation Dialog
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(
          "Delete Expense",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        content: Text(
          "Are you sure you want to delete ${expense.description}? This action cannot be undone.",
          style: TextStyle(fontFamily: 'Inter', fontSize: 14.sp),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              await expense.delete(); // Deletes from Hive

              if (context.mounted) {
                Navigator.pop(context); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "${expense.description} Deleted",
                      style: const TextStyle(fontFamily: 'Inter'),
                    ),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.fixed,
                  ),
                );
              }
            },
            child: const Text(
              "Delete",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Format currency
    final formatCurrency = NumberFormat("#,##0.00", "en_US");
    final String amountStr = formatCurrency.format(expense.amount);
    final category = expenseCategories.firstWhere(
      (cat) => cat.name == expense.categoryName,
      orElse: () =>
          ExpenseCategory(name: 'Other', icon: Icons.receipt_long_rounded),
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 6.h),
      padding: EdgeInsets.only(left: 16.w, right: 8.w, top: 16.w, bottom: 16.w),
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
            child: Icon(
              category.icon,
              color: const Color(0xFF5A8C47),
              size: 24.sp,
            ),
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
          SizedBox(width: 4.w),

          // 3-Dot Options Menu
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: Colors.black),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ), color: Colors.white,
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddExpensePage(existingExpense: expense),
                  ),
                );
              } else if (value == 'delete') {
                _showDeleteConfirmation(context);
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_rounded, color: Colors.black, size: 20.sp),
                    SizedBox(width: 8.w),
                    const Text("Edit", style: TextStyle(fontFamily: 'Inter')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_rounded, color: Colors.red.shade400, size: 20.sp),
                    SizedBox(width: 8.w),
                    const Text("Delete", style: TextStyle(fontFamily: 'Inter')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
