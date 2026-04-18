import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
part 'inventory_model.g.dart';

@HiveType(typeId: 1)
class InventoryModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int quantity;

  @HiveField(2)
  String categoryName;

  @HiveField(3)
  int lowStockThreshold;

  InventoryModel({
    required this.name,
    required this.quantity,
    required this.categoryName,
    this.lowStockThreshold = 5,
  });

  // Text Status
  String get status {
    if (quantity == 0) return "Out of Stock";
    if (quantity <= lowStockThreshold) return "Low Stock";
    return "In Stock";
  }

  // Color Status
  Color get statusColor {
    if (quantity == 0) return const Color(0xFFE57373);
    if (quantity <= lowStockThreshold) return const Color(0xFFFFB74D);
    return const Color(0xFFB0DB9C);
  }
}