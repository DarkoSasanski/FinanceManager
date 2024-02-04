import 'package:flutter/cupertino.dart';

import 'Expense.dart';

class Category {
  String name;
  Color color;
  IconData icon;
  List<Expense>? expenses;

  Category({required this.name, required this.color, required this.icon, this.expenses});

  addExpense(Expense expense) {
    expenses?.add(expense);
  }
}
