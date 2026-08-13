import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:bytes_and_bites/core/widgets/primary_button.dart';
import 'package:bytes_and_bites/core/widgets/categories.dart';
import 'package:bytes_and_bites/core/services/hive_box_manager.dart';
import 'package:bytes_and_bites/features/transactions/widgets/add_expense_helpers.dart';
import 'package:bytes_and_bites/models/expense_model.dart';

class AddExpensePage extends StatefulWidget {
  final ExpenseModel? existingExpense;

  const AddExpensePage({super.key, this.existingExpense});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  ExpenseCategory? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.existingExpense != null) {
      final exp = widget.existingExpense!;
      _descController.text = exp.description;
      _amountController.text = exp.amount.toString();
      _selectedDate = exp.date;

      _selectedCategory = expenseCategories.firstWhere(
        (cat) => cat.name == exp.categoryName,
        orElse: () => expenseCategories.first,
      );
    }
  }

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

  // Confirmation Dialog
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
          behavior: SnackBarBehavior.fixed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      );
      return;
    }

    bool isSaving = false;
    bool isEditing = widget.existingExpense != null;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
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
                      isEditing
                          ? Icons.edit_rounded
                          : Icons.help_outline_rounded,
                      size: 50.sp,
                      color: const Color(0xFFB0DB9C),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      isEditing ? "Update Expense?" : "Save Expense?",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      isEditing
                          ? "Are you sure you want to update ${_descController.text} to ₱${_amountController.text}?"
                          : "Are you sure you want to add ₱${_amountController.text} for ${_descController.text}?",
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
                            onPressed: isSaving
                                ? null
                                : () => Navigator.pop(dialogContext),
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
                            onPressed: isSaving
                                ? null
                                : () async {
                                    setDialogState(() {
                                      isSaving = true;
                                    });
                                    await Future.delayed(
                                      const Duration(milliseconds: 1800),
                                    );

                                    if (isEditing) {
                                      // Update Expense
                                      final exp = widget.existingExpense!;
                                      exp.description = _descController.text;
                                      exp.amount = double.parse(
                                        _amountController.text,
                                      );
                                      exp.categoryName =
                                          _selectedCategory!.name;
                                      exp.date = _selectedDate;

                                      await exp
                                          .save(); // Instantly updates Hive
                                    } else {
                                      // Add New Expense
                                      final newExpense = ExpenseModel(
                                        description: _descController.text,
                                        amount: double.parse(
                                          _amountController.text,
                                        ),
                                        categoryName: _selectedCategory!.name,
                                        date: _selectedDate,
                                      );

                                      final box = HiveBoxManager.expensesBox();
                                      box.add(newExpense);
                                    }

                                    if (context.mounted) {
                                      Navigator.pop(dialogContext);

                                      ScaffoldMessenger.of(
                                        this.context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            isEditing
                                                ? "Expense updated!"
                                                : "Expense saved successfully!",
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          backgroundColor: const Color(
                                            0xFFB0DB9C,
                                          ),
                                          behavior: SnackBarBehavior.fixed,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10.r,
                                            ),
                                          ),
                                        ),
                                      );

                                      Navigator.pop(this.context);
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB0DB9C),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              elevation: 0,
                            ),
                            child: isSaving
                                ? SizedBox(
                                    height: 20.h,
                                    width: 20.h,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Text(
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
      },
    );
  }

  // Pick Date Function
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
    bool isEditing = widget.existingExpense != null;

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
                isEditing ? "Edit expense" : "Add new expense",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                isEditing
                    ? "Update the details of your expense."
                    : "Enter the details of your expense to help you track your spending",
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
                text: isEditing ? "Update Expense" : "Save Expense",
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
