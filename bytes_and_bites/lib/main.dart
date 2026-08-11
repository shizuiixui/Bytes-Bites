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

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(ExpenseModelAdapter());
  Hive.registerAdapter(InventoryModelAdapter());
  Hive.registerAdapter(SubscriptionModelAdapter());

  // Open Settings Box first to determine app state
  await Hive.openBox('settingsBox');
  final settingsBox = Hive.box('settingsBox');

  final isFirstTime =
      settingsBox.get('is_first_time', defaultValue: true) as bool;
  final String? savedPasscode = settingsBox.get('user_passcode');

  String initialRoute;

  // Check if the app is locked first
  if (savedPasscode != null && savedPasscode.isNotEmpty) {
    initialRoute = 'password_setup';
  }
  // Check if it's a new install
  else if (isFirstTime) {
    initialRoute = 'landing_page';
  }
  // Fallback (unlocked, existing user)
  else {
    await HiveBoxManager.openUserDataBoxes();
    initialRoute = 'homepage';
  }

  // Initialize Notifications
  final notifService = NotificationService();
  await notifService.init();
  await notifService.requestPermissions();

  runApp(BytesAndBitesApp(nextRoute: initialRoute));
}

class BytesAndBitesApp extends StatelessWidget {
  final String nextRoute;

  const BytesAndBitesApp({super.key, required this.nextRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return SessionManager(
          child: MaterialApp(
            navigatorKey: navigatorKey,
            title: 'Bytes & Bites',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFFB0DB9C),
              ),
              useMaterial3: true,
            ),
            home: SplashScreen(targetRoute: nextRoute),
            routes: AppRouter.getRoutes(),
          ),
        );
      },
    );
  }
}

// Session Manager to handle app lifecycle events
class SessionManager extends StatefulWidget {
  final Widget child;
  const SessionManager({super.key, required this.child});

  @override
  State<SessionManager> createState() => _SessionManagerState();
}

class _SessionManagerState extends State<SessionManager>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Start listening
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Stop listening
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final box = Hive.box('settingsBox');

    final savedPasscode = box.get('user_passcode');
    if (savedPasscode == null || savedPasscode.isEmpty) return;

    if (state == AppLifecycleState.paused) {
      box.put('last_active_time', DateTime.now().millisecondsSinceEpoch);
    } else if (state == AppLifecycleState.resumed) {
      final lastActiveTime = box.get('last_active_time');

      if (lastActiveTime != null) {
        final lastActive = DateTime.fromMillisecondsSinceEpoch(lastActiveTime);
        final difference = DateTime.now().difference(lastActive);

        if (difference.inMinutes >= 5) {
          box.put('is_logged_in', false);
          box.delete('last_active_time'); // Reset the timer

          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            'password_setup',
            (route) => false,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
