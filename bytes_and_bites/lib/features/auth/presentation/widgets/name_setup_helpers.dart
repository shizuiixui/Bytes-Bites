import 'package:flutter/material.dart';

class NameSetupHelpers extends StatelessWidget {
  const NameSetupHelpers({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          // Title
          const Text.rich(
            TextSpan(
              text: 'Welcome to ',
              style: TextStyle(
                fontSize: 35,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: Colors.black,
                height: 1.2,
              ),
              children: [
                TextSpan(
                  text: 'Bytes & Bites',
                  style: TextStyle(color: Color(0xFFB0DB9C)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Subtitle
          const Text(
            'What should we call you?',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'NotoSans',
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
