import 'package:flutter/material.dart';

import '../../models/Plan.dart';

class EditSavingPlanDialog extends StatefulWidget {
  final String type;
  final int goalAmount;
  final DateTime startDate;
  final DateTime endDate;

  const EditSavingPlanDialog(
      {Key? key,
      required this.type,
      required this.goalAmount,
      required this.startDate,
      required this.endDate})
      : super(key: key);

  @override
  _EditSavingPlanDialogState createState() => _EditSavingPlanDialogState();
}

class _EditSavingPlanDialogState extends State<EditSavingPlanDialog> {
  late String type;
  late int goalAmount;
  late DateTime startDate;
  late DateTime endDate;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    type = widget.type;
    goalAmount = widget.goalAmount;
    startDate = widget.startDate;
    endDate = widget.endDate;
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
    return Dialog(
      backgroundColor: const Color.fromRGBO(29, 31, 52, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: StatefulBuilder(
              builder: (context, setDialogState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Edit Saving Plan',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      onChanged: (value) => type = value,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Type',
                        labelStyle: TextStyle(color: Colors.grey[350]),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[350]!),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.tealAccent),
                        ),
                      ),
                      initialValue: widget.type,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a type';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      onChanged: (value) =>
                          goalAmount = int.tryParse(value) ?? 0,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Goal Amount',
                        labelStyle: TextStyle(color: Colors.grey[350]),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[350]!),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.tealAccent),
                        ),
                      ),
                      initialValue: widget.goalAmount.toString(),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value)! <= 0) {
                          return 'Please enter a valid goal amount';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      title: const Text('Start Date',
                          style: TextStyle(color: Colors.white)),
                      trailing: GestureDetector(
                        onTap: () => _selectStartDate(context, setDialogState),
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
                          onPressed: () {
                            Navigator.of(context).pop(null);
                          },
                        ),
                        TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.of(context).pop(Plan(
                                  type: type,
                                  goalAmount: goalAmount,
                                  dateStart: startDate,
                                  dateEnd: endDate));
                            }
                          },
                          child: const Text('Save',
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
      ),
    );
  }
}
