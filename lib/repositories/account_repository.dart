import 'package:sqflite/sqflite.dart';

import '../models/Account.dart';

class AccountRepository {
  final Database _db;

  AccountRepository(this._db);

  Future<void> insertAccount(Account account) async {
    await _db.insert(
      'Account',
      account.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Account> findById(int id) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'Account',
      where: 'id = ?',
      whereArgs: [id],
    );

    return Account.withId(
      id: maps[0]['id'],
      name: maps[0]['name'],
      amount: maps[0]['amount'],
    );
  }

  Future<List<Account>> findAll() async {
    final List<Map<String, dynamic>> maps = await _db.query('Account');

    return List.generate(maps.length, (i) {
      return Account.withId(
        id: maps[i]['id'],
        name: maps[i]['name'],
        amount: maps[i]['amount'],
      );
    });
  }

  Future<void> updateAccount(Account account) async {
    await _db.update(
      'Account',
      account.toJson(),
      where: 'id = ?',
      whereArgs: [account.id],
    );
  }

  Future<void> deleteAccount(int id) async {
    await _db.delete(
      'Account',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateAmount(Account account) async {
    await _db.update(
      'Account',
      {'amount': account.amount},
      where: 'id = ?',
      whereArgs: [account.id],
    );
  }

  Future<void> addAmount(int id, int addAmount) async {
    await _db.rawUpdate(
      'UPDATE Account SET amount = amount + ? WHERE id = ?',
      [addAmount, id],
    );
  }

  Future<void> removeAmount(int id, int removeAmount) async {
    await _db.rawUpdate(
      'UPDATE Account SET amount = amount - ? WHERE id = ?',
      [removeAmount, id],
    );
  }
}
