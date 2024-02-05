import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  DateTime selectedDate = DateTime.now();
  Category? selectedCategory;
  List<Category> availableCategories = [
    Category(name: "Groceries", color: Colors.white, icon: Icons.cabin),
    Category(name: "Utilities", color: Colors.white, icon: Icons.cabin),
    Category(name: "Entertainment", color: Colors.white, icon: Icons.cabin),
  ];
  String description = '';
  int amount = 0;
  Account? selectedAccount;
  List<Account> availableAccounts = [Account(name: "Test", amount: 150)];

  void _showAddExpenseDialog() {
    if (availableAccounts.isNotEmpty) {
      selectedAccount = availableAccounts[0];
    }

    if (availableCategories.isNotEmpty) {
      selectedCategory = availableCategories[0];
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color.fromRGBO(29, 31, 52, 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: StatefulBuilder(
                builder: (context, StateSetter setDialogState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Add Expense',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onChanged: (value) => description = value,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration('Description'),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onChanged: (value) => amount = int.tryParse(value) ?? 0,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration('Amount'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<Category>(
                        decoration: _inputDecoration('Category'),
                        dropdownColor: const Color.fromRGBO(29, 31, 52, 1),
                        value: selectedCategory,
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.grey),
                        items: availableCategories
                            .map<DropdownMenuItem<Category>>(
                                (Category category) {
                          return DropdownMenuItem<Category>(
                            value: category,
                            child: Text(category.name,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          );
                        }).toList(),
                        onChanged: (Category? newValue) {
                          setDialogState(() {
                            selectedCategory = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<Account>(
                        decoration: _inputDecoration('Account'),
                        dropdownColor: const Color.fromRGBO(29, 31, 52, 1),
                        value: selectedAccount,
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.grey),
                        items: availableAccounts
                            .map<DropdownMenuItem<Account>>((Account account) {
                          return DropdownMenuItem<Account>(
                            value: account,
                            child: Text(account.name,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          );
                        }).toList(),
                        onChanged: (Account? newValue) {
                          setDialogState(() {
                            selectedAccount = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      _datePicker(setDialogState),
                      const SizedBox(height: 20),
                      _actionButtons(context, setDialogState),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[350]),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[350]!)),
      focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.tealAccent)),
    );
  }

  Widget _datePicker(StateSetter setDialogState) {
    return ListTile(
      title: const Text('Date', style: TextStyle(color: Colors.white)),
      trailing: GestureDetector(
        onTap: () => _selectDate(context, setDialogState),
        child: Text(
          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, StateSetter setDialogState) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setDialogState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Widget _actionButtons(BuildContext context, StateSetter setDialogState) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      TextButton(
        child: const Text('Cancel', style: TextStyle(color: Colors.white)),
        onPressed: () => Navigator.of(context).pop(),
      ),
      TextButton(
        onPressed: () {
          if (description.isNotEmpty &&
              amount > 0 &&
              selectedCategory != null &&
              selectedAccount != null) {
            _addExpense(description, amount, selectedDate, selectedAccount!,
                selectedCategory!);
            description = '';
            amount = 0;
            selectedAccount = null;
            Navigator.of(context).pop();
          }
        },
        child: const Text('OK', style: TextStyle(color: Colors.tealAccent)),
      ),
    ]);
  }

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
        actionButtonText: "Add Expense",
        actionButtonOnPressed: _showAddExpenseDialog,
      ),
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
