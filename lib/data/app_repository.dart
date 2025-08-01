import 'package:myapp/data/database_service.dart';
import 'package:myapp/models/app_entity.dart';
import 'package:sqflite/sqflite.dart';

class AppRepository {
  final dbService = DatabaseService.instance;

  Future<int> insert(AppEntity app) async {
    Database db = await dbService.database;
    return await db.insert(DatabaseService.table, _appToMap(app));
  }

  Future<List<AppEntity>> getAllApps() async {
    Database db = await dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(DatabaseService.table);

    return List.generate(maps.length, (i) {
      return _mapToApp(maps[i]);
    });
  }

  Future<int> update(AppEntity app) async {
    Database db = await dbService.database;
    return await db.update(DatabaseService.table, _appToMap(app),
        where: '${DatabaseService.columnId} = ?', whereArgs: [app.id]);
  }

  Future<int> delete(String id) async {
    Database db = await dbService.database;
    return await db.delete(DatabaseService.table,
        where: '${DatabaseService.columnId} = ?', whereArgs: [id]);
  }

  Future<void> clearAll() async {
    Database db = await dbService.database;
    await db.delete(DatabaseService.table);
  }

  Map<String, dynamic> _appToMap(AppEntity app) {
    return {
      DatabaseService.columnId: app.id,
      DatabaseService.columnName: app.name,
      DatabaseService.columnBundleId: app.bundleId,
      DatabaseService.columnPath: app.path,
      DatabaseService.columnCreatedAt: app.createdAt.millisecondsSinceEpoch,
      DatabaseService.columnModifiedAt: app.modifiedAt.millisecondsSinceEpoch,
      DatabaseService.columnLastLaunchedAt: app.lastLaunchedAt.millisecondsSinceEpoch,
      DatabaseService.columnSize: app.size,
      DatabaseService.columnIconData: app.iconData,
      DatabaseService.columnIsSystemApp: app.isSystemApp ? 1 : 0,
    };
  }

  AppEntity _mapToApp(Map<String, dynamic> map) {
    return AppEntity(
      id: map[DatabaseService.columnId],
      name: map[DatabaseService.columnName],
      bundleId: map[DatabaseService.columnBundleId],
      path: map[DatabaseService.columnPath],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map[DatabaseService.columnCreatedAt]),
      modifiedAt: DateTime.fromMillisecondsSinceEpoch(map[DatabaseService.columnModifiedAt]),
      lastLaunchedAt: DateTime.fromMillisecondsSinceEpoch(map[DatabaseService.columnLastLaunchedAt]),
      size: map[DatabaseService.columnSize],
      iconData: map[DatabaseService.columnIconData],
      isSystemApp: map[DatabaseService.columnIsSystemApp] == 1,
    );
  }
}
