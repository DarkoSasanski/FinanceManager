import 'package:financemanager/components/buttons/add_expense_app_bar_button.dart';
import 'package:financemanager/helpers/database_helper.dart';
import 'package:flutter/material.dart';

import '../components/appBar/custom_app_bar.dart';
import '../components/notifications/account_expense.dart';
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
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Expense> expenses = [];
  List<Category> categories = [];
  List<Account> accounts = [];
  int? _selectedCategory;
  int? _selectedAccount;
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadAllExpenses();
    _loadCategories();
    _loadAccounts();
  }

  void _selectStartDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != startDate) {
      setState(() {
        startDate = pickedDate;
      });
      _loadAllExpenses();
    }
  }

  void _selectEndDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != endDate) {
      setState(() {
        endDate = pickedDate;
      });
      _loadAllExpenses();
    }
  }

  void updateSelectedAccount(int? accountId) {
    setState(() {
      _selectedAccount = accountId;
    });
    _loadAllExpenses();
  }

  void _loadAccounts() async {
    final accountRepository = await _databaseHelper.accountRepository();
    final loadedAccounts = await accountRepository.findAll();
    setState(() {
      accounts = loadedAccounts;
    });
  }

  List<DropdownMenuItem<Object>>? getAccountsDropdown() {
    List<DropdownMenuItem<Object>>? items = [];
    items.add(const DropdownMenuItem(
      value: null,
      child: Text("All accounts"),
    ));
    for (var account in accounts) {
      items.add(DropdownMenuItem(
        value: account.id,
        child: Text(account.name),
      ));
    }
    return items;
  }

  void _loadCategories() async {
    final categoryRepository = await _databaseHelper.categoryRepository();
    final loadedCategories = await categoryRepository.findAll();
    setState(() {
      categories = loadedCategories;
    });
  }

  List<DropdownMenuItem<Object>>? getCategoriesDropdown() {
    List<DropdownMenuItem<Object>>? items = [];
    items.add(const DropdownMenuItem(
      value: null,
      child: Text("All categories"),
    ));
    for (var category in categories) {
      items.add(DropdownMenuItem(
        value: category.id,
        child: Text(category.name),
      ));
    }
    return items;
  }

  void updateSelectedCategory(int? categoryId) {
    setState(() {
      _selectedCategory = categoryId;
    });
    _loadAllExpenses();
  }

  Future<void> _loadAllExpenses() async {
    final expenseRepository = await _databaseHelper.expenseRepository();
    List<Expense> loadedExpenses = await expenseRepository.findByFilter(
        _selectedCategory, _selectedAccount, startDate, endDate);
    setState(() {
      expenses = loadedExpenses;
    });
  }

  Future<void> _addExpense(String description, int amount, DateTime date,
      Account account, Category category) async {
    final accountRepository = await _databaseHelper.accountRepository();
    final expenseRepository = await _databaseHelper.expenseRepository();

    Expense expense = Expense(
      description: description,
      amount: amount,
      date: date,
      account: account,
      category: category,
    );
    await expenseRepository.insertExpense(expense);

    account.amount -= amount;
    await accountRepository.updateAmount(account);

    setState(() {
      expenses.add(expense);
    });
    showAccountExpenseNotification(account.name, account.amount);
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
      body: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton(
              padding: const EdgeInsets.only(left: 16),
              value: _selectedCategory,
              underline: Container(),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: getCategoriesDropdown(),
              onChanged: (value) => updateSelectedCategory(value as int?),
              hint: const Text('Select category',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.normal)),
            ),
            DropdownButton(
              padding: const EdgeInsets.only(right: 16),
              value: _selectedAccount,
              underline: Container(),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: getAccountsDropdown(),
              onChanged: (value) => updateSelectedAccount(value as int?),
              hint: const Text('Select account',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.normal)),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: ListTile(
              title: const Text('Start Date',
                  style: TextStyle(color: Colors.white)),
              trailing: GestureDetector(
                onTap: () => _selectStartDate(context),
                child: Text(
                  '${startDate.day}/${startDate.month}/${startDate.year}',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            )),
            Expanded(
                child: ListTile(
              title:
                  const Text('End Date', style: TextStyle(color: Colors.white)),
              trailing: GestureDetector(
                onTap: () => _selectEndDate(context),
                child: Text(
                  '${endDate.day}/${endDate.month}/${endDate.year}',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            )),
          ],
        ),
        Expanded(
          child: ListView.builder(
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
        )
      ]),
    );
  }
}
