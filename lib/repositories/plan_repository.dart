import 'package:sqflite/sqflite.dart';

import '../models/Plan.dart';

class PlanRepository {
  final Database _db;

  PlanRepository(this._db);

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

    return Plan.withId(
      id: maps[0]['id'],
      type: maps[0]['type'],
      goalAmount: maps[0]['goalAmount'],
      currentAmount: maps[0]['currentAmount'],
      dateStart: DateTime.parse(maps[0]['dateStart']),
      dateEnd: DateTime.parse(maps[0]['dateEnd']),
    );
  }

  Future<List<Plan>> findAll() async {
    final List<Map<String, dynamic>> maps = await _db.query('Plan');

    List<Plan> plans = [];
    for (int i = 0; i < maps.length; i++) {
      plans.add(
        Plan.withId(
          id: maps[i]['id'],
          type: maps[i]['type'],
          goalAmount: maps[i]['goalAmount'],
          currentAmount: maps[i]['currentAmount'],
          dateStart: DateTime.parse(maps[i]['dateStart']),
          dateEnd: DateTime.parse(maps[i]['dateEnd']),
        ),
      );
    }

    return plans;
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

  Future<void> updatePlanCurrentAmount(int id, int newCurrentAmount) async {
    await _db.rawUpdate(
      'UPDATE Plan SET currentAmount = currentAmount + ? WHERE id = ?',
      [newCurrentAmount, id],
    );
  }

  Future<List<Plan>> findPlansByStatus(String status) async {
    if (status == 'All') {
      return findAll();
    }

    String condition = status == 'Completed'
        ? 'goalAmount <= currentAmount'
        : 'goalAmount > currentAmount';

    final List<Map<String, dynamic>> maps = await _db.query(
      'Plan',
      where: condition,
    );

    List<Plan> plans = [];
    for (int i = 0; i < maps.length; i++) {
      plans.add(
        Plan.withId(
          id: maps[i]['id'],
          type: maps[i]['type'],
          goalAmount: maps[i]['goalAmount'],
          currentAmount: maps[i]['currentAmount'],
          dateStart: DateTime.parse(maps[i]['dateStart']),
          dateEnd: DateTime.parse(maps[i]['dateEnd']),
        ),
      );
    }

    return plans;
  }
}
