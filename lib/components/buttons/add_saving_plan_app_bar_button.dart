import 'package:financemanager/components/buttons/custom_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddSavingPlanAppBarButton extends StatefulWidget {
  final String actionButtonText;
  final void Function(String, int, DateTime, DateTime) onSubmitted;

  const AddSavingPlanAppBarButton(
      {super.key, required this.onSubmitted, required this.actionButtonText});

  @override
  State<AddSavingPlanAppBarButton> createState() =>
      _AddSavingPlanAppBarButtonState();
}

class _AddSavingPlanAppBarButtonState extends State<AddSavingPlanAppBarButton> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  void _showAddSavingPlanDialog() {
    String type = '';
    int goalAmount = 0;
    String? typeError;
    String? goalAmountError;

    startDate = DateTime.now();
    endDate = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color.fromRGBO(29, 31, 52, 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: StatefulBuilder(
                builder: (context, StateSetter setDialogState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Add Saving Plan',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onChanged: (value) {
                          type = value;
                          if (type.isNotEmpty) {
                            typeError = null;
                          }
                          setDialogState(() {});
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Type',
                          labelStyle: TextStyle(color: Colors.grey[350]),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[350]!)),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.tealAccent)),
                          errorText: typeError,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onChanged: (value) {
                          goalAmount = int.tryParse(value) ?? 0;
                          if (goalAmount > 0) {
                            goalAmountError = null;
                          }
                          setDialogState(() {});
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Goal Amount',
                          labelStyle: TextStyle(color: Colors.grey[350]),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[350]!)),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.tealAccent)),
                          errorText: goalAmountError,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        title: const Text('Start Date',
                            style: TextStyle(color: Colors.white)),
                        trailing: GestureDetector(
                          onTap: () =>
                              _selectStartDate(context, setDialogState),
                          child: Text(
                            '${startDate.day}/${startDate.month}/${startDate.year}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        title: const Text('End Date',
                            style: TextStyle(color: Colors.white)),
                        trailing: GestureDetector(
                          onTap: () => _selectEndDate(context, setDialogState),
                          child: Text(
                            '${endDate.day}/${endDate.month}/${endDate.year}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: const Text('Cancel',
                                style: TextStyle(color: Colors.white)),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          TextButton(
                            onPressed: () {
                              if (type.isEmpty) {
                                typeError = 'Type is required';
                                setDialogState(() {});
                              }
                              if (goalAmount <= 0) {
                                goalAmountError =
                                    'Goal Amount must be greater than 0';
                                setDialogState(() {});
                              }
                              if (typeError == null &&
                                  goalAmountError == null) {
                                widget.onSubmitted(
                                    type, goalAmount, startDate, endDate);
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text('Add',
                                style: TextStyle(color: Colors.tealAccent)),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectEndDate(
      BuildContext context, Function setDialogState) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != endDate) {
      setDialogState(() {
        endDate = pickedDate;
      });
    }
  }

  Future<void> _selectStartDate(
      BuildContext context, Function setDialogState) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != startDate) {
      setDialogState(() {
        startDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomActionButton(
        actionButtonText: widget.actionButtonText,
        actionButtonOnPressed: _showAddSavingPlanDialog,
        gradientColors: const [
          Color(0xFF00B686),
          Color(0xFF008A60),
          Color(0xff00573a),
        ]);
  }
}
