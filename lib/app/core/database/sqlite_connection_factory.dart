import 'package:flutter_todo_list/app/core/database/sqlite_migration_factory.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

class SqliteConnectionFactory {
  static const _VERSION = 1;
  static const _DATABASE_NAME = "todo_list_provider.db";
  static SqliteConnectionFactory? _instace;

  Database? _db;
  final Lock _lock = Lock();

  SqliteConnectionFactory._();

  factory SqliteConnectionFactory() {
    _instace ??= SqliteConnectionFactory._();

    return _instace!;
  }

  Future<Database> openConnection() async {
    final databasePath = await getDatabasesPath();
    final databasePathFinal = join(databasePath, _DATABASE_NAME);

    if (_db == null) {
      await _lock.synchronized(() async {
        _db ??= await openDatabase(
          databasePathFinal,
          version: _VERSION,
          onConfigure: _onConfigure,
          onDowngrade: _onDowngrade,
          onUpgrade: _onUpgrade,
          onCreate: _onCreate,
        );
      });
    }

    return _db!;
  }

  Future<void> closeConnection() async {
    await _db?.close();
    _db = null;
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int newVersion) async {
    final batch = db.batch();

    final migrations = SqliteMigrationFactory().getCreateMigration();

    for (var migration in migrations) {
      migration.create(batch);
    }

    await batch.commit();
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    final batch = db.batch();

    final migrations = SqliteMigrationFactory().getUpgradeMigration(oldVersion);

    for (var migration in migrations) {
      migration.update(batch);
    }

    await batch.commit();
  }

  Future<void> _onDowngrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {}
}
