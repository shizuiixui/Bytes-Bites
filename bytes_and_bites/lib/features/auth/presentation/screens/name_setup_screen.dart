import 'package:bytes_and_bites/core/widgets/primary_button.dart';
import 'package:bytes_and_bites/core/widgets/textbox.dart';
import 'package:bytes_and_bites/features/auth/presentation/widgets/name_setup_helpers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NameSetupScreen extends StatefulWidget {
  const NameSetupScreen({super.key});

  @override
  State<NameSetupScreen> createState() => _NameSetupScreenState();
}

class _NameSetupScreenState extends State<NameSetupScreen> {
  final nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Top Image
                    Padding(
                      padding: EdgeInsets.only(top: 50.h),
                      child: Image.asset(
                        'assets/images/name_page_icon.png',
                        height: 180.h,
                        width: 150.w,
                        fit: BoxFit.contain,
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Text Section
                    const NameSetupHelpers(),

                    SizedBox(height: 10.h),

                    // Input Field
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: nameController,
                              keyboardType: TextInputType.name,
                              decoration: textInputField(
                                'Enter your name',
                                prefixIcon: Icons.person,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Button
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
              child: Column(
                children: [
                  // Continue Button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: PrimaryButton(
                      text: "Continue",
                      onPressed: () async {
                        String typedName = nameController.text.trim();

                        if (typedName.isNotEmpty) {
                          // To open local database
                          final prefs = await SharedPreferences.getInstance();

                          // Save the name
                          await prefs.setString('user_name', typedName);

                          print("Saved Name: $typedName");

                          // Move to the password screen
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(
                              context,
                              'password_setup',
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a name first!'),
                            ),
                          );
                        }
                      },
                    ),
                  ),

                  SizedBox(height: 5.h),

                  // Skip Button
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, 'password_setup');
                    },
                    child: Text(
                      'Skip for now',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFB0DB9C),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
