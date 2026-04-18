import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:bytes_and_bites/models/subscription_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize Timezones
    tz.initializeTimeZones();

    // Setup Android and iOS settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );
  }

  // Helper to request permission
  Future<void> requestPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  // Subscription Core Logic Scheduler
  Future<void> scheduleSubscriptionAlerts(SubscriptionModel sub) async {
    final billingDate = sub.nextBillingDate;

    final targetTime = DateTime(
      billingDate.year,
      billingDate.month,
      billingDate.day,
      10,
      0,
    );

    // Calculate our 3 warning dates
    final oneWeekBefore = targetTime.subtract(const Duration(days: 7));
    final threeDaysBefore = targetTime.subtract(const Duration(days: 3));
    final oneDayBefore = targetTime.subtract(const Duration(days: 1));
    final baseId = sub.name.hashCode;

    // Schedule 1 Week Before
    if (oneWeekBefore.isAfter(DateTime.now())) {
      await _schedule(
        id: baseId + 1,
        title: "Upcoming Bill: ${sub.name}",
        body: "Your ₱${sub.amount} subscription is due in 1 week.",
        scheduledDate: oneWeekBefore,
      );
    }

    // Schedule 3 Days Before
    if (threeDaysBefore.isAfter(DateTime.now())) {
      await _schedule(
        id: baseId + 2,
        title: "Bill Reminder: ${sub.name}",
        body: "Your ₱${sub.amount} subscription is due in 3 days.",
        scheduledDate: threeDaysBefore,
      );
    }

    // Schedule 1 Day Before
    if (oneDayBefore.isAfter(DateTime.now())) {
      await _schedule(
        id: baseId + 3,
        title: "Bill Due Tomorrow: ${sub.name}",
        body: "Don't forget! Your ₱${sub.amount} subscription is due tomorrow.",
        scheduledDate: oneDayBefore,
      );
    }
  }

  Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'subscription_alerts',
          'Subscription Alerts',
          channelDescription: 'Reminders for upcoming subscription bills',
          importance: Importance.max,
          priority: Priority.high,
        );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }
}
