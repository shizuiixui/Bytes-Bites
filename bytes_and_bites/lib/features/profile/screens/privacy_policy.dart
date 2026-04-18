import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Privacy Policy",
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
              Text(
                "Last updated: April 2026",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'Inter',
                  color: Colors.grey.shade500,
                ),
              ),
              SizedBox(height: 24.h),
              _buildSectionTitle("What Information Do We Collect?"),
              _buildParagraph(
                "Bytes & Bites collects data related to your daily expenses, subscriptions, and inventory items. Because this app utilizes a local database architecture, this data remains entirely on your local device hardware.",
              ),

              _buildSectionTitle("How Do We Use Your Information?"),
              _buildParagraph(
                "Your data is strictly used to provide the core functionality of the app: calculating totals, triggering low-stock warnings, and generating your monthly financial reports. We do not sell or distribute your data to third parties.",
              ),

              _buildSectionTitle("Data Security"),
              _buildParagraph(
                "We implement security measures, including optional passcode protection, to maintain the safety of your personal information when you access the application.",
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, top: 16.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontFamily: 'Inter',
        color: Colors.grey.shade700,
        height: 1.5,
      ),
    );
  }
}
