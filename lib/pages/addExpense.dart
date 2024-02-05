import 'package:financemanager/components/buttons/add_expense_app_bar_button.dart';
import 'package:flutter/material.dart';

import '../components/appBar/custom_app_bar.dart';
import '../components/sideMenu/side_menu.dart';
import '../models/Account.dart';
import '../models/Category.dart';
import '../models/Expense.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({Key? key}) : super(key: key);

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  List<Expense> expenses = [];

  void _addExpense(String description, int amount, DateTime date,
      Account account, Category category) {
    setState(() {
      Expense expense = Expense(
          description: description,
          amount: amount,
          date: date,
          account: account,
          category: category);
      expenses.add(expense);
      account.addExpense(expense);
      account.amount -= amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: "Expenses",
          appBarButton: AddExpenseAppBarButton(
            onSubmitted: _addExpense,
            actionButtonText: "Add Expense",
          )),
      drawer: const SideMenu(),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final expense = expenses[index];
          return Card(
            elevation: 4,
            color: Colors.deepPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    expense.category.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFcfd2d8),
                    ),
                  ),
                  Text(
                    expense.description,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Date: ${expense.date.day}/${expense.date.month}/${expense.date.year}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\$${expense.amount}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFcfd2d8),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() => runApp(const MaterialApp(home: ExpensesPage()));
