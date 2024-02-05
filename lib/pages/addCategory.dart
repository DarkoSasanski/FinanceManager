import 'package:flutter/material.dart';

import '../components/appBar/custom_app_bar.dart';
import '../components/buttons/add_category_app_bar_button.dart';
import '../components/sideMenu/side_menu.dart';
import '../models/Category.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<Category> categories = [];

  void _addCategory(String name, Color color, IconData icon) {
    setState(() {
      categories.add(Category(name: name, color: color, icon: icon));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Categories",
        appBarButton: AddCategoryAppBarButton(
          onSubmitted: _addCategory,
          actionButtonText: "Add Category",
        ),
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
