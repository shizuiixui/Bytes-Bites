import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildLabel(String text) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.h, top: 16.h),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Inter',
        color: Colors.black87,
      ),
    ),
  );
}

Widget buildTextField({
  required String hint,
  required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  Widget? prefixIcon,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    style: TextStyle(fontSize: 14.sp, fontFamily: 'Inter'),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
      ),
    ),
  );
}

Widget buildDropdownContainer({
  required String text,
  required IconData icon,
  required bool isHint,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'Inter',
            color: isHint ? Colors.grey.shade400 : Colors.black87,
          ),
        ),
        Icon(icon, color: Colors.grey.shade600, size: 20.sp),
      ],
    ),
  );
}

// Quantity Selector
Widget buildQuantitySelector({
  required int quantity,
  required VoidCallback onDecrement,
  required VoidCallback onIncrement,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.remove, size: 24.sp, color: Colors.black87),
          onPressed: onDecrement,
          splashRadius: 24.r,
        ),
        Text(
          quantity.toString(),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            color: Colors.black87,
          ),
        ),
        IconButton(
          icon: Icon(Icons.add, size: 24.sp, color: Colors.black87),
          onPressed: onIncrement,
          splashRadius: 24.r,
        ),
      ],
    ),
  );
}
