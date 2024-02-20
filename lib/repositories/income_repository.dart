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
    List<Income> incomes = [];

    for (var map in maps) {
      try {
        Account? account = await accountRepository.findById(map['account_id']);
        if (account != null) {
          incomes.add(Income.withId(
            id: map['id'],
            description: map['description'],
            amount: map['amount'],
            date: DateTime.parse(map['date']),
            account: account,
            source: map['source'],
            isReceived: map['isReceived'] == 1,
          ));
        } else {
          print("Account not found for income ID: ${map['id']}");
        }
      } catch (e) {
        print("Error processing income ID: ${map['id']}, Error: $e");
      }
    }

    return incomes;
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

  Future<void> markAsReceived(int id) async {
    await _db.update(
      'Income',
      {'isReceived': true},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Income>> findByFilter(
      String status, int? selectedAccount, DateTime from, DateTime to) async {
    String args = 'date >= ? and date <= ?';
    List<Object> whereArgs = [from.toString(), to.toString()];

    if (status != 'All') {
      args += ' and isReceived = ?';
      whereArgs.add(status == 'Received' ? 1 : 0);
    }

    if (selectedAccount != null) {
      args += ' and account_id = ?';
      whereArgs.add(selectedAccount);
    }

    final List<Map<String, dynamic>> maps =
        await _db.query('Income', where: args, whereArgs: whereArgs);

    List<Income> incomes = [];
    for (var map in maps) {
      Account account = await accountRepository.findById(map['account_id']);
      incomes.add(Income.withId(
        id: map['id'],
        description: map['description'],
        amount: map['amount'],
        date: DateTime.parse(map['date']),
        account: account,
        source: map['source'],
        isReceived: map['isReceived'] == 1,
      ));
    }
    return incomes;
  }
}
