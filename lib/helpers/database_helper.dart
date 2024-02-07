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
    return await openDatabase(path, version: 1, onCreate: _createTable);
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
    return PlanRepository(await database, await accountRepository());
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Category (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name VARCHAR(255) NOT NULL,
          codePoint INT NOT NULL,
          fontFamily VARCHAR(255) NOT NULL,
          fontPackage VARCHAR(255) NOT NULL,
          matchTextDirection BOOLEAN NOT NULL,
          color VARCHAR(255) NOT NULL
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
          FOREIGN KEY (account_id) REFERENCES Account(id),
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
          FOREIGN KEY (account_id) REFERENCES Account(id)
      );
      ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Plan (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          type VARCHAR(255) NOT NULL,
          amount INT NOT NULL,
          dateStart DATETIME NOT NULL,
          dateEnd DATETIME NOT NULL,
          account_id INT,
          FOREIGN KEY (account_id) REFERENCES Account(id)
      );
    ''');
  }
}
