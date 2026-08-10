import 'package:bytes_and_bites/features/auth/presentation/widgets/password_setup_helpers.dart';
import 'package:bytes_and_bites/core/services/hive_box_manager.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordSetupScreen extends StatefulWidget {
  const PasswordSetupScreen({super.key});

  @override
  State<PasswordSetupScreen> createState() => _PasswordSetupScreenState();
}

class _PasswordSetupScreenState extends State<PasswordSetupScreen> {
  String _pin = "";
  bool _isLoading = false;
  bool _hasError = false;

  // State variables to determine which mode the screen is in
  bool _isSetupMode = true;
  String? _savedPasscode;

  @override
  void initState() {
    super.initState();
    _checkMode();
  }

  void _checkMode() {
    // Check if the user already has a saved passcode
    final box = Hive.box('settingsBox');
    _savedPasscode = box.get('user_passcode');

    setState(() {
      // If a passcode exists and is not empty, Unlock Mode
      _isSetupMode = _savedPasscode == null || _savedPasscode!.isEmpty;
    });
  }

  Future<void> _onNumberPressed(String number) async {
    if (_isLoading) return;

    setState(() {
      _hasError = false; // Clear error state on typing
      if (_pin.length < 4) {
        _pin += number;
      }
    });

    if (_pin.length == 4) {
      setState(() {
        _isLoading = true;
      });

      final box = Hive.box('settingsBox');

      try {
        if (_isSetupMode) {
          // Setup New Passcode
          await box.put('user_passcode', _pin);
          await box.put('is_first_time', false);
          await box.put('is_logged_in', true);

          await HiveBoxManager.openUserDataBoxes();
          print("Saved New Passcode to Hive: $_pin");

          if (mounted) {
            Navigator.pushReplacementNamed(context, 'homepage');
          }
        } else {
          // Validate Existing Passcode
          if (_pin == _savedPasscode) {
            await box.put('is_logged_in', true);
            await HiveBoxManager.openUserDataBoxes();

            if (mounted) {
              Navigator.pushReplacementNamed(context, 'homepage');
            }
          } else {
            // Incorrect PIN entered
            setState(() {
              _isLoading = false;
              _hasError = true;
              _pin = ""; // Reset for retry
            });
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _pin = "";
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  void _onDeletePressed() {
    if (_isLoading) return;

    setState(() {
      _hasError = false;
      if (_pin.isNotEmpty) {
        _pin = _pin.substring(0, _pin.length - 1);
      }
    });
  }

  // Show Forgot Password Dialog
  void _showForgotPasswordDialog() {
    final box = Hive.box('settingsBox');
    final String? savedAnswer = box.get('security_answer');

    // Fallback: If they skipped the name setup entirely and don't have an answer saved
    if (savedAnswer == null || savedAnswer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No security question was set during setup. App reset required.',
          ),
        ),
      );
      return;
    }

    final TextEditingController answerController = TextEditingController();
    bool hasError = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              backgroundColor: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_reset_rounded,
                      size: 50.sp,
                      color: const Color(0xFFB0DB9C),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Reset Passcode",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Answer your security question to reset your PIN.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Inter',
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Input Field for the Answer
                    SizedBox(
                      height: 55.h,
                      child: TextField(
                        controller: answerController,
                        decoration: InputDecoration(
                          hintText: "What is your mother's name?",
                          hintStyle: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey.shade400,
                          ),
                          prefixIcon: const Icon(
                            Icons.security,
                            color: Colors.grey,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFB0DB9C),
                            ),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      ),
                    ),

                    // Error Message
                    if (hasError)
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          "Incorrect answer. Please try again.",
                          style: TextStyle(
                            color: const Color(0xFFE57373),
                            fontSize: 12.sp,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),

                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(dialogContext),
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
                            onPressed: () {
                              String typedAnswer = answerController.text
                                  .trim()
                                  .toLowerCase();

                              String normalizedSavedAnswer = savedAnswer!
                                  .trim()
                                  .toLowerCase();

                              if (typedAnswer == normalizedSavedAnswer) {
                                Navigator.pop(dialogContext);

                                setState(() {
                                  _isSetupMode = true;
                                  _savedPasscode = null;
                                  _pin = "";
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Success! Please enter a new 4-digit passcode.',
                                    ),
                                    backgroundColor: Color(0xFFB0DB9C),
                                  ),
                                );
                              } else {
                                setDialogState(() {
                                  hasError = true;
                                });
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
                            child: const Text(
                              "Verify",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 50.h),
                      child: Image.asset(
                        'assets/images/lock_icon.png',
                        height: 120.h,
                        width: 120.h,
                        fit: BoxFit.contain,
                      ),
                    ),

                    if (_isSetupMode)
                      const PasswordSetupHelpers()
                    else
                      Column(
                        children: [
                          Text(
                            "Welcome Back",
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "Enter your passcode to unlock",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Inter',
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),

                    SizedBox(height: 30.h),

                    // Custom Dots Helper
                    PasscodeIndicator(pinLength: _pin.length),

                    // Error Message
                    if (_hasError)
                      Padding(
                        padding: EdgeInsets.only(top: 16.h),
                        child: Text(
                          "Incorrect passcode. Try again.",
                          style: TextStyle(
                            color: const Color(0xFFE57373),
                            fontSize: 14.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                    SizedBox(height: _hasError ? 24.h : 30.h),

                    // Custom Numpad
                    if (_isLoading)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: const CircularProgressIndicator(
                          color: Color(0xFFB0DB9C),
                        ),
                      )
                    else
                      CustomNumpad(
                        onNumberPressed: _onNumberPressed,
                        onDeletePressed: _onDeletePressed,
                        onBiometricsPressed: () => print("Trigger Biometrics"),
                      ),
                  ],
                ),
              ),
            ),

            if (!_isSetupMode && !_isLoading)
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: TextButton(
                  onPressed: _showForgotPasswordDialog,
                  child: Text(
                    "Forgot Passcode?",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFB0DB9C),
                    ),
                  ),
                ),
              ),

            //  Only show Skip button if we are setting up a new pin
            if (_isSetupMode)
              Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: TextButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          setState(() {
                            _isLoading = true;
                          });
                          await Future.delayed(
                            const Duration(milliseconds: 1800),
                          );
                          final box = Hive.box('settingsBox');
                          await box.put('is_first_time', false);
                          await box.put('is_logged_in', true);

                          await HiveBoxManager.openUserDataBoxes();
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(context, 'homepage');
                          }
                        },
                  child: Text(
                    'Skip for now',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      color: _isLoading ? Colors.grey : const Color(0xFFB0DB9C),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
