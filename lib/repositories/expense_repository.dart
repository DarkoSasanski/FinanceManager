import 'package:sqflite/sqflite.dart';

import '../models/Account.dart';
import '../models/Category.dart';
import '../models/Expense.dart';
import 'account_repository.dart';
import 'category_repository.dart';

class ExpenseRepository {
  final Database _db;
  final AccountRepository accountRepository;
  final CategoryRepository categoryRepository;

  ExpenseRepository(this._db, this.accountRepository, this.categoryRepository);

  Future<void> insertExpense(Expense expense) async {
    await _db.insert(
      'Expense',
      expense.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Expense> findById(int id) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'Expense',
      where: 'id = ?',
      whereArgs: [id],
    );

    Account account = await accountRepository.findById(maps[0]['account_id']);
    Category category =
        await categoryRepository.findById(maps[0]['category_id']);

    return Expense.withId(
      id: maps[0]['id'],
      description: maps[0]['description'],
      amount: maps[0]['amount'],
      date: DateTime.parse(maps[0]['date']),
      account: account,
      category: category,
    );
  }

  Future<List<Expense>> findAll() async {
    final List<Map<String, dynamic>> maps = await _db.query('Expense');
    List<Expense> expenses = [];

    for (var map in maps) {
      Account account = await accountRepository.findById(map['account_id']);
      Category category = await categoryRepository.findById(map['category_id']);

      Expense expense = Expense.withId(
        id: map['id'],
        description: map['description'],
        amount: map['amount'],
        date: DateTime.parse(map['date']),
        account: account,
        category: category,
      );

      expenses.add(expense);
    }

    return expenses;
  }
  Future<void> updateExpense(Expense expense) async {
    await _db.update(
      'Expense',
      expense.toJson(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }
  Future<void> deleteExpense(int id) async {
    await _db.delete(
      'Expense',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
