import 'package:bytes_and_bites/core/widgets/primary_button.dart';
import 'package:bytes_and_bites/core/widgets/textbox.dart';
import 'package:bytes_and_bites/features/auth/presentation/widgets/name_setup_helpers.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NameSetupScreen extends StatefulWidget {
  const NameSetupScreen({super.key});

  @override
  State<NameSetupScreen> createState() => _NameSetupScreenState();
}

class _NameSetupScreenState extends State<NameSetupScreen> {
  final nameController = TextEditingController();
  final securityController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    securityController.dispose();
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

                    SizedBox(height: 15.h),

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

                            SizedBox(height: 20.h),

                            // Security Question Field
                            Text(
                              "Security Question",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: 'NotoSans',
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            SizedBox(
                              height: 55.h,
                              child: TextFormField(
                                controller: securityController,
                                keyboardType: TextInputType.name,
                                decoration: textInputField(
                                  "What is your mother's name?",
                                  prefixIcon: Icons.security,
                                ),
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
                      isLoading: _isLoading,
                      onPressed: _isLoading
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                              });

                              await Future.delayed(
                                const Duration(milliseconds: 1800),
                              );

                              String typedName = nameController.text.trim();
                              String typedSecurity = securityController.text
                                  .trim()
                                  .toLowerCase();

                              if (typedName.isNotEmpty &&
                                  typedSecurity.isNotEmpty) {
                                final box = Hive.box('settingsBox');

                                box.put('userName', typedName);
                                box.put('security_answer', typedSecurity);

                                // Debugging prints
                                print("Saved Name: $typedName");
                                print("Saved Answer: $typedSecurity");
                                print("Saved Name to Hive: $typedName");

                                if (context.mounted) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    'password_setup',
                                  );
                                }
                              } else {
                                setState(() {
                                  _isLoading = false;
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please fill out both fields!',
                                    ),
                                  ),
                                );
                              }
                            },
                    ),
                  ),

                  SizedBox(height: 15.h),

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
                        color: const Color(0xFFB0DB9C),
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
