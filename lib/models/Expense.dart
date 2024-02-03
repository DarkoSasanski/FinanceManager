import 'package:financemanager/models/Account.dart';

class Expense {
  String description;
  int amount;
  DateTime date;
  Account account;

  Expense(
      {required this.description,
      required this.amount,
      required this.date,
      required this.account});
}
