import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplashSequence();
  }

  Future<void> _startSplashSequence() async {
    // Wait 2 seconds for the logo
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // Check the local database
    final prefs = await SharedPreferences.getInstance();

    //  Look for the 'is_first_time' flag
    bool isFirstTime = prefs.getBool('is_first_time') ?? true;

    // The Smart Routing Logic
    if (isFirstTime) {
      // If new, send them to Landing Page
      Navigator.pushReplacementNamed(context, 'landing_page');
    } else {
      // If they already set up their profile, skip onboarding entirely!
      Navigator.pushReplacementNamed(context, 'homepage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB0DB9C),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/images/Full Logo.png',
              width: 250,
              height: 300,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 20),

            // Loading Indicator
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
