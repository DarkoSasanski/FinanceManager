import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../models/Category.dart';

class DashboardPieChart extends StatelessWidget {
  final String month;
  final Map<Category, String> categoryExpenses;

  const DashboardPieChart(
      {super.key, required this.month, required this.categoryExpenses});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double radius = screenWidth / 3.35;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 15),
          child: Center(
            child: Text(month,
                style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.w500)),
          ),
        ),
        Center(
            child: Container(
                width: radius * 2,
                height: radius * 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(40, 43, 107, 0.8),
                      spreadRadius: 1,
                      blurRadius: 9,
                    ),
                  ],
                ),
                child: PieChart(PieChartData(
                  sections: categoryExpenses.entries
                      .map((entry) => PieChartSectionData(
                            color: entry.key.color,
                            value: double.parse(entry.value),
                            showTitle: false,
                            badgeWidget: Icon(
                              entry.key.icon,
                              color: Colors.white.withOpacity(0.4),
                            ),
                            radius: radius,
                          ))
                      .toList(),
                  centerSpaceRadius: 0,
                  sectionsSpace: 0,
                ))))
      ],
    );
  }
}
