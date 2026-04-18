import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:bytes_and_bites/core/widgets/primary_button.dart';
import 'package:bytes_and_bites/core/widgets/categories.dart';
import 'package:bytes_and_bites/features/transactions/widgets/add_expense_helpers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bytes_and_bites/models/expense_model.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  ExpenseCategory? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  void _openCategoryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Select Category",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 10.h),
                ...expenseCategories.map(
                  (category) => ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB0DB9C).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        category.icon,
                        color: const Color(0xFF5A8C47),
                        size: 20.sp,
                      ),
                    ),
                    title: Text(
                      category.name,
                      style: TextStyle(fontSize: 14.sp, fontFamily: 'Inter'),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showConfirmationDialog() {
    if (_descController.text.isEmpty ||
        _amountController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Please fill out all fields",
            style: TextStyle(fontFamily: 'Inter'),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.help_outline_rounded,
                  size: 50.sp,
                  color: const Color(0xFFB0DB9C),
                ),
                SizedBox(height: 16.h),
                Text(
                  "Save Expense?",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Are you sure you want to add ₱${_amountController.text} for ${_descController.text}?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Inter',
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.black87,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Confirm Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Create the database object
                          final newExpense = ExpenseModel(
                            description: _descController.text,
                            amount: double.parse(_amountController.text),
                            categoryName: _selectedCategory!.name,
                            date: _selectedDate,
                          );

                          // Grab the open database box
                          final box = Hive.box<ExpenseModel>('expensesBox');

                          // Save it
                          box.add(newExpense);

                          Navigator.pop(context);

                          ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                "Expense saved successfully!",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: const Color(0xFFB0DB9C),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                          );

                          Navigator.pop(this.context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB0DB9C),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Confirm",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFB0DB9C),
              onPrimary: Colors.black,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add new expense",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Enter the details of your expense to help you track your spending",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'Inter',
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 30.h),

              buildLabel("Description"),
              buildTextField(
                hint: "Enter Description",
                controller: _descController,
              ),

              buildLabel("Enter Amount"),
              buildTextField(
                hint: "Enter Amount",
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                prefixIcon: Padding(
                  padding: EdgeInsets.all(14.w),
                  child: Text(
                    "₱",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              buildLabel("Category"),
              GestureDetector(
                onTap: _openCategoryPicker,
                child: buildDropdownContainer(
                  text: _selectedCategory?.name ?? "Choose a category",
                  icon: Icons.chevron_right_rounded,
                  isHint: _selectedCategory == null,
                ),
              ),

              buildLabel("Date"),
              GestureDetector(
                onTap: _pickDate,
                child: buildDropdownContainer(
                  text: DateFormat('MMMM dd, yyyy').format(_selectedDate),
                  icon: Icons.calendar_month_rounded,
                  isHint: false,
                ),
              ),

              SizedBox(height: 40.h),

              PrimaryButton(
                text: "Save Expense",
                onPressed: _showConfirmationDialog,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
