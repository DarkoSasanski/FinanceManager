import 'package:financemanager/components/appBar/custom_app_bar.dart';
import 'package:financemanager/components/buttons/custom_action_button.dart';
import 'package:financemanager/components/dashboard/dashboard_pie_chart.dart';
import 'package:flutter/material.dart';

import '../components/sideMenu/side_menu.dart';
import '../models/Category.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Category> categories = [
    Category(
        name: 'Food',
        icon: Icons.drive_eta_outlined,
        color: const Color.fromRGBO(27, 114, 130, 1)),
    Category(
        name: 'Entertainment',
        icon: Icons.checkroom_outlined,
        color: const Color.fromRGBO(42, 195, 139, 1)),
    Category(
        name: 'Transport',
        icon: Icons.flatware,
        color: const Color.fromRGBO(195, 105, 83, 1)),
    Category(
        name: 'Other',
        icon: Icons.home_outlined,
        color: const Color.fromRGBO(90, 50, 127, 1)),
    Category(
        name: 'Food',
        icon: Icons.drive_eta_outlined,
        color: const Color.fromRGBO(27, 114, 130, 1)),
    Category(
        name: 'Entertainment',
        icon: Icons.checkroom_outlined,
        color: const Color.fromRGBO(42, 195, 139, 1)),
    Category(
        name: 'Transport',
        icon: Icons.flatware,
        color: const Color.fromRGBO(195, 105, 83, 1)),
    Category(
        name: 'Other',
        icon: Icons.home_outlined,
        color: const Color.fromRGBO(90, 50, 127, 1)),
    Category(
        name: 'Food',
        icon: Icons.drive_eta_outlined,
        color: const Color.fromRGBO(27, 114, 130, 1)),
    Category(
        name: 'Entertainment',
        icon: Icons.checkroom_outlined,
        color: const Color.fromRGBO(42, 195, 139, 1)),
    Category(
        name: 'Transport',
        icon: Icons.flatware,
        color: const Color.fromRGBO(195, 105, 83, 1)),
    Category(
        name: 'Other',
        icon: Icons.home_outlined,
        color: const Color.fromRGBO(90, 50, 127, 1)),
  ];

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
          child: ListView(
            children: <Widget>[
              Row(
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
              ),
              const Text("Balance",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w500)),
              const Text("1500\$",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  )),
              Divider(
                endIndent: screenWidth * 0.4,
                color: Colors.grey,
              ),
              const DashboardPieChart(
                month: 'October',
              ),
              Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      CustomActionButton(
                          actionButtonText: "Add Cost",
                          actionButtonOnPressed: () {},
                          gradientColors: const [
                            Color(0xff544484),
                            Color(0xff3e3262),
                            Color(0xff2f2546),
                          ]),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text("Spendings",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500)),
                          Text("500\$",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ],
                  )),
              Container(
                  padding: EdgeInsets.only(left: screenWidth * 0.4),
                  child: const Divider(
                    color: Colors.grey,
                  )),
              GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 10,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: category.color,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(category.icon,
                              size: 25, color: Colors.white.withOpacity(0.4)),
                          const SizedBox(height: 4),
                          Text(
                            category.name,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "100\$",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
