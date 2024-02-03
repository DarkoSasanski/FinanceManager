import 'package:financemanager/components/appBar/custom_app_bar.dart';
import 'package:financemanager/components/dashboard/dashboard_pie_chart.dart';
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
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: CustomAppBar(
            title: "Dashboard",
            actionButtonText: "Add funds",
            actionButtonOnPressed: () {}),
        drawer: const SideMenu(),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  DropdownButton(
                    underline: Container(),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: const [
                      DropdownMenuItem(
                        value: 'all',
                        child: Text('All accounts'),
                      ),
                      DropdownMenuItem(
                        value: 'card',
                        child: Text('Payment card'),
                      ),
                      DropdownMenuItem(
                        value: 'cash',
                        child: Text('Cash'),
                      ),
                    ],
                    onChanged: (value) {},
                    hint: const Text('Credit Card',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal)),
                  ),
                  DropdownButton(
                    icon: const Icon(Icons.keyboard_arrow_down),
                    underline: Container(),
                    items: const [
                      DropdownMenuItem(
                        value: 'all',
                        child: Text('All accounts'),
                      ),
                      DropdownMenuItem(
                        value: 'card',
                        child: Text('Payment card'),
                      ),
                      DropdownMenuItem(
                        value: 'cash',
                        child: Text('Cash'),
                      ),
                    ],
                    onChanged: (value) {},
                    hint: const Text('Month',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal)),
                  ),
                ],
              )),
              const Text("Balance",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w500)),
              const Text("1500\$",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,)),
              Divider(
                endIndent: screenWidth * 0.4,
                color: Colors.grey,
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: const Center(
                  child: Text("October",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w500)),
                ),
              ),
              const Center(
                child: DashboardPieChart(),
              )
            ],
          ),
        ));
  }
}
