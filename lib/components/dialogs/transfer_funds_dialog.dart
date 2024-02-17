import 'package:flutter/material.dart';

import '../../helpers/database_helper.dart';
import '../../models/Account.dart';
import '../../models/results/TransferFundsDialogResult.dart';

class TransferFundsDialog extends StatefulWidget {
  const TransferFundsDialog({super.key});

  @override
  State<TransferFundsDialog> createState() => _TransferFundsDialogState();
}

class _TransferFundsDialogState extends State<TransferFundsDialog> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Account> accounts = [];
  late double amountToTransfer;
  Account? selectedAccountFrom;
  Account? selectedAccountTo;

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
    amountToTransfer = 0;
    selectedAccountFrom = null;
    selectedAccountTo = null;
  }

  List<Account> getDropdownOptionsForFrom() {
    return accounts.where((element) => element != selectedAccountTo).toList();
  }

  List<Account> getDropdownOptionsForTo() {
    return accounts.where((element) => element != selectedAccountFrom).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromRGBO(29, 31, 52, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text(
        'Transfer Funds',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setDialogState) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DropdownButtonFormField<Account>(
                  value: selectedAccountFrom,
                  decoration: _inputDecoration("From"),
                  dropdownColor: const Color.fromRGBO(29, 31, 52, 1),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  onChanged: (Account? newValue) {
                    setDialogState(() {
                      selectedAccountFrom = newValue!;
                    });
                  },
                  items: getDropdownOptionsForFrom()
                      .map<DropdownMenuItem<Account>>((Account value) {
                    return DropdownMenuItem<Account>(
                      value: value,
                      child: Text(value.name,
                          style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<Account>(
                  value: selectedAccountTo,
                  decoration: _inputDecoration("To"),
                  dropdownColor: const Color.fromRGBO(29, 31, 52, 1),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  items: getDropdownOptionsForTo()
                      .map<DropdownMenuItem<Account>>((Account value) {
                    return DropdownMenuItem<Account>(
                      value: value,
                      child: Text(value.name,
                          style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (Account? newValue) {
                    setDialogState(() {
                      selectedAccountTo = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Amount'),
                  keyboardType: TextInputType.number,
                  onChanged: (String value) {
                    setDialogState(() {
                      amountToTransfer = double.parse(value);
                    });
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(null); // Cancel
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              selectedAccountFrom = null;
              selectedAccountTo = null;
            });
          },
          child:
              const Text('Reset', style: TextStyle(color: Colors.tealAccent)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(TransferFundsDialogResult(
                selectedAccountFrom: selectedAccountFrom,
                selectedAccountTo: selectedAccountTo,
                amountToTransfer: amountToTransfer));
          },
          child: const Text('Transfer',
              style: TextStyle(color: Colors.tealAccent)),
        ),
      ],
    );
  }
}
