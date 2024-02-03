import 'Expense.dart';
import 'Income.dart';
import 'Plan.dart';

class Account {
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

  addPlan(Plan plan) {
    plans?.add(plan);
  }

  addIncome(Income income) {
    incomes?.add(income);
  }

  addExpense(Expense expense) {
    expenses?.add(expense);
  }
}
