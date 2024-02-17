import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import '../models/Category.dart';

class CategoryRepository {
  final Database _db;

  CategoryRepository(this._db);

  Future<void> insertCategory(Category category) async {
    await _db.insert(
      'Category',
      category.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Category> findById(int id) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'Category',
      where: 'id = ?',
      whereArgs: [id],
    );

    return Category.withId(
      id: maps[0]['id'],
      name: maps[0]['name'],
      color: Color(maps[0]['color']),
      icon: IconData(
        maps[0]['codePoint'],
        fontFamily: maps[0]['fontFamily'],
        fontPackage: maps[0]['fontPackage'],
        matchTextDirection: maps[0]['matchTextDirection'] == 1,
      ),
    );
  }

  Future<List<Category>> findAll() async {
    final List<Map<String, dynamic>> maps = await _db.query('Category');

    return List.generate(maps.length, (i) {
      return Category.withId(
        id: maps[i]['id'],
        name: maps[i]['name'],
        color: Color(maps[i]['color']),
        icon: IconData(
          maps[i]['codePoint'],
          fontFamily: maps[i]['fontFamily'],
          fontPackage: maps[i]['fontPackage'],
          matchTextDirection: maps[i]['matchTextDirection'] == 1,
        ),
      );
    });
  }

  Future<void> updateCategory(Category category) async {
    await _db.update(
      'Category',
      category.toJson(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<void> deleteCategory(int id) async {
    await _db.delete(
      'Category',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<Category, String>> fetchCategoryExpensesByMonthAndAccount(
      int month, int? accountId) async {
    final List<Map<String, dynamic>> maps = [];

    if (accountId == null) {
      maps.addAll(await _db.rawQuery(
        'SELECT category_id, SUM(amount) as total '
        'FROM Expense '
        'WHERE ltrim(strftime(\'%m\', date), \'0\') = ? '
        'AND strftime(\'%Y\', date) = strftime(\'%Y\', \'now\') '
        'GROUP BY category_id',
        [month.toString()],
      ));
    } else {
      maps.addAll(await _db.rawQuery(
        'SELECT category_id, SUM(amount) as total '
        'FROM Expense WHERE ltrim(strftime(\'%m\', date), \'0\') = ? '
        'AND strftime(\'%Y\', date) = strftime(\'%Y\', \'now\') '
        'AND account_id = ? '
        'GROUP BY category_id',
        [month.toString(), accountId.toString()],
      ));
    }

    Map<Category, String> categoryExpenses = {};
    for (var map in maps) {
      Category category = await findById(map['category_id']);
      categoryExpenses[category] = map['total'].toString();
    }

    return categoryExpenses;
  }

  Future<bool> doesCategoryExist(String name) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'Category',
      where: 'name = ?',
      whereArgs: [name],
    );

    return maps.isNotEmpty;
  }

  Future<Category> getCategoryByName(String name) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'Category',
      where: 'name = ?',
      whereArgs: [name],
    );

    return Category.withId(
      id: maps[0]['id'],
      name: maps[0]['name'],
      color: Color(maps[0]['color']),
      icon: IconData(
        maps[0]['codePoint'],
        fontFamily: maps[0]['fontFamily'],
        fontPackage: maps[0]['fontPackage'],
        matchTextDirection: maps[0]['matchTextDirection'] == 1,
      ),
    );
  }
}
