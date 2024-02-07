import 'package:financemanager/components/buttons/add_saving_plan_app_bar_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/appBar/custom_app_bar.dart';
import '../components/sideMenu/side_menu.dart';
import '../models/Plan.dart';

class SavingPlansPage extends StatefulWidget {
  const SavingPlansPage({Key? key}) : super(key: key);

  @override
  State<SavingPlansPage> createState() => _SavingPlansPageState();
}

class _SavingPlansPageState extends State<SavingPlansPage> {
  List<Plan> plans = [];

  void _addPlan(String type, int goalAmount, DateTime dateStart,
      DateTime dateEnd) {
    setState(() {
      Plan plan = Plan(
          type: type,
          goalAmount: goalAmount,
          dateStart: dateStart,
          dateEnd: dateEnd);
      plans.add(plan);
    });
  }
  void _updateCurrentAmount(Plan plan) async {
    // Show a dialog to input the new amount
    bool addCheck = true;
    int? newAmount = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int currentAmount = plan.currentAmount;

        return AlertDialog(
          backgroundColor: const Color.fromRGBO(29, 31, 52, 1),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text(
            'Add Amount',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Current Amount: $currentAmount',
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
                  // Validate input and update the currentAmount
                  // You may want to add further validation based on your requirements
                  currentAmount = int.tryParse(value) ?? currentAmount;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null); // Cancel
              },
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.tealAccent)),
            ),
            TextButton(
              onPressed: () {
                addCheck = false;
                Navigator.of(context).pop(currentAmount); // Confirm and return the new amount
              },
              child: const Text('Remove',
                  style: TextStyle(color: Colors.tealAccent)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(currentAmount); // Confirm and return the new amount
              },
            child: const Text('Add',
              style: TextStyle(color: Colors.tealAccent)),
            ),
          ],
        );
      },
    );
    if (newAmount != null && addCheck) {
      setState(() {
        plan.currentAmount += newAmount;
      });
    }else if(newAmount != null && !addCheck){
      if(plan.currentAmount - newAmount < 0) {
        _showErrorAlert(context, 'Cannot remove more than the current amount.');
      }
      setState(() {
        plan.currentAmount -= newAmount;
      });
    }
  }

  void _showErrorAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(29, 31, 52, 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
          double progressValue = (plan.currentAmount / plan.goalAmount).clamp(0.0, 1.0);
          return GestureDetector(
            onTap: () => _updateCurrentAmount(plan),
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
                Color(0xFF2DB684).withOpacity(0.8),
                Color(0xFF101325).withOpacity(0.8),
            ],
          ), borderRadius: BorderRadius.circular(16),
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
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
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

void main() => runApp(const MaterialApp(home: SavingPlansPage()));
