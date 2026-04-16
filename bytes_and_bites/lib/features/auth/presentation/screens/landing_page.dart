import 'package:bytes_and_bites/features/auth/presentation/widgets/landing_page_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    // Background Image
                    Padding(
                      padding: EdgeInsets.only(top: 50.h),
                      child: Image.asset(
                        'assets/images/bg_image.png',
                        height: 420.h,
                        width: 380.w,
                        fit: BoxFit.contain,
                      ),
                    ),

                    SizedBox(height: 10.h),

                    // Text & Button Section
                    const LandingPageHelpers(),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
