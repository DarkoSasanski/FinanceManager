import 'package:financemanager/components/buttons/add_account_app_bar_button.dart';
import 'package:flutter/material.dart';

import '../components/appBar/custom_app_bar.dart';
import '../components/sideMenu/side_menu.dart';
import '../models/Account.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  List<Account> accounts = [
    Account(name: 'Payment card', amount: 1500),
    Account(name: 'Cash', amount: 1500),
  ];

  void _addAccount(String name, int amount) {
    setState(() {
      accounts.add(Account(name: name, amount: amount));
    });
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
              trailing: const Icon(Icons.credit_card, color: Colors.white70),
            ),
          );
        },
      ),
    );
  }
}
