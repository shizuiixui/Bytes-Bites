import 'package:bytes_and_bites/models/expense_model.dart';
import 'package:bytes_and_bites/models/inventory_model.dart';
import 'package:bytes_and_bites/models/subscription_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveBoxManager {
  static const String settingsBoxName = 'settingsBox';
  static const String expenseBoxBaseName = 'expensesBox';
  static const String inventoryBoxBaseName = 'inventoryBox';
  static const String subscriptionBoxBaseName = 'subscriptionsBox';

  static String _sanitizeUserName(String userName) {
    final sanitized = userName.trim().toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9]+'),
      '_',
    );
    return sanitized
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
  }

  static String _userScopeSuffix({String? userName}) {
    final settingsBox = Hive.box(settingsBoxName);
    final resolvedName =
        userName ??
        settingsBox.get('userName', defaultValue: 'guest') as String;
    final sanitized = _sanitizeUserName(resolvedName);
    return sanitized.isEmpty ? 'guest' : sanitized;
  }

  static String expenseBoxName({String? userName}) =>
      '${_userScopeSuffix(userName: userName)}_$expenseBoxBaseName';

  static String inventoryBoxName({String? userName}) =>
      '${_userScopeSuffix(userName: userName)}_$inventoryBoxBaseName';

  static String subscriptionBoxName({String? userName}) =>
      '${_userScopeSuffix(userName: userName)}_$subscriptionBoxBaseName';

  static Box<ExpenseModel> expensesBox({String? userName}) {
    return Hive.box<ExpenseModel>(expenseBoxName(userName: userName));
  }

  static Box<InventoryModel> inventoryBox({String? userName}) {
    return Hive.box<InventoryModel>(inventoryBoxName(userName: userName));
  }

  static Box<SubscriptionModel> subscriptionsBox({String? userName}) {
    return Hive.box<SubscriptionModel>(subscriptionBoxName(userName: userName));
  }

  static Future<void> openUserDataBoxes({String? userName}) async {
    final resolvedUserName =
        userName ??
        Hive.box(settingsBoxName).get('userName', defaultValue: 'guest')
            as String;
    final futures = <Future<void>>[];

    final expenseBox = expenseBoxName(userName: resolvedUserName);
    if (!Hive.isBoxOpen(expenseBox)) {
      futures.add(Hive.openBox<ExpenseModel>(expenseBox));
    }

    final inventoryBox = inventoryBoxName(userName: resolvedUserName);
    if (!Hive.isBoxOpen(inventoryBox)) {
      futures.add(Hive.openBox<InventoryModel>(inventoryBox));
    }

    final subscriptionBox = subscriptionBoxName(userName: resolvedUserName);
    if (!Hive.isBoxOpen(subscriptionBox)) {
      futures.add(Hive.openBox<SubscriptionModel>(subscriptionBox));
    }

    await Future.wait(futures);
  }

  static Future<void> closeUserDataBoxes({String? userName}) async {
    final resolvedUserName =
        userName ??
        Hive.box(settingsBoxName).get('userName', defaultValue: 'guest')
            as String;
    final boxNames = [
      expenseBoxName(userName: resolvedUserName),
      inventoryBoxName(userName: resolvedUserName),
      subscriptionBoxName(userName: resolvedUserName),
    ];

    for (final boxName in boxNames) {
      if (Hive.isBoxOpen(boxName)) {
        await Hive.box(boxName).close();
      }
    }
  }
}
