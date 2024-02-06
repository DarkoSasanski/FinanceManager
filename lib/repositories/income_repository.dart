import 'package:sqflite/sqflite.dart';

import '../models/Account.dart';
import '../models/Income.dart';
import 'account_repository.dart';

class IncomeRepository {
  final Database _db;
  final AccountRepository accountRepository;

  IncomeRepository(this._db, this.accountRepository);

  Future<void> insertIncome(Income income) async {
    await _db.insert(
      'Income',
      income.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Income> findById(int id) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'Income',
      where: 'id = ?',
      whereArgs: [id],
    );

    Account account = await accountRepository.findById(maps[0]['account_id']);

    return Income.withId(
      id: maps[0]['id'],
      description: maps[0]['description'],
      amount: maps[0]['amount'],
      date: DateTime.parse(maps[0]['date']),
      account: account,
      source: maps[0]['source'],
      isReceived: maps[0]['isReceived'],
    );
  }

  Future<List<Income>> findAll() async {
    final List<Map<String, dynamic>> maps = await _db.query('Income');

    return List.generate(
        maps.length,
        (i) async {
          Account account =
              await accountRepository.findById(maps[i]['account_id']);

          return Income.withId(
            id: maps[i]['id'],
            description: maps[i]['description'],
            amount: maps[i]['amount'],
            date: DateTime.parse(maps[i]['date']),
            account: account,
            source: maps[i]['source'],
            isReceived: maps[i]['isReceived'],
          );
        } as Income Function(int index));
  }

  Future<void> updateIncome(Income income) async {
    await _db.update(
      'Income',
      income.toJson(),
      where: 'id = ?',
      whereArgs: [income.id],
    );
  }

  Future<void> deleteIncome(int id) async {
    await _db.delete(
      'Income',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
