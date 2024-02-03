import 'package:financemanager/components/appBar/custom_app_bar.dart';
import 'package:flutter/material.dart';

import '../components/sideMenu/side_menu.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            title: "Dashboard",
            actionButtonText: "Add funds",
            actionButtonOnPressed: () {}),
        drawer: const SideMenu(),
        body: const Center(
          child: Text(
            'Dashboard',
            style: TextStyle(fontSize: 24),
          ),
        ));
  }
}
