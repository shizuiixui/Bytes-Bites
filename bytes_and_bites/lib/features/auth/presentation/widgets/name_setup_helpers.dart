import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NameSetupHelpers extends StatelessWidget {
  const NameSetupHelpers({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          // Title
          Text.rich(
            TextSpan(
              text: 'Welcome to ',
              style: TextStyle(
                fontSize: 35.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: Colors.black,
                height: 1.2,
              ),
              children: [
                TextSpan(
                  text: 'Bytes & Bites',
                  style: TextStyle(color: Color(0xFFB0DB9C)),
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          // Subtitle
          Text(
            'What should we call you?',
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: 'NotoSans',
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
