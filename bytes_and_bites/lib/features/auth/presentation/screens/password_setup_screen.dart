import 'package:bytes_and_bites/features/auth/presentation/widgets/password_setup_helpers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordSetupScreen extends StatefulWidget {
  const PasswordSetupScreen({super.key});

  @override
  State<PasswordSetupScreen> createState() => _PasswordSetupScreenState();
}

class _PasswordSetupScreenState extends State<PasswordSetupScreen> {
  String _pin = "";

  void _onNumberPressed(String number) async {
    setState(() {
      if (_pin.length < 4) {
        _pin += number;
      }
    });
    if (_pin.length == 4) {
      //  Open the local database
      final prefs = await SharedPreferences.getInstance();

      //  Save the Passcode
      await prefs.setString('user_passcode', _pin);

      // Mark that the user has completed the setup
      await prefs.setBool('is_first_time', false);

      print("Saved Passcode: $_pin");

      // Navigate to Home
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
                      padding: const EdgeInsets.only(top: 50),
                      child: Image.asset(
                        'assets/images/lock_icon.png',
                        height: 120,
                        width: 120,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Custom Text Helper
                    const PasswordSetupHelpers(),

                    const SizedBox(height: 30),

                    // Custom Dots Helper
                    PasscodeIndicator(pinLength: _pin.length),

                    const SizedBox(height: 40),

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
              padding: const EdgeInsets.only(bottom: 20),
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'homepage');
                },
                child: const Text(
                  'Skip for now',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFB0DB9C),
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
