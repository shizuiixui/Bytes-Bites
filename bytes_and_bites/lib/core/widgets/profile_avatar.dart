import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String typedName;
  final VoidCallback onProfileTap;

  const ProfileAvatar({
    super.key,
    required this.typedName,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    String initial = 'A';
    if (typedName.isNotEmpty) {
      initial = typedName[0].toUpperCase();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: onProfileTap,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFB0DB9C),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Color(0xFFB0DB9C),
                  child: Text(
                    initial,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    )
                  )
                ),
              )
            )
          ],
        )
      ],
    );
  }
}