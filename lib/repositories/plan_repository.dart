import 'package:sqflite/sqflite.dart';

import '../models/Account.dart';
import '../models/Plan.dart';
import 'account_repository.dart';

class PlanRepository {
  final Database _db;

  final AccountRepository accountRepository;

  PlanRepository(this._db, this.accountRepository);

  Future<void> insertPlan(Plan plan) async {
    await _db.insert(
      'Plan',
      plan.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Plan> findById(int id) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'Plan',
      where: 'id = ?',
      whereArgs: [id],
    );

    Account account = await accountRepository.findById(maps[0]['account_id']);

    return Plan.withId(
      id: maps[0]['id'],
      type: maps[0]['type'],
      amount: maps[0]['amount'],
      dateStart: DateTime.parse(maps[0]['dateStart']),
      dateEnd: DateTime.parse(maps[0]['dateEnd']),
      account: account,
    );
  }

  Future<List<Plan>> findAll() async {
    final List<Map<String, dynamic>> maps = await _db.query('Plan');

    return List.generate(
        maps.length,
        (i) async {
          Account account =
              await accountRepository.findById(maps[i]['account_id']);

          return Plan.withId(
            id: maps[i]['id'],
            type: maps[i]['type'],
            amount: maps[i]['amount'],
            dateStart: DateTime.parse(maps[i]['dateStart']),
            dateEnd: DateTime.parse(maps[i]['dateEnd']),
            account: account,
          );
        } as Plan Function(int index));
  }

  Future<void> updatePlan(Plan plan) async {
    await _db.update(
      'Plan',
      plan.toJson(),
      where: 'id = ?',
      whereArgs: [plan.id],
    );
  }

  Future<void> deletePlan(int id) async {
    await _db.delete(
      'Plan',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
