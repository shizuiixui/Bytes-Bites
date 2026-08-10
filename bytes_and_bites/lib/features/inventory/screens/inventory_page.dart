import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bytes_and_bites/core/services/hive_box_manager.dart';

import 'package:bytes_and_bites/models/inventory_model.dart';
import 'package:bytes_and_bites/features/inventory/widgets/inventory_card.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final TextEditingController _searchController = TextEditingController();
  
  // Filtering States
  final List<String> _filters = ["All", "In Stock", "Low Stock", "Out of Stock"];
  String _selectedFilter = "All";
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Inventory",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Colors.black87,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar & Filter Icon
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    style: TextStyle(fontSize: 14.sp, fontFamily: 'Inter'),
                    decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      prefixIcon: Icon(Icons.search_rounded, color: Colors.black87, size: 22.sp),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.r), borderSide: BorderSide(color: Colors.grey.shade200)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.r), borderSide: BorderSide(color: Colors.grey.shade200)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.r), borderSide: const BorderSide(color: Color(0xFFB0DB9C), width: 1.5)),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.filter_alt_outlined, color: Colors.black87, size: 22.sp),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),

          // Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: ChoiceChip(
                    label: Text(filter),
                    labelStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.sp,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedFilter = filter);
                    },
                    backgroundColor: Colors.white,
                    selectedColor: const Color(0xFFB0DB9C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey.shade300),
                    ),
                    showCheckmark: false,
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  ),
                );
              }).toList(),
            ),
          ),
          
          SizedBox(height: 10.h),

          // Live Inventory List
          Expanded(
            child: ValueListenableBuilder<Box<InventoryModel>>(
              // Listen to the Hive box for changes
              valueListenable: HiveBoxManager.inventoryBox().listenable(),
              builder: (context, box, _) {
                final allItems = box.values.toList();
                
                // Apply search and chip filters
                final filteredItems = allItems.where((item) {
                  final matchesSearch = item.name.toLowerCase().contains(_searchQuery.toLowerCase());
                  
                  bool matchesFilter = true;
                  if (_selectedFilter == "In Stock") matchesFilter = item.status == "In Stock";
                  if (_selectedFilter == "Low Stock") matchesFilter = item.status == "Low Stock";
                  if (_selectedFilter == "Out of Stock") matchesFilter = item.status == "Out of Stock";

                  return matchesSearch && matchesFilter;
                }).toList();

                if (filteredItems.isEmpty) {
                  return Center(
                    child: Text(
                      "No items found.",
                      style: TextStyle(fontFamily: 'Inter', color: Colors.grey.shade500, fontSize: 14.sp),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.only(bottom: 120.h),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    return InventoryCard(item: filteredItems[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}