import 'Expense.dart';
import 'Income.dart';
import 'Plan.dart';

class Account {
  String name;
  int amount;
  List<Plan> plans;
  List<Income> incomes;
  List<Expense> expenses;

  Account({required this.name, required this.amount, required this.plans, required this.incomes, required this.expenses});
}
