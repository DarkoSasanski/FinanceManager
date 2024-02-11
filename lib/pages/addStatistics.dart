import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../components/appBar/custom_app_bar.dart';
import '../components/sideMenu/side_menu.dart';
import '../helpers/database_helper.dart';
import '../models/Expense.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Expense> expenses = [];
  Map<int, int> mappingHelp = {};
  List<FlSpot> chartData = [];
  List<Color> gradientColors = [
    Colors.cyan,
    Colors.blue,
  ];

  @override
  void initState() {
    super.initState();
    _loadAllExpenses();
  }

  Future<List<Expense>> _loadAllExpenses() async {
    final expenseRepository = await _databaseHelper.expenseRepository();
    List<Expense> loadedExpenses = await expenseRepository.findAll();
    setState(() {
      expenses = loadedExpenses;
    });
    _createChartData();
    return expenses;
  }

  void _createChartData() {
    print(expenses.length);
    Map<int, int> updatedMappingHelp = Map.from(mappingHelp);

    for (var expense in expenses) {
      int year = expense.date.year;
      int month = expense.date.month;

      int key = year * 100 + month;
      if (updatedMappingHelp.containsKey(key)) {
        updatedMappingHelp[key] = updatedMappingHelp[key]! + expense.amount;
      } else {
        updatedMappingHelp.putIfAbsent(key, () => expense.amount);
        print(updatedMappingHelp.toString());
      }
    }

    setState(() {
      mappingHelp = updatedMappingHelp;
    });
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    int year = value ~/ 100;
    int month = (value % 100).toInt();

    Widget text;
    switch (month) {
      case 1:
        text = Text('$year - JAN', style: style);
        break;
      case 2:
        text = Text('$year - FEB', style: style);
        break;
      case 3:
        text = Text('$year - MAR', style: style);
        break;
      case 4:
        text = Text('$year - APR', style: style);
        break;
      case 5:
        text = Text('$year - MAY', style: style);
        break;
      case 6:
        text = Text('$year - JUN', style: style);
        break;
      case 7:
        text = Text('$year - JUL', style: style);
        break;
      case 8:
        text = Text('$year - AUG', style: style);
        break;
      case 9:
        text = Text('$year - SEP', style: style);
        break;
      case 10:
        text = Text('$year - OCT', style: style);
        break;
      case 11:
        text = Text('$year - NOV', style: style);
        break;
      case 12:
        text = Text('$year - DEC', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );

    String text = '\$$value K'; // Customize this based on your actual data

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  Widget _buildChart() {
    if (expenses.isEmpty) {
      // Display a loading indicator or placeholder if expenses are still loading
      return const Center(child: CircularProgressIndicator());
    }
    chartData = mappingHelp.entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble()))
        .toList();

    return Stack(children: <Widget>[
      AspectRatio(
        aspectRatio: 1.70,
        child: Padding(
          padding: const EdgeInsets.only(
            right: 18,
            left: 12,
            top: 24,
            bottom: 12,
          ),
          child: LineChart(
            mainData(),
          ),
        ),
      ),
    ]);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.deepPurple,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.deepPurpleAccent,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: mappingHelp.keys
          .reduce((min, key) => key < min ? key : min)
          .toDouble(),
      maxX: mappingHelp.keys
          .reduce((max, key) => key > max ? key : max)
          .toDouble(),
      minY: 0,
      maxY: mappingHelp.values
          .reduce((max, value) => value > max ? value : max)
          .toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: chartData,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Statistics",
      ),
      drawer: const SideMenu(), // Drawer, Body, etc.
      body: _buildChart(),
    );
  }
}
