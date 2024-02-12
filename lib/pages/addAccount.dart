import 'package:financemanager/components/buttons/add_account_app_bar_button.dart';
import 'package:flutter/material.dart';

import '../components/appBar/custom_app_bar.dart';
import '../components/dialogs/delete_account_dialog.dart';
import '../components/dialogs/edit_account_dialog.dart';
import '../components/sideMenu/side_menu.dart';
import '../helpers/database_helper.dart';
import '../models/Account.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Account> accounts = [];

  @override
  void initState() {
    super.initState();
    loadAccounts();
  }

  void loadAccounts() async {
    final accountRepository = await _databaseHelper.accountRepository();
    final List<Account> loadedAccounts = await accountRepository.findAll();

    setState(() {
      accounts = loadedAccounts;
    });
  }

  void _addAccount(String name, int amount) async {
    final accountRepository = await _databaseHelper.accountRepository();
    await accountRepository.insertAccount(Account(name: name, amount: amount));
    loadAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'Accounts',
          appBarButton: AddAccountAppBarButton(
            onSubmitted: _addAccount,
            actionButtonText: 'Add Account',
          )),
      drawer: const SideMenu(),
      body: ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          final account = accounts[index];
          return Card(
            color: const Color.fromRGBO(29, 31, 52, 1),
            child: ListTile(
              title: Text(account.name,
                  style: const TextStyle(color: Colors.white, fontSize: 20)),
              subtitle: Text('${account.amount}\$',
                  style: const TextStyle(color: Colors.white70, fontSize: 18)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                // This is important for Row inside ListTile
                children: <Widget>[
                  EditAccountButton(
                    account: account,
                    onEditCompleted: loadAccounts,
                  ),
                  DeleteAccountButton(
                    account: account,
                    onDeletionCompleted: loadAccounts, // Assuming loadAccounts is your method to refresh the accounts list
                  ),
                  SizedBox(width: 8), // Provides spacing between the icons
                  Icon(Icons.credit_card, color: Colors.white70),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
