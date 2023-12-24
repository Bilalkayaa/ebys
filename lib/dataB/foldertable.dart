import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ebys/user/file.dart';

class DbHelperfile {
  Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database?> initializeDb() async {
    var dbPath = join(await getDatabasesPath(), "etrades.db");
    var eTradeDb = await openDatabase(dbPath, version: 1, onCreate: createDb);
    return eTradeDb;
  }

  void createDb(Database db, int version) async {
    db.execute(
        "Create TABLE files(id integer primary key AUTOINCREMENT,fromemployee integer,toemployee integer,path text,date text,flag integer)");
  }

  Future<List<file>> getfiles() async {
    Database? db = await this.db;
    var result = await db?.query("files");
    return List.generate(result!.length, (i) {
      return file.fromMap(result[i]);
    });
  }

  Future<int?> insert(file File) async {
    Database? db = await this.db;
    var result = await db?.insert("files", File.toMap());
    return result;
  }

  Future<int?> delete(int id) async {
    Database? db = await this.db;
    var result = await db?.rawInsert("Delete from files where id=$id");
    return result;
  }

  Future<void> deleteAllFiles() async {
    Database? db = await DbHelperfile().db;
    if (db != null) {
      await db.delete("files");
    }
  }

  Future<int?> updateFlag(int toEmployeeId) async {
    int newFlagValue = 0;
    Database? db = await this.db;
    var result = await db?.update(
      "files",
      {'flag': newFlagValue},
      where: "toemployee = ?",
      whereArgs: [toEmployeeId],
    );
    return result;
  }
}

//SELECT password FROM users WHERE email '$pw' 