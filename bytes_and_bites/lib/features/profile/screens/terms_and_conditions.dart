import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Terms & Conditions",
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
              _buildSectionTitle("1. Acceptance of Terms"),
              _buildParagraph(
                "By downloading and using Bytes & Bites, you agree to these Terms and Conditions. This app is provided as a personal utility tool to help you track your budget and manage personal inventory. It is not intended for commercial use or as a financial advisory service.",
              ),

              _buildSectionTitle("2. User Data and Privacy"),
              _buildParagraph(
                "Bytes & Bites is an organizational tool, not a certified financial institution. The data, summaries, and alerts provided by the app are based solely on the information you manually input. The app does not provide professional financial, investment, or legal advice.",
              ),

              _buildSectionTitle("3. Data Responsibility and Loss"),
              _buildParagraph(
                "You are solely responsible for the accuracy of the data you enter. Because Bytes & Bites operates entirely offline to protect your privacy, we cannot recover your data if you lose your device, perform a factory reset, or uninstall the app. We recommend manually noting down important financial records.",
              ),

              _buildSectionTitle("4. Acceptable Use"),
              _buildParagraph(
                "You agree not to use Bytes & Bites for any unlawful, harmful, or fraudulent activities. This includes, but is not limited to, using the app to facilitate illegal transactions, harass others, or distribute malicious software.",
              ),

              _buildSectionTitle("5. Modification to the App"),
              _buildParagraph(
                "We reserve the right to update, modify, or discontinue features of the app at any time to improve the user experience.",
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
