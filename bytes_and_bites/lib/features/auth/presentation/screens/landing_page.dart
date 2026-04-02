import 'package:bytes_and_bites/features/auth/presentation/widgets/landing_page_helpers.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              // Background Image
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Image.asset(
                  'assets/images/bg_image.png',
                  height: 420,
                  width: 380,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 10),

              // Text & Button Section
              const LandingPageHelpers(),
            ],
          ),
        ),
      ),
    );
  }
}