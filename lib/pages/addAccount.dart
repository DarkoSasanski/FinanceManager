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

  void _showAddAccountDialog() {
    String accountName = '';
    int accountAmount = 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                          onPressed: accountName.isNotEmpty && accountAmount > 0
                              ? () {
                                  _addAccount(accountName, accountAmount);
                                  Navigator.of(context).pop();
                                }
                              : null,
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
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Accounts',
        actionButtonText: 'Add account',
        actionButtonOnPressed: () {
          _showAddAccountDialog();
        },
      ),
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
