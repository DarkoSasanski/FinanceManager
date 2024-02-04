import 'package:financemanager/models/Account.dart';

import 'Category.dart';

class Expense {
  String description;
  int amount;
  DateTime date;
  Account account;
  Category category;

  Expense(
      {required this.description,
      required this.amount,
      required this.date,
      required this.account,
      required this.category});
}
