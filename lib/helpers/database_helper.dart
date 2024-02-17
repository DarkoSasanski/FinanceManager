import 'package:financemanager/repositories/reminder_repository.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../repositories/account_repository.dart';
import '../repositories/category_repository.dart';
import '../repositories/expense_repository.dart';
import '../repositories/income_repository.dart';
import '../repositories/plan_repository.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'finance_manager.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createTable,
      onOpen: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<AccountRepository> accountRepository() async {
    return AccountRepository(await database);
  }

  Future<CategoryRepository> categoryRepository() async {
    return CategoryRepository(await database);
  }

  Future<ExpenseRepository> expenseRepository() async {
    return ExpenseRepository(
        await database, await accountRepository(), await categoryRepository());
  }

  Future<IncomeRepository> incomeRepository() async {
    return IncomeRepository(await database, await accountRepository());
  }

  Future<PlanRepository> planRepository() async {
    return PlanRepository(await database);
  }

  Future<ReminderRepository> reminderRepository() async {
    return ReminderRepository(
        await database, await accountRepository(), await categoryRepository());
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Category (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name VARCHAR(255) NOT NULL,
          codePoint INT NOT NULL,
          fontFamily VARCHAR(255),
          fontPackage VARCHAR(255),
          matchTextDirection BOOLEAN NOT NULL,
          color INT NOT NULL
      );
        ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Account (    
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name VARCHAR(255) NOT NULL,
          amount INT NOT NULL
      );
      ''');

    await db.execute('''  
      CREATE TABLE IF NOT EXISTS Expense (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          description VARCHAR(255) NOT NULL,
          amount INT NOT NULL,
          date DATETIME NOT NULL,
          account_id INT,
          category_id INT,
          FOREIGN KEY (account_id) REFERENCES Account(id) ON DELETE CASCADE,
          FOREIGN KEY (category_id) REFERENCES Category(id)
      );
      ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Income (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          source VARCHAR(255) NOT NULL,
          description VARCHAR(255) NOT NULL,
          amount INT NOT NULL,
          date DATETIME NOT NULL,
          account_id INT,
          isReceived BOOLEAN NOT NULL,
          FOREIGN KEY (account_id) REFERENCES Account(id) ON DELETE CASCADE
      );
      ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Plan (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          type VARCHAR(255) NOT NULL,
          goalAmount INT NOT NULL,
          currentAmount INT NOT NULL,
          dateStart DATETIME NOT NULL,
          dateEnd DATETIME NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Reminder (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title VARCHAR(255) NOT NULL,
          amount INT NOT NULL,
          date DATETIME NOT NULL,
          isComplete BOOLEAN NOT NULL,
          account_id INT,
          category_id INT,
          FOREIGN KEY (category_id) REFERENCES Category(id),
          FOREIGN KEY (account_id) REFERENCES Account(id) ON DELETE CASCADE
      );
    ''');
  }
}
