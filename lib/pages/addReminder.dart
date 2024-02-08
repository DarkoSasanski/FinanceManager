import 'package:financemanager/models/Category.dart';
import 'package:financemanager/models/Expense.dart';
import 'package:flutter/material.dart';

import '../components/appBar/custom_app_bar.dart';
import '../components/buttons/add_reminder_app_bar_button.dart';
import '../components/dialogs/delete_confirmation_dialog.dart';
import '../components/dialogs/edit_reminder_dialog.dart';
import '../components/sideMenu/side_menu.dart';
import '../helpers/database_helper.dart';
import '../models/Account.dart';
import '../models/Reminder.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({Key? key}) : super(key: key);

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Reminder> reminders = [];

  void _loadReminders() async {
    final reminderRepository = await _databaseHelper.reminderRepository();
    final loadedReminders = await reminderRepository.findAll();
    setState(() {
      reminders = loadedReminders;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  void _addReminder(String title, int amount, DateTime date, bool isCompleted,
      Category? category) async {
    final reminderRepository = await _databaseHelper.reminderRepository();
    final Reminder reminder = Reminder(
        title: title,
        amount: amount,
        isComplete: isCompleted,
        date: date,
        category: category!);
    await reminderRepository.insertReminder(reminder);
    _loadReminders();
  }

  void _editReminder(Reminder newReminder) async {
    final reminderRepository = await _databaseHelper.reminderRepository();
    await reminderRepository.updateReminder(newReminder);
    _loadReminders();
  }

  void _deleteReminder(Reminder reminder) async {
    bool confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return DeleteConfirmationDialog();
      },
    ) ?? false;

    if (confirmed) {
      final reminderRepository = await _databaseHelper.reminderRepository();
      await reminderRepository.deleteReminder(reminder.id);
      _loadReminders();
    }
  }

  void _addAccount(Reminder reminder) async {
    final reminderRepository = await _databaseHelper.reminderRepository();
    final accountRepository = await _databaseHelper.accountRepository();
    final expenseRepository = await _databaseHelper.expenseRepository();
    List<Account> availableAccounts = await accountRepository.findAll();

    bool? finished = await showDialog<bool>(
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
                Navigator.of(context).pop(null); // Cancel
              },
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.tealAccent)),
            ),
            TextButton(
              onPressed: () async {
                reminder.account = selectedAccount!;
                if (reminder.account.amount - reminder.amount >= 0) {
                  await expenseRepository.insertExpense(Expense(
                      description: reminder.title,
                      amount: reminder.amount,
                      date: DateTime.now(),
                      account: reminder.account,
                      category: reminder.category));
                  reminder.account.amount -= reminder.amount;
                  reminder.isComplete = true;
                  await accountRepository.updateAccount(reminder.account);
                  await reminderRepository.updateReminder(reminder);
                  _loadReminders();
                  Navigator.of(context).pop(true);
                } else {
                  Navigator.of(context).pop(false);
                }
                // Confirm
              },
              child:
                  const Text('Add', style: TextStyle(color: Colors.tealAccent)),
            ),
          ],
        );
      },
    );
    if (finished == false) {
      _showErrorAlert(context, "Account doesn't have the funds.");
    }
  }

  void _showErrorAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(29, 31, 52, 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text(
            'Error',
            style: TextStyle(
              fontSize: 24,
              color: Colors.red, // Change color based on your preference
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.tealAccent),
              ),
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
              child: Stack(children: [
                Padding(
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
                              side: const BorderSide(
                                  color: Colors.white, width: 1.0),
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
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.white),
                        onPressed: () async {
                          Reminder? reminderResult = await showDialog<Reminder>(
                            context: context,
                            builder: (BuildContext context) {
                              return EditReminderDialog(title: reminder.title, amount: reminder.amount, date: reminder.date,isComplete: reminder.isComplete, category: reminder.category);
                            },
                          );
                          if(reminderResult!=null){
                            reminderResult.id = reminder.id;
                            _editReminder(reminderResult);
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.white),
                        onPressed: () {
                          _deleteReminder(reminder);
                        },
                      ),
                    ],
                  ),
                ),
              ]));
        },
      ),
    );
  }
}
