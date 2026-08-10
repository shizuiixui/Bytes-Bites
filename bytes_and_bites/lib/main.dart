import 'package:bytes_and_bites/core/widgets/splash_screen.dart';
import 'package:bytes_and_bites/models/inventory_model.dart';
import 'package:bytes_and_bites/models/subscription_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/routes/app_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bytes_and_bites/models/expense_model.dart';
import 'package:bytes_and_bites/core/services/notification_service.dart';
import 'package:bytes_and_bites/core/services/hive_box_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  
  // Register adapters
  Hive.registerAdapter(ExpenseModelAdapter());
  Hive.registerAdapter(InventoryModelAdapter());
  Hive.registerAdapter(SubscriptionModelAdapter());
  
  // Open Boxes
  await Hive.openBox('settingsBox');

  final settingsBox = Hive.box('settingsBox');
  final isFirstTime = settingsBox.get('is_first_time', defaultValue: true) as bool;

  if (!isFirstTime) {
    await HiveBoxManager.openUserDataBoxes();
  }

  // Initialize Notifications
  final notifService = NotificationService();
  await notifService.init();
  await notifService.requestPermissions();

  runApp(const BytesAndBitesApp());
}

class BytesAndBitesApp extends StatelessWidget {
  const BytesAndBitesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Bytes & Bites',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFB0DB9C),
            ),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
          routes: AppRouter.getRoutes(),
        );
      },
    );
  }
}
