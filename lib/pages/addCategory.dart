import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../components/appBar/custom_app_bar.dart';
import '../components/sideMenu/side_menu.dart';
import '../models/Category.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<Category> categories = [];
  Color currentColor = Colors.blue;
  IconData currentIcon = Icons.home;
  List<IconData> availableIcons = [
    Icons.home,
    Icons.car_rental,
    Icons.fastfood,
    Icons.shopping_bag
  ];

  void _addCategory(String name) {
    setState(() {
      categories
          .add(Category(name: name, color: currentColor, icon: currentIcon));
    });
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (color) => setState(() => currentColor = color),
              showLabel: false,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
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
                      onTap: _showColorPicker,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          child: const Text('Cancel',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: currentColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            if (categoryName.isNotEmpty) {
                              _addCategory(categoryName);
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('Add',
                              style: TextStyle(color: Colors.white)),
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
    return Scaffold(
      appBar: CustomAppBar(
        title: "Categories",
        actionButtonText: "Add Category",
        actionButtonOnPressed: _showAddCategoryDialog,
      ),
      drawer: const SideMenu(),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: category.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(category.icon, size: 40, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    category.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
