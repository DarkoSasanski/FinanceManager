import 'package:flutter/material.dart';
import '../../helpers/database_helper.dart';
import '../../models/Account.dart';

class DeleteAccountButton extends StatelessWidget {
  final Account account;
  final Function onDeletionCompleted;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  DeleteAccountButton({
    Key? key,
    required this.account,
    required this.onDeletionCompleted,
  }) : super(key: key);

  Future<void> _showDeleteAccountDialog(BuildContext context) async {
    final accountRepository = await _databaseHelper.accountRepository();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(29, 31, 52, 1),
          title: const Text('Delete Account', style: TextStyle(color: Colors.white)),
          content: const Text(
            'Are you sure you want to delete this account?\n\nNOTE: All expenses and incomes for this account will be deleted too.',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                await accountRepository.deleteAccount(account.id);
                Navigator.of(context).pop();
                onDeletionCompleted();
              },
              child: const Text('Yes', style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.redAccent),
      onPressed: () => _showDeleteAccountDialog(context),
    );
  }
}
