import 'package:bytes_and_bites/core/widgets/profile_avatar.dart';
import 'package:bytes_and_bites/features/home/screens/notification_page.dart';
import 'package:bytes_and_bites/core/services/hive_box_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bytes_and_bites/models/expense_model.dart';
import 'package:bytes_and_bites/models/subscription_model.dart';
import 'package:bytes_and_bites/features/subscriptions/screens/add_subscription_page.dart';

// Home Header
class HomeHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onProfileTap;
  final DateTime currentDate;
  final VoidCallback onCalendarTap;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.onProfileTap,
    required this.currentDate,
    required this.onCalendarTap,
  });

  String _formatDate() {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return "${months[currentDate.month - 1]} ${currentDate.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ProfileAvatar(typedName: userName, onProfileTap: onProfileTap),

          // Calendar View
          GestureDetector(
            onTap: onCalendarTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_month_rounded,
                  size: 18.sp,
                  color: Colors.black87,
                ),
                SizedBox(width: 8.w),
                Text(
                  _formatDate(),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: 2.w),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20.sp,
                  color: Colors.black87,
                ),
              ],
            ),
          ),

          // Notification Icon
          ListenableBuilder(
            listenable: Listenable.merge([
              HiveBoxManager.inventoryBox().listenable(),
              HiveBoxManager.subscriptionsBox().listenable(),
              Hive.box(
                HiveBoxManager.settingsBoxName,
              ).listenable(keys: ['readNotifications']),
            ]),
            builder: (context, child) {
              bool hasUnread = false;
              final settingsBox = Hive.box(HiveBoxManager.settingsBoxName);
              final readNotifs =
                  settingsBox
                      .get('readNotifications', defaultValue: <String>[])
                      ?.cast<String>() ??
                  [];

              // Check Inventory for unread alerts
              for (var item in HiveBoxManager.inventoryBox().values) {
                if (item.quantity <= item.lowStockThreshold) {
                  String notifId = 'inv_${item.key}_lowstock';
                  if (!readNotifs.contains(notifId)) {
                    hasUnread = true;
                    break;
                  }
                }
              }

              if (!hasUnread) {
                for (var sub in HiveBoxManager.subscriptionsBox().values) {
                  if (sub.daysUntilDue >= 0 && sub.daysUntilDue <= 3) {
                    String notifId =
                        'sub_${sub.key}_${sub.nextBillingDate.millisecondsSinceEpoch}';
                    if (!readNotifs.contains(notifId)) {
                      hasUnread = true;
                      break;
                    }
                  }
                }
              }

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationPage(),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(Icons.notifications_outlined, size: 25.sp),
                    ),

                    // Red Dot Indicator
                    if (hasUnread)
                      Positioned(
                        top: 12.h,
                        right: 12.w,
                        child: Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Total Spent
class TotalSpent extends StatelessWidget {
  final DateTime selectedMonth;

  const TotalSpent({super.key, required this.selectedMonth});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFB0DB9C),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Total Spent This Month",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'Poppins',
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              ValueListenableBuilder<Box<ExpenseModel>>(
                valueListenable: HiveBoxManager.expensesBox().listenable(),
                builder: (context, box, _) {
                  // Calculate the total for the selected month
                  double total = 0;
                  for (var expense in box.values) {
                    if (expense.date.month == selectedMonth.month &&
                        expense.date.year == selectedMonth.year) {
                      total += expense.amount;
                    }
                  }
                  final formatCurrency = NumberFormat("#,##0.00", "en_US");
                  final String amountStr = formatCurrency.format(total);

                  return Text(
                    "\u20B1 $amountStr",
                    style: TextStyle(
                      fontSize: 35.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Home Carousel (Upcoming Subscriptions)
class HomeCarousel extends StatefulWidget {
  const HomeCarousel({super.key});

  @override
  State<HomeCarousel> createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<HomeCarousel> {
  double _currentPage = 0;
  final PageController _pageController = PageController(viewportFraction: 0.85);

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (mounted) {
        setState(() => _currentPage = _pageController.page!);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  //  Delete Confirmation Dialog
  void _showDeleteConfirmation(BuildContext context, dynamic sub) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(
          "Delete Subscription",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        content: Text(
          "Are you sure you want to delete ${sub.name}? This action cannot be undone.",
          style: TextStyle(fontFamily: 'Inter', fontSize: 14.sp),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.grey, fontFamily: 'Inter'),
            ),
          ),
          TextButton(
            onPressed: () async {
              // Deletes the item from Hive
              await sub.delete();

              if (context.mounted) {
                Navigator.pop(context); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "${sub.name} Deleted",
                      style: const TextStyle(fontFamily: 'Inter'),
                    ),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.fixed,
                  ),
                );
              }
            },
            child: const Text(
              "Delete",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          child: Text(
            "Upcoming Subscriptions",
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Hive Listener
        ValueListenableBuilder<Box<SubscriptionModel>>(
          valueListenable: HiveBoxManager.subscriptionsBox().listenable(),
          builder: (context, box, _) {
            if (box.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_busy_rounded,
                        color: Colors.grey.shade400,
                        size: 30.sp,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "No upcoming subscriptions",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.grey.shade500,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Fetch and Sort Data
            final subscriptions = box.values.toList();
            subscriptions.sort(
              (a, b) => a.daysUntilDue.compareTo(b.daysUntilDue),
            );

            // Build carousel
            return Column(
              children: [
                SizedBox(
                  height: 150.h,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: subscriptions.length,
                    itemBuilder: (context, index) {
                      double relativePosition = index - _currentPage;
                      final sub = subscriptions[index];

                      // Dynamic Urgency Text
                      String dueText = sub.daysUntilDue == 0
                          ? "Due Today"
                          : sub.daysUntilDue < 0
                          ? "Overdue by ${sub.daysUntilDue.abs()} days"
                          : "Due in ${sub.daysUntilDue} days";

                      // Turns red if due within 3 days
                      Color dueColor = sub.daysUntilDue <= 3
                          ? const Color(0xFFE57373)
                          : Colors.grey.shade500;

                      return Transform(
                        transform: Matrix4.identity()
                          ..translate(relativePosition * -20.0)
                          ..scale(1 - (relativePosition.abs() * 0.1)),
                        child: Opacity(
                          opacity: (1 - (relativePosition.abs() * 0.3)).clamp(
                            0.0,
                            1.0,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.w),
                            child: Container(
                              padding: EdgeInsets.only(
                                left: 16.w,
                                right: 8.w,
                                top: 12.h,
                                bottom: 16.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10.r,
                                    offset: Offset(0, 4.h),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        sub.name,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Inter',
                                          color: Colors.black87,
                                        ),
                                      ),

                                      // 3-Dot Options Menu
                                      PopupMenuButton<String>(
                                        icon: Icon(
                                          Icons.more_vert_rounded,
                                          color: Colors.black,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                        color: Colors.white,
                                        onSelected: (value) {
                                          if (value == 'edit') {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddSubscriptionPage(
                                                      existingSubscription: sub,
                                                    ),
                                              ),
                                            );
                                          } else if (value == 'delete') {
                                            _showDeleteConfirmation(
                                              context,
                                              sub,
                                            );
                                          }
                                        },
                                        itemBuilder: (BuildContext context) => [
                                          PopupMenuItem(
                                            value: 'edit',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.edit_rounded,
                                                  color: Colors.black,
                                                  size: 20.sp,
                                                ),
                                                SizedBox(width: 8.w),
                                                const Text(
                                                  "Edit",
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 'delete',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.delete_rounded,
                                                  color: Colors.red.shade400,
                                                  size: 20.sp,
                                                ),
                                                SizedBox(width: 8.w),
                                                const Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "₱${sub.amount.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    dueText,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      color: dueColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 6.h),

                // Pagination Dots
                if (subscriptions.length > 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(subscriptions.length, (index) {
                      bool isActive = _currentPage.round() == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        width: isActive ? 20.w : 6.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFFB0DB9C)
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      );
                    }),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

// Section Header
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllTap;

  const SectionHeader({super.key, required this.title, this.onSeeAllTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          if (onSeeAllTap != null)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onSeeAllTap,
                borderRadius: BorderRadius.circular(4.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  child: Text(
                    "See All",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Inter',
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
