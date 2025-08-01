import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static const _databaseName = "AppManager.db";
  static const _databaseVersion = 1;

  static const table = 'applications';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnBundleId = 'bundle_id';
  static const columnPath = 'path';
  static const columnCreatedAt = 'created_at';
  static const columnModifiedAt = 'modified_at';
  static const columnLastLaunchedAt = 'last_launched_at';
  static const columnSize = 'size';
  static const columnIconData = 'icon_data';
  static const columnIsSystemApp = 'is_system_app';

  DatabaseService._privateConstructor();
  static final DatabaseService instance = DatabaseService._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId TEXT PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnBundleId TEXT,
            $columnPath TEXT NOT NULL,
            $columnCreatedAt INTEGER NOT NULL,
            $columnModifiedAt INTEGER NOT NULL,
            $columnLastLaunchedAt INTEGER,
            $columnSize INTEGER NOT NULL,
            $columnIconData BLOB,
            $columnIsSystemApp INTEGER NOT NULL
          )
          ''');
  }
}
