import 'Expense.dart';
import 'Income.dart';

class Category{
  String name;
  List<Income> incomes;
  List<Expense> expenses;

  Category({required this.name,required this.incomes,required this.expenses});
}