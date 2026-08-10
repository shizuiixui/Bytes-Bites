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
