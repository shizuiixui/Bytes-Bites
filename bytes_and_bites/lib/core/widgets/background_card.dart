import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemCard extends StatelessWidget {
  final String title;
  final String subtitle; 
  final Color color;
  final BoxShadow boxShadow;
  final int price;
  final String imagePath;
  final Color subtitleColor;

  const ItemCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.boxShadow,
    required this.price,
    required this.imagePath,
    this.subtitleColor = const Color(0xFFFF6B6B), 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [boxShadow],
      ),
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          // Logo/Image
          Container(
            width: 45.w,
            height: 45.w,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            clipBehavior: Clip.antiAlias,
            child: imagePath.isNotEmpty
                ? Image.asset(imagePath, fit: BoxFit.cover)
                : Icon(Icons.receipt_long_rounded, color: Colors.grey.shade400, size: 24.sp),
          ),
          SizedBox(width: 16.w),

          // Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle, 
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ),

          // Price and Arrow
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "₱$price",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14.sp, 
                color: Colors.grey.shade400
              ),
            ],
          ),
        ],
      ),
    );
  }
}