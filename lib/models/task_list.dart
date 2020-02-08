import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../models/task.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String taskTable = 'task_table';
  String colId = 'id';
  String colEvent = 'event';
  String colCategory  = 'category';
  String colElapsed = 'elapsed';

  DatabaseHelper._createInstance();

  factory DatabaseHelper(){
    if(_databaseHelper == null){
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  // Database getter
  Future<Database> get database async {
    if (_database == null)
      _database = await initializeDatabase();
    return _database;
  }

  // Initialize database
  Future<Database> initializeDatabase() async {
    // Get directory path for both android and iOS to store db file
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path + 'tasks.db');

    var tasksDB = await openDatabase(path, version: 1, onCreate: _createDB);
    return tasksDB;
  }

  Future<void> _createDB(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $taskTable ($colId TEXT PRIMARY KEY, $colEvent TEXT, $colCategory TEXT, $colElapsed TEXT)');
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await this.database;
    var result = await db.query(taskTable, orderBy: '$colId ASC');
    return result;
  }

  Future<int> insertTask(Task t) async {
    Database db = await this.database;
    var result = await db.insert(taskTable, t.toMap(),);
    return result;
  }

  Future<int> updateTask(Task t) async {
    var db = await this.database;
    var result = db.update(taskTable, t.toMap(), where: '$colId = ?', whereArgs: [t.id]);
    return result;
  }

  Future<int> deleteTask(String id) async {
    var db = await this.database;
    int result = await db.delete(taskTable, where: '$colId = ?', whereArgs: [id]);
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) FROM $taskTable'); 
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get List<Task> from database
  Future<List<Task>> getTaskList() async {
    var taskMapList = await getTaskMapList();
    int count = taskMapList.length;

    List<Task> taskList = List<Task>();
    for (var i = 0; i < count; i++) {
      taskList.add(Task.fromMap(taskMapList[i]));
    }

    return taskList;
  }
}
