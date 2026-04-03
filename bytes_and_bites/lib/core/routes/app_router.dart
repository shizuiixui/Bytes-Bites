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
    };
  }
}