import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'custom_action_button.dart';

class AddCategoryAppBarButton extends StatefulWidget {
  final void Function(String name, Color color, IconData icon) onSubmitted;
  final String actionButtonText;

  const AddCategoryAppBarButton(
      {super.key, required this.onSubmitted, required this.actionButtonText});

  @override
  State<AddCategoryAppBarButton> createState() =>
      _AddCategoryAppBarButtonState();
}

class _AddCategoryAppBarButtonState extends State<AddCategoryAppBarButton> {
  Color currentColor = Colors.blue;
  IconData currentIcon = Icons.home;
  List<IconData> availableIcons = [
    Icons.home,
    Icons.car_rental,
    Icons.fastfood,
    Icons.shopping_bag
  ];

  void _showColorPicker(Function setDialogState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (color) => setDialogState(() => currentColor = color),
              showLabel: false,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done',
                  style: TextStyle(color: Colors.tealAccent)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddCategoryDialog() {
    String categoryName = '';
    currentColor = Colors.blue;
    currentIcon = Icons.home;


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color.fromRGBO(29, 31, 52, 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: StatefulBuilder(
              builder: (context, setDialogState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Add Category',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      onChanged: (value) => categoryName = value,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Colors.grey[350]),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[350]!),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.tealAccent),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<IconData>(
                      decoration: InputDecoration(
                        labelText: 'Icon',
                        labelStyle: TextStyle(color: Colors.grey[350]),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[350]!),
                        ),
                      ),
                      dropdownColor: const Color.fromRGBO(29, 31, 52, 1),
                      value: currentIcon,
                      icon:
                          const Icon(Icons.arrow_drop_down, color: Colors.grey),
                      items: availableIcons
                          .map<DropdownMenuItem<IconData>>((IconData value) {
                        return DropdownMenuItem<IconData>(
                          value: value,
                          child: Row(
                            children: [
                              Icon(value, color: Colors.white),
                              const SizedBox(width: 10),
                              Text(
                                value == currentIcon ? '' : '',
                                style: TextStyle(
                                  color: Colors.grey[350],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (IconData? newValue) {
                        setDialogState(() {
                          if (newValue != null) {
                            currentIcon = newValue;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => _showColorPicker(setDialogState),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[350]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Color',
                              style: TextStyle(color: Colors.white),
                            ),
                            Icon(
                              Icons.color_lens,
                              color: currentColor,
                            ),
                          ],
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
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          onPressed: () {
                            if (categoryName.isNotEmpty) {
                              widget.onSubmitted(
                                  categoryName, currentColor, currentIcon);
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomActionButton(
        actionButtonText: widget.actionButtonText,
        actionButtonOnPressed: _showAddCategoryDialog,
        gradientColors: const [
          Color(0xFF00B686),
          Color(0xFF008A60),
          Color(0xff00573a),
        ]);
  }
}
