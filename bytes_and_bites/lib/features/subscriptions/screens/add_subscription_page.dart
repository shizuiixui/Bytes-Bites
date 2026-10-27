import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:bytes_and_bites/core/widgets/primary_button.dart';
import 'package:bytes_and_bites/core/widgets/categories.dart';
import 'package:bytes_and_bites/core/services/hive_box_manager.dart';
import 'package:bytes_and_bites/features/transactions/widgets/add_expense_helpers.dart';
import 'package:bytes_and_bites/models/subscription_model.dart';
import 'package:bytes_and_bites/core/services/notification_service.dart';

class AddSubscriptionPage extends StatefulWidget {
  final SubscriptionModel? existingSubscription;

  const AddSubscriptionPage({super.key, this.existingSubscription});

  @override
  State<AddSubscriptionPage> createState() => _AddSubscriptionPageState();
}

class _AddSubscriptionPageState extends State<AddSubscriptionPage> {
  final TextEditingController _serviceController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  SubscriptionCategory? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.existingSubscription != null) {
      final sub = widget.existingSubscription!;
      _serviceController.text = sub.name;
      _amountController.text = sub.amount.toString();
      _selectedDate = sub.nextBillingDate;
      if (subscriptionCategories.isNotEmpty) {
        _selectedCategory = subscriptionCategories.first;
      }
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
                ...subscriptionCategories.map(
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
    if (_serviceController.text.isEmpty ||
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

    bool isEditing = widget.existingSubscription != null;
    final String newServiceName = _serviceController.text.trim();
    final box = HiveBoxManager.subscriptionsBox();

    // Duplicate Check Logic
    bool subExists = box.values.any((sub) {
      // Ignore itself during the edit check
      if (isEditing && sub.key == widget.existingSubscription!.key)
        return false;
      return sub.name.toLowerCase() == newServiceName.toLowerCase();
    });

    if (subExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "This subscription already exists!",
            style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
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
              surfaceTintColor: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isEditing
                          ? Icons.edit_rounded
                          : Icons.subscriptions_rounded,
                      size: 50.sp,
                      color: const Color(0xFFB0DB9C),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      isEditing ? "Update Subscription?" : "Save Subscription?",
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
                          ? "Are you sure you want to update ${_serviceController.text} to ₱${_amountController.text}?"
                          : "Are you sure you want to add ₱${_amountController.text} for ${_serviceController.text}?",
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

                                    String snackBarMessage =
                                        "Subscription saved successfully!";

                                    if (isEditing) {
                                      final sub = widget.existingSubscription!;
                                      if (sub.name != newServiceName) {
                                        await NotificationService()
                                            .cancelSubscriptionAlerts(sub.name);
                                        snackBarMessage =
                                            "Subscription renamed to $newServiceName!";
                                      } else {
                                        snackBarMessage =
                                            "Subscription updated!";
                                      }

                                      sub.name = newServiceName;
                                      sub.amount =
                                          double.tryParse(
                                            _amountController.text,
                                          ) ??
                                          sub.amount;
                                      sub.nextBillingDate = _selectedDate;

                                      await sub.save();
                                      // Re-schedule updated notification
                                      await NotificationService()
                                          .scheduleSubscriptionAlerts(
                                            sub,
                                            forceInstant: true,
                                          );
                                    } else {
                                      // Add New Subscription
                                      final newSubscription = SubscriptionModel(
                                        name: newServiceName,
                                        amount:
                                            double.tryParse(
                                              _amountController.text,
                                            ) ??
                                            0.0,
                                        nextBillingDate: _selectedDate,
                                      );

                                      HiveBoxManager.subscriptionsBox().add(
                                        newSubscription,
                                      );
                                      await NotificationService()
                                          .scheduleSubscriptionAlerts(
                                            newSubscription,
                                            forceInstant: true,
                                          );
                                    }

                                    if (context.mounted) {
                                      Navigator.pop(
                                        dialogContext,
                                      ); // Close dialog

                                      ScaffoldMessenger.of(
                                        this.context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            snackBarMessage,
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

                                      Navigator.pop(
                                        this.context,
                                      ); // Return to previous page
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
    _serviceController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.existingSubscription != null;

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
                isEditing ? "Edit Subscription" : "Add New Subscriptions",
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
                    ? "Update the details of your subscription."
                    : "Enter the details of your subscription to help you track your spending",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'Inter',
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 30.h),

              buildLabel("Service Name"),
              buildTextField(
                hint: "Enter Service Name",
                controller: _serviceController,
              ),

              buildLabel("Enter Amount"),
              buildTextField(
                hint: "Enter Amount",
                controller: _amountController,
                keyboardType: TextInputType.number,
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

              buildLabel("Next Billing Date"),
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
                text: isEditing ? "Update Subscription" : "Save Subscription",
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
