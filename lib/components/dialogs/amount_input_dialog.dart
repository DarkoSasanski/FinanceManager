import 'package:flutter/material.dart';

import '../../helpers/database_helper.dart';
import '../../models/Account.dart';
import '../../models/results/AmountInputDialogResult.dart';

class AmountInputDialog extends StatefulWidget {
  final int initialAmount;

  const AmountInputDialog({required this.initialAmount});

  @override
  _AmountInputDialogState createState() => _AmountInputDialogState();
}

class _AmountInputDialogState extends State<AmountInputDialog> {
  late int initialAmount;
  late int currentAmount;
  bool removePressed = false;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Account> accounts = [];
  Account? selectedAccount;

  void loadAccounts() async {
    final accountRepository = await _databaseHelper.accountRepository();
    final List<Account> loadedAccounts = await accountRepository.findAll();

    setState(() {
      accounts = loadedAccounts;
    });
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

  @override
  void initState() {
    super.initState();
    loadAccounts();
    initialAmount = widget.initialAmount;
    currentAmount = 0;
    selectedAccount = null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromRGBO(29, 31, 52, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text(
        'Add Amount',
        style: TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Current Amount: $initialAmount',
              labelStyle: TextStyle(color: Colors.grey[350]),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[350]!),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.tealAccent),
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                currentAmount = int.tryParse(value) ?? currentAmount;
              });
            },
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<Account>(
            decoration: _inputDecoration('From/To Account'),
            dropdownColor: const Color.fromRGBO(29, 31, 52, 1),
            value: selectedAccount,
            icon: const Icon(Icons.arrow_drop_down,
                color: Colors.grey),
            items: accounts
                .map<DropdownMenuItem<Account>>((Account account) {
              return DropdownMenuItem<Account>(
                value: account,
                child: Text(account.name,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 16)),
              );
            }).toList(),
            onChanged: (Account? newValue) {
              setState(() {
                selectedAccount = newValue!;
              });
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(null); // Cancel
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.tealAccent)),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              removePressed = true;
            });
            Navigator.of(context).pop(AmountInputDialogResult(currentAmount, false, selectedAccount)); // Confirm and return the new amount
          },
          child: const Text('Remove', style: TextStyle(color: Colors.tealAccent)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(AmountInputDialogResult(currentAmount, true, selectedAccount)); // Confirm and return the new amount
          },
          child: const Text('Add', style: TextStyle(color: Colors.tealAccent)),
        ),
      ],
    );
  }
}
