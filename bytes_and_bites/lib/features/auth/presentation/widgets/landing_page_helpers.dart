import 'package:bytes_and_bites/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LandingPageHelpers extends StatefulWidget {
  const LandingPageHelpers({super.key});

  @override
  State<LandingPageHelpers> createState() => _LandingPageHelpersState();
}

class _LandingPageHelpersState extends State<LandingPageHelpers> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),

          // Title
          Text.rich(
            TextSpan(
              text: 'Take Control of\nYour ',
              style: TextStyle(
                fontSize: 35.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: Colors.black,
                height: 1.2,
              ),
              children: const [
                TextSpan(
                  text: 'Budget',
                  style: TextStyle(color: Color(0xFFB0DB9C)),
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          // Subtitle
          Text(
            'Manage your spending and dorm inventory, entirely offline.',
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: 'NotoSans',
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: 50.h),

          // Button
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: PrimaryButton(
              text: "Get Started",
              isLoading: _isLoading,
              onPressed: _isLoading
                  ? null
                  : () async {
                      setState(() {
                        _isLoading = true;
                      });

                      await Future.delayed(const Duration(milliseconds: 1800));

                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, 'name_setup');
                      }
                    },
            ),
          ),
        ],
      ),
    );
  }
}
