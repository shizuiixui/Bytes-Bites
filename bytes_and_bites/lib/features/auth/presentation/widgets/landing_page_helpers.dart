import 'package:bytes_and_bites/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class LandingPageHelpers extends StatelessWidget {
  const LandingPageHelpers({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          // Title
          const Text.rich(
            TextSpan(
              text: 'Take Control of\nYour ',
              style: TextStyle(
                fontSize: 35,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: Colors.black,
                height: 1.2,
              ),
              children: [
                TextSpan(
                  text: 'Budget',
                  style: TextStyle(color: Color(0xFFB0DB9C)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Subtitle
          const Text(
            'Manage your spending and dorm inventory, entirely offline.',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'NotoSans',
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 50),

          // Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: PrimaryButton(
              text: "Get Started",
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'name_setup');
              },
            ),
          ),
        ],
      ),
    );
  }
}
