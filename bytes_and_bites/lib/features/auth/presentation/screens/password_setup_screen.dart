import 'package:bytes_and_bites/features/auth/presentation/widgets/password_setup_helpers.dart';
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

  void _onNumberPressed(String number) {
    setState(() {
      if (_pin.length < 4) {
        _pin += number;
      }
    });

    if (_pin.length == 4) {
      // Open the local Hive settings box
      final box = Hive.box('settingsBox');

      // Save Passcode
      box.put('user_passcode', _pin);
      box.put('is_first_time', false);

      print("Saved Passcode to Hive: $_pin");

      // 3. Navigate to Home
      if (mounted) {
        Navigator.pushReplacementNamed(context, 'homepage');
      }
    }
  }

  void _onDeletePressed() {
    setState(() {
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

                    SizedBox(height: 20.h),

                    // Custom Text Helper
                    const PasswordSetupHelpers(),

                    SizedBox(height: 30.h),

                    // Custom Dots Helper
                    PasscodeIndicator(pinLength: _pin.length),

                    SizedBox(height: 40.h),

                    // Custom Numpad
                    CustomNumpad(
                      onNumberPressed: _onNumberPressed,
                      onDeletePressed: _onDeletePressed,
                      onBiometricsPressed: () => print("Trigger Biometrics"),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Section
            Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: TextButton(
                onPressed: () {
                  Hive.box('settingsBox').put('is_first_time', false);
                  Navigator.pushReplacementNamed(context, 'homepage');
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
            ),
          ],
        ),
      ),
    );
  }
}
