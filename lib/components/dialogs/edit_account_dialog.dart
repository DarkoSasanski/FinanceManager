import 'package:flutter/material.dart';

import '../../helpers/database_helper.dart';
import '../../models/Account.dart';

class EditAccountButton extends StatefulWidget {
  final Account account;
  final Function onEditCompleted;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  EditAccountButton({
    Key? key,
    required this.account,
    required this.onEditCompleted,
  }) : super(key: key);

  @override
  State<EditAccountButton> createState() => _EditAccountButtonState();
}

class _EditAccountButtonState extends State<EditAccountButton> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _showEditAccountDialog(BuildContext context) async {
    String accountName = widget.account.name;
    int accountAmount = widget.account.amount;
    final accountRepository = await widget._databaseHelper.accountRepository();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: const Color.fromRGBO(29, 31, 52, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Edit Account',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        initialValue: accountName,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(color: Colors.grey[350]),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[350]!)),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.tealAccent)),
                        ),
                        onChanged: (value) =>
                            setState(() => accountName = value),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                          initialValue: accountAmount.toString(),
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Amount',
                            labelStyle: TextStyle(color: Colors.grey[350]),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey[350]!)),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.tealAccent)),
                          ),
                          onChanged: (value) => setState(() => accountAmount =
                              int.tryParse(value) ?? accountAmount),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid amount';
                            }
                            return null;
                          }),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel',
                                style: TextStyle(color: Colors.white)),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                Account updatedAccount = Account.withId(
                                  id: widget.account.id,
                                  name: accountName,
                                  amount: accountAmount,
                                );
                                await accountRepository
                                    .updateAccount(updatedAccount);
                                widget.onEditCompleted();
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text('Save',
                                style: TextStyle(color: Colors.tealAccent)),
                          ),
                        ],
                      ),
                    ],
                  ),
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
      icon: const Icon(Icons.edit, color: Colors.white),
      onPressed: () => _showEditAccountDialog(context),
    );
  }
}
