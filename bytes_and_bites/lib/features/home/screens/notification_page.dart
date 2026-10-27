import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bytes_and_bites/core/services/hive_box_manager.dart';
import 'package:bytes_and_bites/models/inventory_model.dart';
import 'package:bytes_and_bites/models/subscription_model.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Fetch the settings box
  final Box _settingsBox = Hive.box(HiveBoxManager.settingsBoxName);

  List<String> get _readNotifs =>
      _settingsBox
          .get('readNotifications', defaultValue: <String>[])
          ?.cast<String>() ??
      [];

  void _markAsRead(String id) {
    final list = _readNotifs;
    if (!list.contains(id)) {
      list.add(id);
      _settingsBox.put('readNotifications', list);
      setState(() {});
    }
  }

  void _markAllAsRead(List<String> currentIds) {
    final list = _readNotifs;
    for (String id in currentIds) {
      if (!list.contains(id)) {
        list.add(id);
      }
    }
    _settingsBox.put('readNotifications', list);
    setState(() {});
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
          "Notifications",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ValueListenableBuilder<Box<InventoryModel>>(
        valueListenable: HiveBoxManager.inventoryBox().listenable(),
        builder: (context, inventoryBox, _) {
          return ValueListenableBuilder<Box<SubscriptionModel>>(
            valueListenable: HiveBoxManager.subscriptionsBox().listenable(),
            builder: (context, subBox, _) {
              List<Widget> notificationTiles = [];
              List<String> currentNotificationIds = [];

              // Check for Low Stock Inventory
              for (var item in inventoryBox.values) {
                if (item.quantity <= item.lowStockThreshold) {
                  // Generate a unique ID for this specific alert
                  String notifId = 'inv_${item.key}_lowstock';
                  currentNotificationIds.add(notifId);

                  notificationTiles.add(
                    _buildNotificationTile(
                      icon: Icons.inventory_2_outlined,
                      iconColor: const Color(0xFFFFB74D),
                      title: "Low Stock Alert",
                      message:
                          "You only have ${item.quantity} ${item.name} left.",
                      timeSpan: "Inventory",
                      isRead: _readNotifs.contains(notifId),
                      onTap: () => _markAsRead(notifId),
                    ),
                  );
                }
              }

              // Check for Subscriptions Due Soon (7 days, 3 days, 1 day, and due today)
              for (var sub in subBox.values) {
                if (sub.daysUntilDue >= 0 && sub.daysUntilDue <= 7) {
                  String notifId =
                      'sub_${sub.key}_${sub.nextBillingDate.millisecondsSinceEpoch}';
                  currentNotificationIds.add(notifId);

                  String title;
                  String message;
                  if (sub.daysUntilDue == 0) {
                    title = "Bill Due Today";
                    message = "Your ₱${sub.amount} bill for ${sub.name} is due today.";
                  } else if (sub.daysUntilDue == 1) {
                    title = "Bill Due Tomorrow";
                    message = "Your ₱${sub.amount} bill for ${sub.name} is due tomorrow.";
                  } else {
                    title = "Upcoming Bill";
                    message =
                        "Your ₱${sub.amount} bill for ${sub.name} is due in ${sub.daysUntilDue} days.";
                  }

                  notificationTiles.add(
                    _buildNotificationTile(
                      icon: Icons.credit_card_outlined,
                      iconColor: const Color(0xFFE57373),
                      title: title,
                      message: message,
                      timeSpan: "Subscriptions",
                      isRead: _readNotifs.contains(notifId),
                      onTap: () => _markAsRead(notifId),
                    ),
                  );
                }
              }

              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).clearSnackBars();
              });

              return Column(
                children: [
                  // Read All Header
                  if (notificationTiles.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () =>
                                _markAllAsRead(currentNotificationIds),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              "Mark all as read",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF5A8C47),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (notificationTiles.isNotEmpty) SizedBox(height: 10.h),

                  // Empty State
                  Expanded(
                    child: notificationTiles.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(24.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 15.r,
                                        offset: Offset(0, 5.h),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.notifications_off_outlined,
                                    size: 60.sp,
                                    color: const Color(0xFFB0DB9C),
                                  ),
                                ),
                                SizedBox(height: 24.h),
                                Text(
                                  "You're all caught up!",
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  "No New Notifications Today.\nRelax and grab a bite!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: 'Inter',
                                    color: Colors.grey.shade500,
                                    height: 1.5,
                                  ),
                                ),
                                SizedBox(height: 100.h),
                              ],
                            ),
                          )
                        : ListView(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 0.h,
                            ),
                            children: notificationTiles,
                          ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  // UI Helper
  Widget _buildNotificationTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required String timeSpan,
    required bool isRead,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: isRead
                                  ? FontWeight.w600
                                  : FontWeight.bold,
                              fontFamily: 'Inter',
                              color: Colors.black87,
                            ),
                          ),
                          // --- THE RED DOT ---
                          if (!isRead) ...[
                            SizedBox(width: 8.w),
                            Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        timeSpan,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: 'Inter',
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
