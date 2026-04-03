import 'package:flutter/material.dart';

// Text Header
class PasswordSetupHelpers extends StatelessWidget {
  const PasswordSetupHelpers({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text(
            'Create Your Passcode',
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Enter a 4-digit passcode to keep your budget and inventory private',
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

// Dot Indicators
class PasscodeIndicator extends StatelessWidget {
  final int pinLength;

  const PasscodeIndicator({super.key, required this.pinLength});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        bool isFilled = index < pinLength;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? const Color(0xFFB0DB9C) : Colors.transparent,
            border: isFilled
                ? null
                : Border.all(color: Colors.grey.shade400, width: 1.5),
          ),
        );
      }),
    );
  }
}

// Custom Num Pad
class CustomNumpad extends StatelessWidget {
  final Function(String) onNumberPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onBiometricsPressed;

  const CustomNumpad({
    super.key,
    required this.onNumberPressed,
    required this.onDeletePressed,
    required this.onBiometricsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          _buildNumberRow(['1', '2', '3']),
          const SizedBox(height: 20),
          _buildNumberRow(['4', '5', '6']),
          const SizedBox(height: 20),
          _buildNumberRow(['7', '8', '9']),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildIconButton(
                icon: Icons.fingerprint,
                onPressed: onBiometricsPressed,
              ),
              _buildNumberButton('0'),
              _buildIconButton(
                icon: Icons.backspace,
                onPressed: onDeletePressed,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((num) => _buildNumberButton(num)).toList(),
    );
  }

  Widget _buildNumberButton(String number) {
    return InkWell(
      onTap: () => onNumberPressed(number),
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 70,
        height: 70,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFF5F5F5),
        ),
        child: Center(
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 24,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: Color(0xFF607D8B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        child: Icon(icon, size: 28, color: Colors.black87),
      ),
    );
  }
}
