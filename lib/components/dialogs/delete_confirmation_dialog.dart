import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {

  const DeleteConfirmationDialog({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromRGBO(29, 31, 52, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text(
        'Confirmation',
        style: TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const Text(
        'Are you sure you want to delete this plan?',
        style: TextStyle(color: Colors.white),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false); // Close the dialog
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true); // Close the dialog after confirming
          },
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
