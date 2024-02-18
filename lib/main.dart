import 'dart:io' as io;

import 'package:financemanager/helpers/database_helper.dart';
import 'package:financemanager/pages/dashboard.dart';
import 'package:financemanager/repositories/category_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'models/Category.dart' as category;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper databaseHelper = DatabaseHelper();
  await databaseHelper.database;
  setUpDefaultCategories(databaseHelper);
  runApp(const MyApp());
}

Future<void> setUpDefaultCategories(DatabaseHelper databaseHelper) async {
  CategoryRepository categoryRepository =
      await databaseHelper.categoryRepository();

  if (!await categoryRepository
      .doesCategoryExist(category.Category.TRANSFER_CATEGORY_NAME)) {
    await categoryRepository.insertCategory(category.Category(
      name: category.Category.TRANSFER_CATEGORY_NAME,
      color: const Color.fromRGBO(224, 221, 36, 1),
      icon: Icons.swap_horiz,
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    checkAndRequestPermission();

    return MaterialApp(
      title: 'Finance Manager',
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(16, 19, 37, 1),
        hintColor: Colors.tealAccent[400],
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.tealAccent[400],
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: const Color.fromRGBO(16, 19, 37, 1)),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(16, 19, 37, 1),
          actionsIconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 24, color: Colors.white),
          titleMedium: TextStyle(fontSize: 20, color: Colors.white70),
          labelLarge: TextStyle(fontSize: 18, color: Colors.white),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(16, 19, 37, 1),
          background: const Color.fromRGBO(16, 19, 37, 1),
        ),
        useMaterial3: true,
      ),
      home: const Dashboard(),
    );
  }

  void checkAndRequestPermission() async {
    if (await hasExactAlarmPermission()) {
      // Permission is already granted
      if (kDebugMode) {
        print("Exact alarm permission is granted.");
      }
    } else {
      // Permission is not granted, request it
      await requestExactAlarmPermission();
    }
  }

  Future<bool> hasExactAlarmPermission() async {
    if (io.Platform.isAndroid) {
      if (await Permission.scheduleExactAlarm.isGranted) {
        return true;
      }
    }
    return false; // On non-Android platforms, assume the permission is granted
  }

  Future<void> requestExactAlarmPermission() async {
    if (io.Platform.isAndroid) {
      await Permission.scheduleExactAlarm.request();
    }
  }
}
