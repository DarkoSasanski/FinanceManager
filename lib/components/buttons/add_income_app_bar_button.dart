import 'package:financemanager/components/buttons/custom_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../helpers/database_helper.dart';
import '../../models/Account.dart';

class AddIncomeAppBarButton extends StatefulWidget {
  final String actionButtonText;
  final void Function(String, String, int, bool, DateTime, Account?)
      onSubmitted;

  const AddIncomeAppBarButton(
      {super.key, required this.onSubmitted, required this.actionButtonText});

  @override
  State<AddIncomeAppBarButton> createState() => _AddIncomeAppBarButtonState();
}

class _AddIncomeAppBarButtonState extends State<AddIncomeAppBarButton> {
  DateTime selectedDate = DateTime.now();

  Future<void> _showAddIncomeDialog() async {
    String source = '';
    String description = '';
    int amount = 0;
    bool isReceived = true;
    selectedDate = DateTime.now();
    Account? selectedAccount;
    final DatabaseHelper _databaseHelper = DatabaseHelper();
    final accountRepository = await _databaseHelper.accountRepository();

    List<Account> availableAccounts = await accountRepository.findAll();

    if (availableAccounts.isNotEmpty) {
      selectedAccount = availableAccounts[0];
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
                builder: (context, setDialogState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Add Income',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onChanged: (value) => source = value,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Source',
                          labelStyle: TextStyle(color: Colors.grey[350]),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[350]!),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.tealAccent),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onChanged: (value) => description = value,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(color: Colors.grey[350]),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[350]!),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.tealAccent),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onChanged: (value) => amount = int.tryParse(value) ?? 0,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          labelStyle: TextStyle(color: Colors.grey[350]),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[350]!),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.tealAccent),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        title: const Text('Is Received?',
                            style: TextStyle(color: Colors.white)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<bool>(
                              value: true,
                              groupValue: isReceived,
                              onChanged: (value) {
                                setDialogState(() {
                                  isReceived = value!;
                                });
                              },
                            ),
                            const Text('Yes',
                                style: TextStyle(color: Colors.white)),
                            Radio<bool>(
                              value: false,
                              groupValue: isReceived,
                              onChanged: (value) {
                                setDialogState(() {
                                  isReceived = value!;
                                });
                              },
                            ),
                            const Text('No',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
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
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.grey),
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
                          setDialogState(() {
                            selectedAccount = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        title: const Text('Date',
                            style: TextStyle(color: Colors.white)),
                        trailing: GestureDetector(
                          onTap: () => _selectDate(context, setDialogState),
                          child: Text(
                            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: const Text('Cancel',
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                              onPressed: () {
                                if (source.isNotEmpty && amount > 0) {
                                  widget.onSubmitted(
                                      source,
                                      description,
                                      amount,
                                      isReceived,
                                      selectedDate,
                                      selectedAccount);
                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text('Add',
                                  style: TextStyle(color: Colors.tealAccent))),
                        ],
                      ),
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

  Future<void> _selectDate(BuildContext context, Function setDialogState) async {
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

  @override
  Widget build(BuildContext context) {
    return CustomActionButton(
        actionButtonText: widget.actionButtonText,
        actionButtonOnPressed: _showAddIncomeDialog,
        gradientColors: const [
          Color(0xFF00B686),
          Color(0xFF008A60),
          Color(0xff00573a),
        ]);
  }
}
