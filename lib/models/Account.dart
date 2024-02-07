import 'Expense.dart';
import 'Income.dart';
import 'Plan.dart';

class Account {
  int id = 0;
  String name;
  int amount;
  List<Plan>? plans;
  List<Income>? incomes;
  List<Expense>? expenses;

  Account(
      {required this.name,
      required this.amount,
      this.plans,
      this.expenses,
      this.incomes});

  Account.withId(
      {required this.id,
      required this.name,
      required this.amount,
      this.plans,
      this.expenses,
      this.incomes});

  addPlan(Plan plan) {
    plans?.add(plan);
  }

  addIncome(Income income) {
    incomes?.add(income);
  }

  addExpense(Expense expense) {
    expenses?.add(expense);
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account.withId(
        id: json['id'],
        name: json['name'],
        amount: json['amount'],
        plans: json['plans'] != null
            ? (json['plans'] as List).map((i) => Plan.fromJson(i)).toList()
            : null,
        incomes: json['incomes'] != null
            ? (json['incomes'] as List).map((i) => Income.fromJson(i)).toList()
            : null,
        expenses: json['expenses'] != null
            ? (json['expenses'] as List)
                .map((i) => Expense.fromJson(i))
                .toList()
            : null);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
    };
  }
}
