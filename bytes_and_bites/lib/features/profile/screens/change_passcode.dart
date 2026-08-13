import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bytes_and_bites/core/widgets/primary_button.dart';

class ChangePasscodePage extends StatefulWidget {
  const ChangePasscodePage({super.key});

  @override
  State<ChangePasscodePage> createState() => _ChangePasscodePageState();
}

class _ChangePasscodePageState extends State<ChangePasscodePage> {
  final TextEditingController _securityAnswerController =
      TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  bool _isLoading = false;

  Future<void> _updatePasscode() async {
    // Check if any field is empty
    if (_securityAnswerController.text.isEmpty ||
        _newPassController.text.isEmpty ||
        _confirmPassController.text.isEmpty) {
      _showErrorSnackBar("Please fill out all fields.");
      return;
    }

    final box = Hive.box('settingsBox');
    final String? savedAnswer = box.get('security_answer');

    // Verify the security answer 
    String typedAnswer = _securityAnswerController.text.trim().toLowerCase();
    String normalizedSavedAnswer = (savedAnswer ?? "").trim().toLowerCase();

    if (typedAnswer != normalizedSavedAnswer) {
      _showErrorSnackBar("Incorrect security answer.");
      return;
    }

    // Verify the new passcodes match each other
    if (_newPassController.text != _confirmPassController.text) {
      _showErrorSnackBar("New passcodes do not match!");
      return;
    }

    // Ensure the new passcode is exactly 4 digits
    if (_newPassController.text.length < 4) {
      _showErrorSnackBar("Passcode must be 4 digits.");
      return;
    }

    // Start loading state
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    // Save the new passcode to the database
    await box.put('user_passcode', _newPassController.text);

    if (mounted) {
      // Stop loading
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Passcode updated successfully!",
            style: TextStyle(fontFamily: 'Inter', color: Colors.white),
          ),
          backgroundColor: Color(0xFFB0DB9C),
          behavior: SnackBarBehavior.fixed,
        ),
      );

      // Return to the profile page
      Navigator.pop(context);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Inter')),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  @override
  void dispose() {
    _securityAnswerController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Change Passcode",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Security Question"),
              _buildTextField(
                controller: _securityAnswerController,
                hint: "What is your mother's name?",
              ),

              SizedBox(height: 24.h),

              _buildLabel("New Passcode"),
              _buildPasscodeField(
                controller: _newPassController,
                hint: "Enter new passcode",
              ),
              _buildLabel("Confirm New Passcode"),
              _buildPasscodeField(
                controller: _confirmPassController,
                hint: "Re-enter new passcode",
              ),
              SizedBox(height: 40.h),

              PrimaryButton(
                text: "Update Passcode",
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _updatePasscode,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, top: 12.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 16.sp, fontFamily: 'Inter'),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFB0DB9C), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildPasscodeField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      keyboardType: TextInputType.number,
      maxLength: 4,
      style: TextStyle(fontSize: 16.sp, fontFamily: 'Inter', letterSpacing: 4),
      decoration: InputDecoration(
        counterText: "",
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, letterSpacing: 0),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFB0DB9C), width: 1.5),
        ),
      ),
    );
  }
}
