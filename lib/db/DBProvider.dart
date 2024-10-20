import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:book_reader/Book.dart';

class DBProvider {
  static Database? _database;
  DBProvider._constructor();
  static final DBProvider provider = DBProvider._constructor();
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    // if _database is null we instantiate it
    _database = await initDB();
    return _database!;
  }
  initDB() async {
    //Directory documentsDirectory = await getDatabasesPath();
    String path = join(await getDatabasesPath(), "books.db");
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Books (id INTEGER PRIMARY KEY NOT NULL, fileName TEXT, filePath TEXT, notes TEXT)");
    });
  }
}

//
// import 'dart:async';
// import 'package:book_reader/Book.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
//
// abstract class DB {
//
//     static Database? _db;
//
//     static int get _version => 1;
//
//     static Future<void> init() async {
//
//         if (_db != null) { return; }
//
//         try {
//             String _path = join(await getDatabasesPath(),'books.db');
//             _db = await openDatabase(_path, version: _version, onCreate: onCreate);
//         }
//         catch(ex) {
//             print(ex);
//         }
//     }
//
//     static FutureOr<void> onOpen(Database db, int version) async{
//         await db.execute('DROP TABLE Books');
//         print('Таблица успешно удалена');
//         await db.execute('CREATE TABLE Books (id INTEGER PRIMARY KEY NOT NULL, fileName TEXT, filePath TEXT, notes TEXT)');
//     }
//
//     static void onCreate(Database db, int version) async =>
//         await db.execute('CREATE TABLE Books (id INTEGER PRIMARY KEY NOT NULL, fileName TEXT, filePath TEXT, notes TEXT)');
//
//     static Future<List<Map<String, dynamic>>> query(String table) async => _db!.query(table);
//
//      static Future<List<Map<String, dynamic>>> getBook(String table, Book book) async => _db!.query(table, where: "id = ?", whereArgs: [book.id]);
//
//     static Future<int> insert(String table, Book book) async =>
//         await _db!.insert(table, book.toJson());
//
//     static Future<int> update(String table, Book book) async =>
//         await _db!.update(table, book.toJson(), where: 'id = ?', whereArgs: [book.id]);
//
//     static Future<int> delete(String table, Book book) async =>
//         await _db!.delete(table, where: 'id = ?', whereArgs: [book.id]);
//
//     // static Future<int> execute(String request) async =>
//     //     await _db!.execute(table, where: 'id = ?', whereArgs: [book.id]);
// }