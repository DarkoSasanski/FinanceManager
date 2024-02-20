import 'package:financemanager/components/buttons/custom_action_button.dart';
import 'package:financemanager/models/Category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../helpers/database_helper.dart';

class AddReminderAppBarButton extends StatefulWidget {
  final String actionButtonText;
  final void Function(String title, int amount, DateTime date, bool isCompleted,
      Category? category) onSubmitted;

  const AddReminderAppBarButton(
      {super.key, required this.onSubmitted, required this.actionButtonText});

  @override
  State<AddReminderAppBarButton> createState() =>
      _AddReminderAppBarButtonState();
}

class _AddReminderAppBarButtonState extends State<AddReminderAppBarButton> {
  DateTime selectedDate = DateTime.now();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> _showAddReminderDialog() async {
    String title = '';
    int amount = 0;
    String? titleError;
    String? amountError;
    Category? selectedCategory;
    final categoryRepository = await _databaseHelper.categoryRepository();
    List<Category> availableCategories = await categoryRepository.findAll();

    if (availableCategories.isNotEmpty) {
      selectedCategory = availableCategories[0];
    }

    selectedDate = DateTime.now();

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
                        'Add Reminder',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onChanged: (value) {
                          title = value;
                          if (value.isNotEmpty) {
                            titleError = null;
                          }
                          setDialogState(() {});
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: TextStyle(color: Colors.grey[350]),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[350]!)),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.tealAccent)),
                          errorText: titleError,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onChanged: (value) {
                          amount = int.tryParse(value) ?? 0;
                          if (amount > 0) {
                            amountError = null;
                          }
                          setDialogState(() {});
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          labelStyle: TextStyle(color: Colors.grey[350]),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[350]!)),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.tealAccent)),
                          errorText: amountError,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        title: const Text('Date',
                            style: TextStyle(color: Colors.white)),
                        trailing: GestureDetector(
                          onTap: () => _selectDate(context, setDialogState),
                          child: Text(
                            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
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
                              bool isValid = true;
                              if (title.isEmpty) {
                                isValid = false;
                                titleError = 'Title is required';
                              }
                              if (amount <= 0) {
                                isValid = false;
                                amountError = 'Amount must be greater than 0';
                              }
                              if (isValid) {
                                widget.onSubmitted(title, amount, selectedDate,
                                    false, selectedCategory);
                                Navigator.of(context).pop();
                              } else {
                                setDialogState(() {});
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

  Future<void> _selectDate(
      BuildContext context, Function setDialogState) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setDialogState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomActionButton(
        actionButtonText: widget.actionButtonText,
        actionButtonOnPressed: _showAddReminderDialog,
        gradientColors: const [
          Color(0xFF00B686),
          Color(0xFF008A60),
          Color(0xff00573a),
        ]);
  }
}
