import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'calculator.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE calculations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        expression TEXT,
        result TEXT,
        date TEXT,
        note TEXT
      )
    ''');
  }

  Future<int> insertCalculation(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('calculations', row);
  }

  Future<List<Map<String, dynamic>>> getCalculations() async {
    Database db = await database;
    return await db.query('calculations', orderBy: 'id DESC');
  }

  Future<int> updateCalculation(int id, Map<String, dynamic> row) async {
    Database db = await database;
    return await db.update('calculations', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteCalculation(int id) async {
    Database db = await database;
    return await db.delete('calculations', where: 'id = ?', whereArgs: [id]);
  }
}
