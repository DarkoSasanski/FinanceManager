import 'package:flutter/material.dart';

import 'custom_action_button.dart';

class AddAccountAppBarButton extends StatefulWidget {
  final void Function(String name, int amount) onSubmitted;
  final String actionButtonText;

  const AddAccountAppBarButton(
      {super.key, required this.onSubmitted, required this.actionButtonText});

  @override
  State<AddAccountAppBarButton> createState() => _AddAccountAppBarButtonState();
}

class _AddAccountAppBarButtonState extends State<AddAccountAppBarButton> {
  void _showAddAccountDialog() {
    String accountName = '';
    int accountAmount = 0;
    String? accountNameError;
    String? accountAmountError;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool validateInputs() {
              bool isValid = true;
              if (accountName.isEmpty) {
                accountNameError = 'This field is required';
                isValid = false;
              } else {
                accountNameError = null;
              }

              if (accountAmount <= 0) {
                accountAmountError = 'This field is required';
                isValid = false;
              } else {
                accountAmountError = null;
              }

              return isValid;
            }

            return Dialog(
              backgroundColor: const Color.fromRGBO(29, 31, 52, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Add Account',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Colors.grey[350]),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[350]!),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.tealAccent),
                        ),
                        errorText: accountNameError,
                      ),
                      onChanged: (value) {
                        setState(() {
                          accountName = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextField(
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
                        errorText: accountAmountError,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          accountAmount = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                    const SizedBox(height: 30),
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
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            if (validateInputs()) {
                              setState(() {});
                              widget.onSubmitted(accountName, accountAmount);
                              Navigator.of(context).pop();
                            } else {
                              setState(() {});
                            }
                          },
                          child: const Text('Add',
                              style: TextStyle(color: Colors.tealAccent)),
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
    return CustomActionButton(
        actionButtonText: widget.actionButtonText,
        actionButtonOnPressed: _showAddAccountDialog,
        gradientColors: const [
          Color(0xFF00B686),
          Color(0xFF008A60),
          Color(0xff00573a),
        ]);
  }
}
