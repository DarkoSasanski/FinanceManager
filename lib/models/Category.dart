import 'Expense.dart';
import 'Income.dart';

class Category {
  String name;
  List<Income>? incomes;
  List<Expense>? expenses;

  Category({required this.name, this.incomes, this.expenses});

  addIncome(Income income) {
    incomes?.add(income);
  }

  addExpense(Expense expense) {
    expenses?.add(expense);
  }
}
