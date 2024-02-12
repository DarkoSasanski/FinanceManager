import 'package:flutter/material.dart';

import '../../helpers/database_helper.dart';
import '../../models/Account.dart';

class EditAccountButton extends StatelessWidget {
  final Account account;
  final Function onEditCompleted;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  EditAccountButton({
    Key? key,
    required this.account,
    required this.onEditCompleted,
  }) : super(key: key);

  Future<void> _showEditAccountDialog(BuildContext context) async {
    String accountName = account.name;
    int accountAmount = account.amount;
    final accountRepository = await _databaseHelper.accountRepository();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: const Color.fromRGBO(29, 31, 52, 1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Edit Account',
                      style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      initialValue: accountName,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Colors.grey[350]),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[350]!)),
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.tealAccent)),
                      ),
                      onChanged: (value) => setState(() => accountName = value),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      initialValue: accountAmount.toString(),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        labelStyle: TextStyle(color: Colors.grey[350]),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[350]!)),
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.tealAccent)),
                      ),
                      onChanged: (value) => setState(() => accountAmount = int.tryParse(value) ?? accountAmount),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                        ),
                        TextButton(
                          onPressed: () async {
                            Account updatedAccount = Account.withId(
                              id: account.id,
                              name: accountName,
                              amount: accountAmount,
                            );
                            await accountRepository.updateAccount(updatedAccount);
                            onEditCompleted();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Save', style: TextStyle(color: Colors.tealAccent)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.edit, color: Colors.white),
      onPressed: () => _showEditAccountDialog(context),
    );
  }
}
