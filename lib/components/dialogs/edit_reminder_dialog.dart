import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../helpers/database_helper.dart';
import '../../models/Category.dart';
import '../../models/Reminder.dart';

class EditReminderDialog extends StatefulWidget {
  final String title;
  final int amount;
  final DateTime date;
  final bool isComplete;
  final Category category;

  const EditReminderDialog({
    Key? key,
    required this.title,
    required this.amount,
    required this.date,
    required this.isComplete,
    required this.category,
  }) : super(key: key);

  @override
  _EditReminderDialogState createState() => _EditReminderDialogState();
}

class _EditReminderDialogState extends State<EditReminderDialog> {
  late String title;
  late int amount;
  late DateTime date;
  late bool isComplete;
  late Category selectedCategory;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Category> categories = [];
  final _formKey = GlobalKey<FormState>();

  void _loadCategories() async {
    final categoryRepository = await _databaseHelper.categoryRepository();
    final loadedCategories = await categoryRepository.findAll();
    setState(() {
      categories = loadedCategories;
    });
  }

  @override
  void initState() {
    super.initState();
    title = widget.title;
    amount = widget.amount;
    date = widget.date;
    isComplete = widget.isComplete;
    selectedCategory = widget.category;
    _loadCategories();
  }

  Future<void> _selectDate(
      BuildContext context, Function setDialogState) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != date) {
      setDialogState(() {
        date = pickedDate;
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
                        'Edit Reminder',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onChanged: (value) => title = value,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: TextStyle(color: Colors.grey[350]),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[350]!),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.tealAccent),
                          ),
                        ),
                        initialValue: widget.title,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onChanged: (value) => amount = int.tryParse(value) ?? 0,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          labelStyle: TextStyle(color: Colors.grey[350]),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[350]!),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.tealAccent),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        initialValue: widget.amount.toString(),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value)! <= 0) {
                            return 'Please enter a valid amount';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<Category>(
                        decoration: InputDecoration(
                          labelText: 'Category',
                          labelStyle: TextStyle(color: Colors.grey[350]),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[350]!),
                          ),
                        ),
                        dropdownColor: const Color.fromRGBO(29, 31, 52, 1),
                        value: categories[0],
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.grey),
                        items: categories.map<DropdownMenuItem<Category>>(
                            (Category category) {
                          return DropdownMenuItem<Category>(
                            value: category,
                            child: Text(
                              category.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (Category? newValue) {
                          setDialogState(() {
                            selectedCategory = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        title: const Text('Date',
                            style: TextStyle(color: Colors.white)),
                        trailing: GestureDetector(
                          onTap: () => _selectDate(context, setDialogState),
                          child: Text(
                            '${date.day}/${date.month}/${date.year}',
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
                                Navigator.of(context).pop(Reminder(
                                  title: title,
                                  amount: amount,
                                  date: date,
                                  isComplete: isComplete,
                                  category: selectedCategory,
                                ));
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
            )),
      ),
    );
  }
}
