import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    initialAmount = widget.initialAmount;
    currentAmount = 0;
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
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(AmountInputDialogResult(currentAmount, false)); // Cancel
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.tealAccent)),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              removePressed = true;
            });
            Navigator.of(context).pop(AmountInputDialogResult(currentAmount, false)); // Confirm and return the new amount
          },
          child: const Text('Remove', style: TextStyle(color: Colors.tealAccent)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(AmountInputDialogResult(currentAmount, true)); // Confirm and return the new amount
          },
          child: const Text('Add', style: TextStyle(color: Colors.tealAccent)),
        ),
      ],
    );
  }
}
