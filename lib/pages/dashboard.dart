import 'package:financemanager/components/appBar/custom_app_bar.dart';
import 'package:financemanager/components/buttons/add_expense_app_bar_button.dart';
import 'package:financemanager/components/dashboard/dashboard_pie_chart_slider.dart';
import 'package:flutter/material.dart';

import '../components/buttons/add_income_app_bar_button.dart';
import '../components/notifications/account_expense.dart';
import '../components/notifications/account_income.dart';
import '../components/sideMenu/side_menu.dart';
import '../helpers/database_helper.dart';
import '../models/Account.dart';
import '../models/Category.dart';
import '../models/Expense.dart';
import '../models/Income.dart';
import '../models/Month.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  int _selectedMonth = DateTime.now().month;
  Map<Category, String> categoryExpenses = {};
  List<Account> accounts = [];
  int? _selectedAccount;

  void updateSelectedMonth(int? index) {
    if (index == null) return;
    if (index <= 0) {
      index = months.length;
    }
    if (index > months.length) {
      index = 1;
    }
    setState(() {
      _selectedMonth = index!;
    });
    _loadCategoryExpenses();
  }

  void updateSelectedAccount(int? accountId) {
    setState(() {
      _selectedAccount = accountId;
    });
    _loadCategoryExpenses();
  }

  void _loadCategoryExpenses() async {
    final categoryRepository = await _databaseHelper.categoryRepository();
    final loadedCategoryExpenses =
        await categoryRepository.fetchCategoryExpensesByMonthAndAccount(
            _selectedMonth, _selectedAccount);
    setState(() {
      categoryExpenses = loadedCategoryExpenses;
    });
  }

  void _loadAccounts() async {
    final accountRepository = await _databaseHelper.accountRepository();
    final loadedAccounts = await accountRepository.findAll();
    setState(() {
      accounts = loadedAccounts;
    });
  }

  String getTotalSpending() {
    double total = 0;
    categoryExpenses.forEach((key, value) {
      total += double.parse(value);
    });
    return total.toString();
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

  String getBalance() {
    double total = 0;
    accounts.forEach((account) {
      if (_selectedAccount == null || _selectedAccount == account.id) {
        total += account.amount;
      }
    });
    return total.toString();
  }

  void _addIncome(String source, String description, int amount,
      bool isReceived, DateTime date, Account? account) async {
    if (account == null) return;
    final incomeRepository = await _databaseHelper.incomeRepository();
    final accountRepository = await _databaseHelper.accountRepository();
    final Income income = Income(
      source: source,
      description: description,
      amount: amount,
      isReceived: isReceived,
      date: date,
      account: account,
    );

    await incomeRepository.insertIncome(income);

    if (isReceived) {
      account.amount += amount;
      await accountRepository.updateAmount(account);
      showAccountIncomeNotification(income.account.name, income.account.amount);
    }

    _loadAccounts();
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

    showAccountExpenseNotification(account.name, account.amount);

    _loadAccounts();
    _loadCategoryExpenses();
  }

  @override
  void initState() {
    super.initState();
    _loadAccounts();
    _loadCategoryExpenses();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: CustomAppBar(
          title: "Dashboard",
          appBarButton: AddIncomeAppBarButton(
            onSubmitted: _addIncome,
            actionButtonText: "Add funds",
          ),
        ),
        drawer: const SideMenu(),
        body: Container(
          padding: const EdgeInsets.all(13),
          child: ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  DropdownButton(
                    value: _selectedAccount,
                    underline: Container(),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: getAccountsDropdown(),
                    onChanged: (value) => updateSelectedAccount(value as int?),
                    hint: const Text('Select account',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal)),
                  ),
                  DropdownButton(
                    value: _selectedMonth,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    underline: Container(),
                    items: months
                        .map((month) => DropdownMenuItem(
                              value: month.value,
                              child: Text(month.name),
                            ))
                        .toList(),
                    onChanged: (value) => updateSelectedMonth(value),
                    hint: const Text('Month',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal)),
                  ),
                ],
              ),
              const Text("Balance",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w500)),
              Text("${getBalance()}\$",
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  )),
              Divider(
                endIndent: screenWidth * 0.4,
                color: Colors.grey,
              ),
              DashboardPieChartSlider(
                selectedMonth: _selectedMonth,
                onMonthChanged: updateSelectedMonth,
                categoryExpenses: categoryExpenses,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  AddExpenseAppBarButton(
                      onSubmitted: _addExpense, actionButtonText: "Add Cost"),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      const Text("Spendings",
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                      Text("${getTotalSpending()}\$",
                          style: const TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ],
              ),
              Container(
                  padding: EdgeInsets.only(left: screenWidth * 0.4),
                  child: const Divider(
                    color: Colors.grey,
                  )),
              GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 10,
                ),
                itemCount: categoryExpenses.length,
                itemBuilder: (context, index) {
                  final category = categoryExpenses.keys.elementAt(index);
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: category.color,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(category.icon,
                              size: 25, color: Colors.white.withOpacity(0.4)),
                          const SizedBox(height: 4),
                          Text(
                            category.name,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "${categoryExpenses[category]}\$",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
