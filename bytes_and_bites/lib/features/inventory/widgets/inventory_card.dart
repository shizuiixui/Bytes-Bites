import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bytes_and_bites/models/inventory_model.dart';

class InventoryCard extends StatelessWidget {
  final InventoryModel item;

  const InventoryCard({super.key, required this.item});

  void _increment() {
    item.quantity++;
    item.save();
  }

  void _decrement() {
    if (item.quantity > 0) {
      item.quantity--;
      item.save();
    }
  }

  // --- DELETE CONFIRMATION ---
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            "Delete Item?",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          content: Text(
            "Are you sure you want to delete ${item.name}?",
            style: TextStyle(fontFamily: 'Inter', fontSize: 14.sp),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                final name = item.name;
                item.delete(); // Delete from Hive
                Navigator.pop(dialogContext); // Close Dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("$name deleted"),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              },
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // --- QUICK EDIT DIALOG ---
  void _showEditDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController(
      text: item.name,
    );

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            "Edit Item",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: "Item Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB0DB9C),
              ),
              onPressed: () {
                item.name = nameController.text.trim();
                item.save(); // Save changes to Hive
                Navigator.pop(dialogContext);
              },
              child: const Text(
                "Save",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      padding: EdgeInsets.only(left: 16.w, right: 8.w, top: 16.h, bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Stock: ${item.quantity}",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: 'Inter',
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  item.status,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    color: item.statusColor,
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: [
              // Quantity Pill
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.remove,
                        size: 20.sp,
                        color: Colors.black87,
                      ),
                      onPressed: _decrement,
                      constraints: BoxConstraints(
                        minWidth: 36.w,
                        minHeight: 36.w,
                      ),
                      padding: EdgeInsets.zero,
                      splashRadius: 18.r,
                    ),
                    Text(
                      item.quantity.toString(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, size: 20.sp, color: Colors.black87),
                      onPressed: _increment,
                      constraints: BoxConstraints(
                        minWidth: 36.w,
                        minHeight: 36.w,
                      ),
                      padding: EdgeInsets.zero,
                      splashRadius: 18.r,
                    ),
                  ],
                ),
              ),

              SizedBox(width: 4.w),

              // Overflow Menu
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: Colors.black87,
                  size: 24.sp,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                color: Colors.white,
                elevation: 4,
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditDialog(context);
                  } else if (value == 'delete') {
                    _showDeleteDialog(
                      context,
                    );
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_rounded,
                          size: 18.sp,
                          color: Colors.black87,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "Edit",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_rounded,
                          size: 18.sp,
                          color: Colors.redAccent,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "Delete",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.sp,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
