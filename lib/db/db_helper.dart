// lib/db_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';

class DBHelper {
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();
  static Database? _db;

  static const int _version = 2; // زوّدنا النسخة إلى 2
  static const String _tableName = 'tasks';

  Future<Database> get mydb async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    try {
      String _path = join(await getDatabasesPath(), 'tasks.db');
      return await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) async {
          await db.execute(
            '''
            CREATE TABLE $_tableName(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT,
              description TEXT,
              priority TEXT,
              dueDate TEXT,
              isCompleted INTEGER,
              category TEXT,
              createdAt TEXT,
              typeId INTEGER
            )
            ''',
          );

          await db.execute('''
            CREATE TABLE task_types (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL UNIQUE
            )
          ''');

          // أنواع افتراضية
          await db.insert('task_types', {'name': 'General'});
          await db.insert('task_types', {'name': 'Work'});
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute('''
              CREATE TABLE IF NOT EXISTS task_types (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL UNIQUE
              )
            ''');

            // حاول نضيف العمود typeId لو مش موجود
            try {
              await db.execute('ALTER TABLE $_tableName ADD COLUMN typeId INTEGER;');
            } catch (e) {
              print('Warning adding typeId column: $e');
            }

            // أنواع افتراضية بعد الترقية (اختياري، لن تتكرر بسبب UNIQUE)
            await db.insert('task_types', {'name': 'General'});
            await db.insert('task_types', {'name': 'Work'});
          }
        },
      );
    } catch (e) {
      print("DB Init Error: $e");
      rethrow;
    }
  }

  // ===== CRUD Methods for tasks =====
  Future<int> insert(Task task) async {
    final db = await mydb;
    return await db.insert(_tableName, task.toJson());
  }

  Future<List<Map<String, dynamic>>> query() async {
    final db = await mydb;
    return await db.query(_tableName);
  }

  Future<int> delete(Task task) async {
    final db = await mydb;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> updateCompleted(int id) async {
    final db = await mydb;
    return await db.rawUpdate(
      '''
      UPDATE $_tableName
      SET isCompleted = ?
      WHERE id = ?
      ''',
      [1, id],
    );
  }

  Future<int> updateTask(Task task) async {
    final db = await mydb;
    return await db.update(
      _tableName,
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // ===== Methods for task types =====
  Future<List<Map<String, dynamic>>> getAllTypes() async {
    final db = await mydb;
    return await db.query('task_types', orderBy: 'name');
  }

  Future<int> insertType(String name) async {
    final db = await mydb;
    return await db.insert(
      'task_types',
      {'name': name},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future close() async {
    final db = await mydb;
    db.close();
  }
}
