import 'package:hive/hive.dart';

part 'subscription_model.g.dart';

@HiveType(typeId: 2)
class SubscriptionModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final DateTime nextBillingDate;

  SubscriptionModel({
    required this.name,
    required this.amount,
    required this.nextBillingDate,
  });

  int get daysUntilDue {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(nextBillingDate.year, nextBillingDate.month, nextBillingDate.day);
    return dueDate.difference(today).inDays;
  }
}