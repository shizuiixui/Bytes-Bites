import 'package:flutter/material.dart';

// Expense Category
class ExpenseCategory {
  final String name;
  final IconData icon;

  const ExpenseCategory({
    required this.name,
    required this.icon
  });
}

final List<ExpenseCategory> expenseCategories = [
  ExpenseCategory(
    name: 'Food & Dining', 
    icon: Icons.restaurant_rounded
  ),
  ExpenseCategory(
    name: 'Transportation', 
    icon: Icons.directions_car_rounded
  ),
  ExpenseCategory(
    name: 'Housing', 
    icon: Icons.home_rounded
  ),
  ExpenseCategory(
    name: 'Utilities', 
    icon: Icons.light_mode_rounded
  ),
  ExpenseCategory(
    name: 'Entertainment', 
    icon: Icons.movie_rounded
  ),
  ExpenseCategory(
    name: 'Health & Fitness', 
    icon: Icons.fitness_center_rounded
  ),
  ExpenseCategory(
    name: 'Education', 
    icon: Icons.school_rounded
  ),
  ExpenseCategory(
    name: 'Personal Care', 
    icon: Icons.spa_rounded
  ),
  ExpenseCategory(
    name: 'Shopping', 
    icon: Icons.shopping_bag_rounded
  ),
  ExpenseCategory(
    name: 'Travel', 
    icon: Icons.flight_rounded
  ),
  ExpenseCategory(
    name: 'Groceries', 
    icon: Icons.local_grocery_store_rounded
  ),
  ExpenseCategory(
    name: 'Other', 
    icon: Icons.category_rounded
  ),
];

// Subscription Category
class SubscriptionCategory {
  final String name;
  final IconData icon;

  const SubscriptionCategory({
    required this.name,
    required this.icon
  });
}

final List<SubscriptionCategory> subscriptionCategories = [
  SubscriptionCategory(
    name: 'Streaming & Media',
    icon: Icons.play_circle_rounded,
  ),
  SubscriptionCategory(
    name: 'Software & Apps',
    icon: Icons.computer_rounded,
  ),
  SubscriptionCategory(
    name: 'Game',
    icon: Icons.sports_esports_rounded,
  ),
  SubscriptionCategory(
    name: 'Internet & Communication',
    icon: Icons.router_rounded,
  ),
  SubscriptionCategory(
    name: 'Health & Fitness',
    icon: Icons.fitness_center_rounded,
  ),
  SubscriptionCategory(
    name: 'Education & Learning',
    icon: Icons.school_rounded,
  ),
  SubscriptionCategory(
    name: 'Other',
    icon: Icons.category_rounded,
  ),
];

// Inventory Category
class InventoryCategory {
  final String name;
  final IconData icon;

  const InventoryCategory({
    required this.name,
    required this.icon,
  });
}

final List<InventoryCategory> inventoryCategories = [
  InventoryCategory(
    name: 'Pantry & Dry Goods',
    icon: Icons.kitchen_rounded,
  ),
  InventoryCategory(
    name: 'Fresh Food & Perishables', 
    icon: Icons.egg_rounded
    ),
  InventoryCategory(
    name: 'Snacks & Beverages', 
    icon: Icons.local_cafe_rounded
  ),
  InventoryCategory(
    name: 'Personal Care & Toiletries',
    icon: Icons.soap_rounded,
  ),
  InventoryCategory(
    name: 'Cleaning Supplies',
    icon: Icons.cleaning_services_rounded,
  ),
  InventoryCategory(
    name: 'Pet Supplies',
    icon: Icons.pets_rounded,
  ),
  InventoryCategory(
    name: 'Stationery & School Supplies',
    icon: Icons.edit_rounded,
  ),
  InventoryCategory(
    name: 'Other',
    icon: Icons.category_rounded,
  ),
];
