import 'package:flutter/material.dart';

import '../components/appBar/custom_app_bar.dart';
import '../components/buttons/add_income_app_bar_button.dart';
import '../components/sideMenu/side_menu.dart';
import '../models/Account.dart';
import '../models/Income.dart';

class IncomesPage extends StatefulWidget {
  const IncomesPage({Key? key}) : super(key: key);

  @override
  State<IncomesPage> createState() => _IncomesPageState();
}

class _IncomesPageState extends State<IncomesPage> {
  List<Income> incomes = [];

  void _addIncome(String source, String description, int amount,
      bool isReceived, DateTime date, Account? account) {
    setState(() {
      Income income = Income(
          source: source,
          description: description,
          amount: amount,
          isReceived: isReceived,
          date: date,
          account: account!);
      incomes.add(income);
      if (income.isReceived) {
        account.addIncome(income);
        account.amount += amount;
      }
    });
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
      body: ListView.builder(
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
                          side:
                              const BorderSide(color: Colors.white, width: 1.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            income.isReceived = true;
                            income.account.addIncome(income);
                            income.account.amount += income.amount;
                          });
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
      ),
    );
  }
}

void main() => runApp(const MaterialApp(home: IncomesPage()));
