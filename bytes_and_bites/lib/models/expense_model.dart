import 'package:hive/hive.dart';
part 'expense_model.g.dart'; 

@HiveType(typeId: 0)
class ExpenseModel extends HiveObject {
  @HiveField(0)
  String description;

  @HiveField(1)
  double amount;

  @HiveField(2)
  String categoryName;

  @HiveField(3)
  DateTime date;

  ExpenseModel({
    required this.description,
    required this.amount,
    required this.categoryName,
    required this.date,
  });
}