import 'package:financemanager/components/buttons/add_saving_plan_app_bar_button.dart';
import 'package:financemanager/models/results/AmountInputDialogResult.dart';
import 'package:flutter/material.dart';

import '../components/appBar/custom_app_bar.dart';
import '../components/dialogs/amount_input_dialog.dart';
import '../components/sideMenu/side_menu.dart';
import '../helpers/database_helper.dart';
import '../models/Plan.dart';

class SavingPlansPage extends StatefulWidget {
  const SavingPlansPage({Key? key}) : super(key: key);

  @override
  State<SavingPlansPage> createState() => _SavingPlansPageState();
}

class _SavingPlansPageState extends State<SavingPlansPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Plan> plans = [];

  void _addPlan(String type, int goalAmount, DateTime dateStart, DateTime dateEnd) async {
    final planRepository = await _databaseHelper.planRepository();
    final plan = Plan(type: type, goalAmount: goalAmount, dateStart: dateStart, dateEnd: dateEnd);
    await planRepository.insertPlan(plan);
    _loadPlans();
  }

  void _loadPlans() async {
    final planRepository = await _databaseHelper.planRepository();
    final loadedPlans = await planRepository.findAll();
    setState(() {
      plans = loadedPlans;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }


  void _updateCurrentAmount(Plan plan, bool addCheck, int newAmount) async {
    final planRepository = await _databaseHelper.planRepository();

    if (newAmount != null && addCheck) {
      await planRepository.updatePlanCurrentAmount(plan.id, newAmount);
    } else if (newAmount != null && !addCheck) {
      if (plan.currentAmount - newAmount < 0) {
        _showErrorAlert(context, 'Cannot remove more than the current amount.');
      }
      await planRepository.updatePlanCurrentAmount(plan.id, -newAmount);
    }
    _loadPlans();
  }

  void _showErrorAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(29, 31, 52, 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text(
            'Error',
            style: TextStyle(
              fontSize: 24,
              color: Colors.red, // Change color based on your preference
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.tealAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Saving Plans",
        appBarButton: AddSavingPlanAppBarButton(
          onSubmitted: _addPlan,
          actionButtonText: "Add Saving Plan",
        ),
      ),
      drawer: const SideMenu(),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          double progressValue =
              (plan.currentAmount / plan.goalAmount).clamp(0.0, 1.0);
          return GestureDetector(
            onTap: () async {
              AmountInputDialogResult? result = await showDialog<AmountInputDialogResult>(
              context: context,
              builder: (BuildContext context) {
              return AmountInputDialog(initialAmount: plan.currentAmount);
            });
              if(result!=null){
                _updateCurrentAmount(plan, result.addPressed, result.currentAmount);
              }
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF2DB684).withOpacity(0.8),
                      const Color(0xFF101325).withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        plan.type,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${plan.dateStart.day}/${plan.dateStart.month}/${plan.dateStart.year} - ${plan.dateEnd.day}/${plan.dateEnd.month}/${plan.dateEnd.year}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[300],
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progressValue,
                        backgroundColor: Colors.grey[300],
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Savings Progress: ${(progressValue * 100).toStringAsFixed(1)}%",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
