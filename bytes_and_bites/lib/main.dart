import 'package:bytes_and_bites/core/widgets/splash_screen.dart';
import 'package:flutter/material.dart';
import 'core/routes/app_router.dart';

void main() {
  runApp(const BytesAndBitesApp());
}

class BytesAndBitesApp extends StatelessWidget {
  const BytesAndBitesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bytes & Bites',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB0DB9C)),
        useMaterial3: true,
      ),

      home: const SplashScreen(),

      routes: AppRouter.getRoutes(),
    );
  }
}
