import 'package:flutter/cupertino.dart';

import 'Expense.dart';
import 'Income.dart';

class Category {
  String name;
  Color color;
  IconData icon;
  List<Income>? incomes;
  List<Expense>? expenses;

  Category(
      {required this.name,
      required this.color,
      required this.icon,
      this.incomes,
      this.expenses});

  addIncome(Income income) {
    incomes?.add(income);
  }

  addExpense(Expense expense) {
    expenses?.add(expense);
  }
}
