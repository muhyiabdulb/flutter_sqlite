import 'package:flutter/foundation.dart';

import 'package:flutter_sqlite/model/user.dart';
import 'package:sqflite/sqflite.dart' as sql;

// INI SQLHELPER

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

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'testing',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

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
