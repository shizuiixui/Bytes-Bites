import 'package:bytes_and_bites/core/widgets/main_navigation.dart';
import 'package:bytes_and_bites/features/inventory/screens/add_inventory_page.dart';
import 'package:bytes_and_bites/features/inventory/screens/inventory_page.dart';
import 'package:bytes_and_bites/features/subscriptions/screens/add_subscription_page.dart';
import 'package:bytes_and_bites/features/transactions/screens/add_expense_page.dart';
import 'package:bytes_and_bites/features/transactions/screens/expense_page.dart';
import 'package:flutter/material.dart';

// Landing Page
import '/features/auth/presentation/screens/landing_page.dart';

// Name Setup
import '/features/auth/presentation/screens/name_setup_screen.dart';

// Password Setup
import '/features/auth/presentation/screens/password_setup_screen.dart';

class AppRouter {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      'landing_page': (context) => const LandingPage(),
      'name_setup': (context) => const NameSetupScreen(),
      'password_setup': (context) => const PasswordSetupScreen(),

      'homepage': (context) => const MainNavigation(),
      'expense': (context) => const ExpensePage(),
      'inventory': (context) => const InventoryPage(),
      // 'profile': (context) => const ProfilePage(),

      'add_expense': (context) => const AddExpensePage(),
      'add_subscription': (context) => const AddSubscriptionPage(),
      'add_inventory': (context) => const AddInventoryPage(),
    };
  }
}
