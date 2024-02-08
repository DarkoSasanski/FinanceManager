import 'package:sqflite/sqflite.dart';

import '../models/Account.dart';
import '../models/Category.dart';
import '../models/Plan.dart';
import '../models/Reminder.dart';
import 'account_repository.dart';
import 'category_repository.dart';

class ReminderRepository {
  final Database _db;
  final AccountRepository accountRepository;
  final CategoryRepository categoryRepository;

  ReminderRepository(this._db, this.accountRepository, this.categoryRepository);

  Future<void> insertReminder(Reminder reminder) async {
    await _db.insert(
      'Reminder',
      reminder.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Reminder> findById(int id) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'Reminder',
      where: 'id = ?',
      whereArgs: [id],
    );

    Category category =
    await categoryRepository.findById(maps[0]['category_id']);

    return Reminder.withId(
      id: maps[0]['id'],
      title: maps[0]['title'],
      amount: maps[0]['amount'],
      date: DateTime.parse(maps[0]['date']),
      isComplete: maps[0]['isComplete'],
      category: category
    );
  }

  Future<List<Reminder>> findAll() async {
    final List<Map<String, dynamic>> maps = await _db.query('Reminder');

    return List.generate(
        maps.length,
            (i) async {
              Category category =
              await categoryRepository.findById(maps[i]['category_id']);

              return Reminder.withId(
                id: maps[0]['id'],
                title: maps[0]['title'],
                amount: maps[0]['amount'],
                date: DateTime.parse(maps[0]['date']),
                isComplete: maps[0]['isComplete'],
                category: category
          );
        } as Reminder Function(int index));
  }

  Future<void> updateReminder(Reminder reminder) async {
    await _db.update(
      'Reminder',
      reminder.toJson(),
      where: 'id = ?',
      whereArgs: [reminder.id],
    );
  }

  Future<void> deleteReminder(int id) async {
    await _db.delete(
      'Reminder',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}