import 'package:financemanager/models/Account.dart';

import 'Category.dart';

class Expense {
  int id = 0;
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

  Expense.withId(
      {required this.id,
      required this.description,
      required this.amount,
      required this.date,
      required this.account,
      required this.category});

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense.withId(
        id: json['id'],
        description: json['description'],
        amount: json['amount'],
        date: DateTime.parse(json['date']),
        account: Account.fromJson(json['account']),
        category: Category.fromJson(json['category']));
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'account_id': account.id,
      'category_id': category.id,
    };
  }
}
