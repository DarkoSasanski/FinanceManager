import 'package:financemanager/models/Category.dart';
import 'package:financemanager/models/Expense.dart';
import 'package:flutter/material.dart';

import '../components/appBar/custom_app_bar.dart';
import '../components/buttons/add_reminder_app_bar_button.dart';
import '../components/sideMenu/side_menu.dart';
import '../models/Account.dart';
import '../models/Reminder.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({Key? key}) : super(key: key);

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  List<Reminder> reminders = [];

  void _addReminder(String title, int amount, DateTime date, bool isCompleted,
      Category? category) {
    setState(() {
      Reminder reminder = Reminder(
          title: title,
          amount: amount,
          isComplete: isCompleted,
          date: date,
          category: category!);
      reminders.add(reminder);

      ///if (reminder.isComplete) {
      ///  account.addExpense(Expense(description: reminder.title, amount: reminder.amount, date: reminder.dateEnd, account: account, category: reminder.category));
      ///  account.amount -= amount;
      ///}
    });
  }

  void _addAccount(Reminder reminder) async {
    List<Account> availableAccounts = [Account(name: "Test", amount: 150)];
    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        Account? selectedAccount =
            availableAccounts.isNotEmpty ? availableAccounts.first : null;

        return AlertDialog(
          backgroundColor: const Color.fromRGBO(29, 31, 52, 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text(
            'Choose Account For Expense',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<Account>(
                decoration: InputDecoration(
                  labelText: 'Account',
                  labelStyle: TextStyle(color: Colors.grey[350]),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[350]!),
                  ),
                ),
                dropdownColor: const Color.fromRGBO(29, 31, 52, 1),
                value: selectedAccount,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                items: availableAccounts
                    .map<DropdownMenuItem<Account>>((Account account) {
                  return DropdownMenuItem<Account>(
                    value: account,
                    child: Text(
                      account.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (Account? newValue) {
                  setState(() {
                    selectedAccount = newValue!;
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel
              },
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.tealAccent)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  reminder.account = selectedAccount!;
                  reminder.account.addExpense(Expense(
                      description: reminder.title,
                      amount: reminder.amount,
                      date: DateTime.now(),
                      account: reminder.account,
                      category: reminder.category));
                  reminder.account.amount -= reminder.amount;
                  reminder.isComplete = true;
                });
                Navigator.of(context).pop(true); // Confirm
              },
              child:
                  const Text('Add', style: TextStyle(color: Colors.tealAccent)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Reminders",
        appBarButton: AddReminderAppBarButton(
          onSubmitted: _addReminder,
          actionButtonText: "Add Reminder",
        ),
      ),
      drawer: const SideMenu(),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          final reminder = reminders[index];
          return Card(
            elevation: 4,
            color: reminder.isComplete ? Colors.green : Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    reminder.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Reminder set for date: ${reminder.date.day}/${reminder.date.month}/${reminder.date.year}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '\$${reminder.amount}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      if (reminder.isComplete)
                        const Icon(Icons.check, color: Colors.white)
                    ],
                  ),
                  if (!reminder.isComplete)
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
                          _addAccount(reminder);
                        },
                        child: const Text(
                          'Mark as Completed',
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
