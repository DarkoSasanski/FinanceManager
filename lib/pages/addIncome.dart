import 'package:financemanager/helpers/database_helper.dart';
import 'package:flutter/material.dart';

import '../components/appBar/custom_app_bar.dart';
import '../components/buttons/add_income_app_bar_button.dart';
import '../components/notifications/account_income.dart';
import '../components/sideMenu/side_menu.dart';
import '../models/Account.dart';
import '../models/Income.dart';

class IncomesPage extends StatefulWidget {
  const IncomesPage({Key? key}) : super(key: key);

  @override
  State<IncomesPage> createState() => _IncomesPageState();
}

class _IncomesPageState extends State<IncomesPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Income> incomes = [];
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();
  String dropdownFilter = 'All';
  List<Account> accounts = [];
  int? _selectedAccount;

  @override
  void initState() {
    super.initState();
    loadIncomes();
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
      loadIncomes();
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
      loadIncomes();
    }
  }

  void updateSelectedAccount(int? accountId) {
    setState(() {
      _selectedAccount = accountId;
    });
    loadIncomes();
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

  void loadIncomes() async {
    final incomeRepository = await _databaseHelper.incomeRepository();
    final List<Income> loadedIncomes = await incomeRepository.findByFilter(
        dropdownFilter, _selectedAccount, startDate, endDate);

    setState(() {
      incomes = loadedIncomes;
    });
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
    setState(() {
      incomes.add(income);
    });
  }

  void _markAsReceived(Income income) async {
    final incomeRepository = await _databaseHelper.incomeRepository();
    final accountRepository = await _databaseHelper.accountRepository();
    if (!income.isReceived) {
      income.isReceived = true;
      await incomeRepository.markAsReceived(income.id);

      income.account.amount += income.amount;
      await accountRepository.updateAccount(income.account);
      setState(() {});
      showAccountIncomeNotification(income.account.name, income.account.amount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Incomes",
        appBarButton: AddIncomeAppBarButton(
          onSubmitted: _addIncome,
          actionButtonText: "Add Income",
        ),
      ),
      drawer: const SideMenu(),
      body: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton(
                padding: const EdgeInsets.only(left: 16),
                value: dropdownFilter,
                items: const [
                  DropdownMenuItem(
                    value: 'All',
                    child: Text('All'),
                  ),
                  DropdownMenuItem(
                    value: 'Received',
                    child: Text('Received'),
                  ),
                  DropdownMenuItem(
                    value: 'Not Received',
                    child: Text('Not Received'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    dropdownFilter = value.toString();
                    loadIncomes();
                  });
                }),
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
          itemCount: incomes.length,
          itemBuilder: (context, index) {
            final income = incomes[index];
            return Card(
              elevation: 4,
              color: income.isReceived ? Colors.green : Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      income.source.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Date: ${income.date.day}/${income.date.month}/${income.date.year}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '\$${income.amount}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        if (income.isReceived)
                          const Icon(Icons.check, color: Colors.white)
                      ],
                    ),
                    if (!income.isReceived)
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: Colors.white, width: 1.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            _markAsReceived(income);
                          },
                          child: const Text(
                            'Mark as Received',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ))
      ]),
    );
  }
}
