import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../user/user.dart';

class DbHelper {
  Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database?> initializeDb() async {
    var dbPath = join(await getDatabasesPath(), "etrade.db");
    var eTradeDb = await openDatabase(dbPath, version: 1, onCreate: createDb);
    return eTradeDb;
  }

  void createDb(Database db, int version) async {
    db.execute(
        "Create TABLE users(id integer primary key AUTOINCREMENT,name text,lastName text,email text,password text)");
    db.execute(
        "INSERT INTO users(name, lastName, email, password)VALUES ('barış', 'cilak', 'baris', '123')");
    db.execute(
        "INSERT INTO users(name, lastName, email, password)VALUES ('bilal', 'kaya', 'bilal', '123')");
    db.execute(
        "INSERT INTO users(name, lastName, email, password)VALUES ('omer', 'kekec', 'omer', '123')");
    db.execute(
        "INSERT INTO users(name, lastName, email, password)VALUES ('faruk', 'atilla', 'faruk', '123')");
  }

  Future<List<user>> getusers() async {
    Database? db = await this.db;
    var result = await db?.query("users");
    return List.generate(result!.length, (i) {
      return user.fromObject(result[i]);
    });
  }

  Future<int?> insert(user User) async {
    Database? db = await this.db;
    var result = await db?.insert("users", User.toMap());
    return result;
  }

  Future<int?> delete(int id) async {
    Database? db = await this.db;
    var result = await db?.rawInsert("Delete from users where id=$id");
    return result;
  }

  Future<int?> update(user User) async {
    Database? db = await this.db;
    var result = await db
        ?.update("users", User.toMap(), where: "id=?", whereArgs: [User.id]);
    return result;
  }
}

//SELECT password FROM users WHERE email '$pw' 