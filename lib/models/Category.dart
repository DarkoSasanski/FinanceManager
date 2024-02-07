import 'package:flutter/cupertino.dart';

import 'Expense.dart';

class Category {
  int id = 0;
  String name;
  Color color;
  IconData icon;
  List<Expense>? expenses;

  Category(
      {required this.name,
      required this.color,
      required this.icon,
      this.expenses});

  Category.withId(
      {required this.id,
      required this.name,
      required this.color,
      required this.icon,
      this.expenses});

  addExpense(Expense expense) {
    expenses?.add(expense);
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category.withId(
        id: json['id'],
        name: json['name'],
        color: Color(json['color']),
        icon: IconData(
          json['codePoint'],
          fontFamily: json['fontFamily'],
          fontPackage: json['fontPackage'] ?? '',
          matchTextDirection: json['matchTextDirection'],
        ),
        expenses: json['expenses'] != null
            ? (json['expenses'] as List)
                .map((i) => Expense.fromJson(i))
                .toList()
            : null);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color.value,
      'codePoint': icon.codePoint,
      'fontFamily': icon.fontFamily,
      'fontPackage': 'cupertino_icons',
      'matchTextDirection': icon.matchTextDirection,
    };
  }
}
