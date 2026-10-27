import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:bytes_and_bites/models/subscription_model.dart';
import 'package:bytes_and_bites/core/services/hive_box_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    'subscription_alerts',
    'Subscription Alerts',
    channelDescription: 'Reminders for upcoming subscription bills',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
  );

  static const DarwinNotificationDetails _darwinNotificationDetails =
      DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  static const NotificationDetails _notificationDetails = NotificationDetails(
    android: _androidNotificationDetails,
    iOS: _darwinNotificationDetails,
  );

  Future<void> init() async {
    // Initialize Timezones
    tz.initializeTimeZones();
    try {
      final String currentTimeZone = DateTime.now().timeZoneName;
      tz.setLocalLocation(tz.getLocation(currentTimeZone));
    } catch (_) {
      // Fallback if timezone abbreviation is not in standard database
    }

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
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();
  }

  // Show immediate notification
  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await flutterLocalNotificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: _notificationDetails,
    );
  }

  // Cancel alerts for a subscription
  Future<void> cancelSubscriptionAlerts(String subName) async {
    final baseId = subName.hashCode & 0x7FFFFFF0;
    await flutterLocalNotificationsPlugin.cancel(id: baseId + 1);
    await flutterLocalNotificationsPlugin.cancel(id: baseId + 2);
    await flutterLocalNotificationsPlugin.cancel(id: baseId + 3);
    await flutterLocalNotificationsPlugin.cancel(id: baseId + 4);
  }

  // Schedule or trigger subscription alerts for 7 days, 3 days, 1 day, and due date
  Future<void> scheduleSubscriptionAlerts(
    SubscriptionModel sub, {
    bool forceInstant = false,
  }) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final billingDate = DateTime(
      sub.nextBillingDate.year,
      sub.nextBillingDate.month,
      sub.nextBillingDate.day,
    );

    final daysUntilDue = billingDate.difference(today).inDays;
    final baseId = sub.name.hashCode & 0x7FFFFFF0;

    final amountStr = sub.amount.truncateToDouble() == sub.amount
        ? sub.amount.toInt().toString()
        : sub.amount.toStringAsFixed(2);

    // 1. Seven Days Before
    await _handleAlert(
      id: baseId + 1,
      title: "Upcoming Bill: ${sub.name}",
      body: "Your ₱$amountStr subscription is due in 7 days.",
      intervalDays: 7,
      billingDate: billingDate,
      daysUntilDue: daysUntilDue,
      now: now,
      today: today,
      subName: sub.name,
      forceInstant: forceInstant,
    );

    // 2. Three Days Before
    await _handleAlert(
      id: baseId + 2,
      title: "Bill Reminder: ${sub.name}",
      body: "Your ₱$amountStr subscription is due in 3 days.",
      intervalDays: 3,
      billingDate: billingDate,
      daysUntilDue: daysUntilDue,
      now: now,
      today: today,
      subName: sub.name,
      forceInstant: forceInstant,
    );

    // 3. One Day Before
    await _handleAlert(
      id: baseId + 3,
      title: "Bill Due Tomorrow: ${sub.name}",
      body: "Don't forget! Your ₱$amountStr subscription is due tomorrow.",
      intervalDays: 1,
      billingDate: billingDate,
      daysUntilDue: daysUntilDue,
      now: now,
      today: today,
      subName: sub.name,
      forceInstant: forceInstant,
    );

    // 4. Due Today
    await _handleAlert(
      id: baseId + 4,
      title: "Bill Due Today: ${sub.name}",
      body: "Don't forget! Your ₱$amountStr subscription is due today.",
      intervalDays: 0,
      billingDate: billingDate,
      daysUntilDue: daysUntilDue,
      now: now,
      today: today,
      subName: sub.name,
      forceInstant: forceInstant,
    );
  }

  Future<void> _handleAlert({
    required int id,
    required String title,
    required String body,
    required int intervalDays,
    required DateTime billingDate,
    required int daysUntilDue,
    required DateTime now,
    required DateTime today,
    required String subName,
    required bool forceInstant,
  }) async {
    final reminderDate = billingDate.subtract(Duration(days: intervalDays));
    final scheduledDate = DateTime(
      reminderDate.year,
      reminderDate.month,
      reminderDate.day,
      10,
      0,
    );

    if (scheduledDate.isAfter(now)) {
      // Future date & time: schedule zoned notification
      await _schedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
      );
    } else if (daysUntilDue == intervalDays) {
      // It is due today (e.g. 1 day before due date is today), but 10 AM has passed or user added it today.
      final key = 'notif_sent_${id}_${today.year}_${today.month}_${today.day}';
      bool alreadySent = false;
      if (Hive.isBoxOpen(HiveBoxManager.settingsBoxName)) {
        final box = Hive.box(HiveBoxManager.settingsBoxName);
        alreadySent = box.get(key, defaultValue: false) as bool;
      }

      if (!alreadySent || forceInstant) {
        await showInstantNotification(
          id: id,
          title: title,
          body: body,
        );
        if (Hive.isBoxOpen(HiveBoxManager.settingsBoxName)) {
          final box = Hive.box(HiveBoxManager.settingsBoxName);
          await box.put(key, true);
        }
      }
    }
  }

  Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // Reschedule all subscriptions for the current user
  Future<void> rescheduleAllSubscriptions() async {
    try {
      final box = HiveBoxManager.subscriptionsBox();
      for (final sub in box.values) {
        await scheduleSubscriptionAlerts(sub);
      }
    } catch (_) {
      // Subscription box not open or not ready
    }
  }
}
