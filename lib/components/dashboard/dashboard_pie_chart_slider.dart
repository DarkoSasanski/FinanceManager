import 'package:flutter/material.dart';

import '../../models/Category.dart';
import '../../models/Month.dart';
import 'dashboard_pie_chart.dart';

class DashboardPieChartSlider extends StatefulWidget {
  final int selectedMonth;
  final void Function(int) onMonthChanged;
  final Map<Category, String> categoryExpenses;

  const DashboardPieChartSlider(
      {super.key,
      required this.selectedMonth,
      required this.onMonthChanged,
      required this.categoryExpenses});

  @override
  _DashboardPieChartSliderState createState() =>
      _DashboardPieChartSliderState();
}

class _DashboardPieChartSliderState extends State<DashboardPieChartSlider> {
  late final PageController _pageController;
  bool _isFirstBuild = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.selectedMonth - 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isFirstBuild) {
      _pageController.animateToPage(widget.selectedMonth - 1,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    } else {
      _isFirstBuild = false;
    }

    return SizedBox(
        height: 350,
        child: Row(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints.tightFor(width: 50),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  surfaceTintColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.all(0),
                ),
                onPressed: () {
                  if (_pageController.page! > 0) {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                    widget.onMonthChanged(_pageController.page!.round());
                  } else {
                    _pageController.animateTo(
                        _pageController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                    widget.onMonthChanged(12);
                  }
                },
                child: const Icon(
                  Icons.arrow_forward_ios,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  itemCount: months.length,
                  itemBuilder: (context, index) {
                    return DashboardPieChart(
                        month: months[index].name,
                        categoryExpenses: index + 1 == widget.selectedMonth
                            ? widget.categoryExpenses
                            : {});
                  },
                ),
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints.tightFor(width: 50),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  surfaceTintColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.all(0),
                ),
                onPressed: () {
                  if (_pageController.page! < months.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                    widget.onMonthChanged(_pageController.page!.round() + 2);
                  } else {
                    _pageController.animateTo(
                        _pageController.position.minScrollExtent,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                    widget.onMonthChanged(1);
                  }
                },
                child: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          ],
        ));
  }
}
