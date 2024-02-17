import 'package:financemanager/pages/addAccount.dart';
import 'package:financemanager/pages/addCategory.dart';
import 'package:financemanager/pages/addExpense.dart';
import 'package:financemanager/pages/addIncome.dart';
import 'package:financemanager/pages/addSavingPlans.dart';
import 'package:financemanager/pages/addStatistics.dart';
import 'package:financemanager/pages/currencies.dart';
import 'package:financemanager/pages/dashboard.dart';
import 'package:flutter/material.dart';

import '../../pages/addReminder.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      backgroundColor: const Color.fromRGBO(16, 19, 37, 1),
      child: ListView(
        padding: const EdgeInsets.only(top: 25),
        children: <Widget>[
          ListTile(
            leading: const Icon(
              Icons.close_outlined,
              color: Color.fromRGBO(159, 162, 169, 1),
              size: 35,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Dashboard',
                style: TextStyle(color: Colors.grey, fontSize: 25)),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const Dashboard(),
              ));
            },
          ),
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
            indent: 10,
            endIndent: 10,
          ),
          ListTile(
            title: const Text('Accounts',
                style: TextStyle(color: Colors.grey, fontSize: 25)),
            hoverColor: Colors.white,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AccountsPage(),
              ));
            },
          ),
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
            indent: 10,
            endIndent: 10,
          ),
          ListTile(
            title: const Text('Saving plans',
                style: TextStyle(color: Colors.grey, fontSize: 25)),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SavingPlansPage(),
              ));
            },
          ),
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
            indent: 10,
            endIndent: 10,
          ),
          ListTile(
            title: const Text('Statistics',
                style: TextStyle(color: Colors.grey, fontSize: 25)),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const StatisticsPage(),
              ));
            },
          ),
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
            indent: 10,
            endIndent: 10,
          ),
          ListTile(
            title: const Text('Categories',
                style: TextStyle(color: Colors.grey, fontSize: 25)),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CategoriesPage(),
              ));
            },
          ),
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
            indent: 10,
            endIndent: 10,
          ),
          ListTile(
            title: const Text('Currencies',
                style: TextStyle(color: Colors.grey, fontSize: 25)),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const Currencies(),
              ));
            },
          ),
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
            indent: 10,
            endIndent: 10,
          ),
          ListTile(
            title: const Text('Reminders',
                style: TextStyle(color: Colors.grey, fontSize: 25)),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const RemindersPage(),
              ));
            },
          ),
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
            indent: 10,
            endIndent: 10,
          ),
          ListTile(
            title: const Text('Incomes',
                style: TextStyle(color: Colors.grey, fontSize: 25)),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const IncomesPage(),
              ));
            },
          ),
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
            indent: 10,
            endIndent: 10,
          ),
          ListTile(
            title: const Text('Expenses',
                style: TextStyle(color: Colors.grey, fontSize: 25)),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ExpensesPage(),
              ));
            },
          ),
        ],
      ),
    );
  }
}
