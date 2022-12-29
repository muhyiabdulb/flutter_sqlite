import 'package:flutter/foundation.dart';

import 'package:flutter_sqlite/model/user.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nama_depan TEXT,
        nama_belakang TEXT,
        email TEXT,
        tanggal_lahir TEXT,
        jenis_kelamin TEXT,
        password TEXT,
        foto TEXT
      )
      """);
  }
// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'testing',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  // static Future<int> createItem(String title, String? descrption) async {
  //   final db = await SQLHelper.db();

  //   final data = {'title': title, 'description': descrption};
  //   final id = await db.insert('items', data,
  //       conflictAlgorithm: sql.ConflictAlgorithm.replace);
  //   return id;
  // }

  // // Read all items (journals)
  // static Future<List<JurnalModel>> getItems() async {
  //   final db = await SQLHelper.db();

  //   // Query the table for all The Dogs.
  //   final List<Map<String, dynamic>> maps = await db.query('items');

  //   // Convert the List<Map<String, dynamic> into a List<Dog>.
  //   return List.generate(maps.length, (i) {
  //     return JurnalModel(
  //       id: maps[i]['id'],
  //       title: maps[i]['title'],
  //       description: maps[i]['description'],
  //       createdAt: maps[i]['createdAt'],
  //     );
  //   });
  // }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  // static Future<List<Map<String, dynamic>>> getItem(int id) async {
  //   final db = await SQLHelper.db();
  //   return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  // }

  // Update an item by id
  // static Future<int> updateItem(
  //     int id, String title, String? descrption) async {
  //   final db = await SQLHelper.db();

  //   final data = {
  //     'title': title,
  //     'description': descrption,
  //     'createdAt': DateTime.now().toString()
  //   };

  //   final result =
  //       await db.update('items', data, where: "id = ?", whereArgs: [id]);
  //   return result;
  // }

  // Delete
  // static Future<void> deleteItem(int id) async {
  //   final db = await SQLHelper.db();
  //   try {
  //     await db.delete("items", where: "id = ?", whereArgs: [id]);
  //   } catch (err) {
  //     debugPrint("Something went wrong when deleting an item: $err");
  //   }
  // }

  // ===========================
  // user
  // ===========================
  static Future<int> createUser(UserModel user) async {
    final db = await SQLHelper.db();

    final id = await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<UserModel?> getLogin(String email, String password) async {
    var dbClient = await SQLHelper.db();
    var res = await dbClient.rawQuery(
        "SELECT * FROM users WHERE email = '$email' and password = '$password'");
    print("res ${res}");
    if (res.isNotEmpty) {
      return UserModel.fromJson(res.first);
    }

    return null;
  }

  static Future<int> updateUser(UserModel user) async {
    final db = await SQLHelper.db();

    final result = await db
        .update('users', user.toMap(), where: "id = ?", whereArgs: [user.id]);
    return result;
  }
}
