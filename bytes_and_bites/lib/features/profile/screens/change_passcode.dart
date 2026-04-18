import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bytes_and_bites/core/widgets/primary_button.dart';

class ChangePasscodePage extends StatefulWidget {
  const ChangePasscodePage({super.key});

  @override
  State<ChangePasscodePage> createState() => _ChangePasscodePageState();
}

class _ChangePasscodePageState extends State<ChangePasscodePage> {
  final TextEditingController _currentPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  void _updatePasscode() {
    if (_newPassController.text != _confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("New passcodes do not match!", style: TextStyle(fontFamily: 'Inter')),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Passcode updated successfully!", style: TextStyle(fontFamily: 'Inter')),
        backgroundColor: const Color(0xFFB0DB9C),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _currentPassController.dispose();
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
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Colors.black87),
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
              _buildLabel("Current Passcode"),
              _buildPasscodeField(controller: _currentPassController, hint: "Enter current passcode"),
              
              SizedBox(height: 24.h),
              
              _buildLabel("New Passcode"),
              _buildPasscodeField(controller: _newPassController, hint: "Enter new passcode"),
              
              _buildLabel("Confirm New Passcode"),
              _buildPasscodeField(controller: _confirmPassController, hint: "Re-enter new passcode"),
              
              SizedBox(height: 40.h),
              PrimaryButton(text: "Update Passcode", onPressed: _updatePasscode),
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
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, fontFamily: 'Inter', color: Colors.black87),
      ),
    );
  }

  Widget _buildPasscodeField({required TextEditingController controller, required String hint}) {
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: Color(0xFFB0DB9C), width: 1.5)),
      ),
    );
  }
}