import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardPieChart extends StatelessWidget {
  final String month;

  const DashboardPieChart({super.key, required this.month});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double radius = screenWidth / 3;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 10),
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
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: PieChart(PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: const Color.fromRGBO(42, 195, 139, 1),
                      value: 20,
                      showTitle: false,
                      badgeWidget: Icon(
                        Icons.checkroom_outlined,
                        color: Colors.white.withOpacity(0.4),
                      ),
                      radius: radius,
                    ),
                    PieChartSectionData(
                      color: const Color.fromRGBO(27, 114, 130, 1),
                      value: 40,
                      showTitle: false,
                      badgeWidget: Icon(
                        Icons.drive_eta_outlined,
                        color: Colors.white.withOpacity(0.4),
                      ),
                      radius: radius,
                    ),
                    PieChartSectionData(
                      color: const Color.fromRGBO(195, 105, 83, 1),
                      value: 30,
                      showTitle: false,
                      badgeWidget: Icon(
                        Icons.flatware,
                        color: Colors.white.withOpacity(0.4),
                      ),
                      radius: radius,
                    ),
                    PieChartSectionData(
                      color: const Color.fromRGBO(90, 50, 127, 1),
                      value: 10,
                      showTitle: false,
                      badgeWidget: Icon(
                        Icons.home_outlined,
                        color: Colors.white.withOpacity(0.4),
                      ),
                      radius: radius,
                    ),
                  ],
                  centerSpaceRadius: 0,
                  sectionsSpace: 0,
                ))))
      ],
    );
  }
}
