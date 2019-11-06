import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'field.dart';
import 'word.dart';
import 'object.dart';
import 'dart:typed_data';

class DatabaseHelper{
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }
  DatabaseHelper.internal();
  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "database.db");

    // Only copy if the database doesn't exist
    //if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound){
    // Load database from asset and copy
    ByteData data = await rootBundle.load(join('lib/assets', 'database.db'));
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    // Save copied asset to documents
    await new File(path).writeAsBytes(bytes);
    //}
    var ourDb = await openDatabase(path);
    return ourDb;
  }
  Future<int> getObjectsCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM objects'));
  }
  Future<List<Field>> getFields() async {
    var dbClient = await db;
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM mytable( SELECT  *, ROW_NUMBER() OVER (PARTITION BY fieldID ORDER BY field DESC) rn FROM mytable)WHERE   rn = 1");
    List<Map> maps = await dbClient.rawQuery("SELECT DISTINCT fieldID, field FROM objects ORDER BY field");
    List<Field> fields = [];

    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        fields.add(Field.fromMap(maps[i]));
      }
    }

    return fields;
  }
  Future<Field> getFieldByID(int ID) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT DISTINCT fieldID, field FROM objects WHERE fieldID = "+ ID.toString());
    List<Field> fields = [];
    fields.add(Field.fromMap(maps[0]));
    return fields[0];
  }


  Future<List<Word>> getWords() async {
    var dbClient = await db;
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM mytable( SELECT  *, ROW_NUMBER() OVER (PARTITION BY fieldID ORDER BY field DESC) rn FROM mytable)WHERE   rn = 1");
    List<Map> maps = await dbClient.rawQuery("SELECT DISTINCT wordID, wordLV, wordENG, type  FROM objects");
    List<Word> words = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        words.add(Word.fromMap(maps[i]));
      }
    }
    return words;
  }
  Future<int> getFieldsCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(DISTINCT fieldID) FROM objects'));
  }

  Future<int> getWordsCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(DISTINCT wordID) FROM objects'));
  }
  Future<List<Word>> getWordsByFieldID(int fieldID) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT DISTINCT wordID, wordLV, wordENG, type  FROM objects WHERE fieldID = " + fieldID.toString() +";");
    List<Word> words = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        words.add(Word.fromMap(maps[i]));
      }
    }
    return words;
  }
  Future<List<Field>> getFieldsByWordID(int wordID) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT DISTINCT fieldID, field FROM objects WHERE wordID = " + wordID.toString() +";");
    List<Field> fields = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        fields.add(Field.fromMap(maps[i]));
      }
    }
    return fields;
  }
  Future<Word> getWordByID(int ID) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM objects WHERE wordID = "+ ID.toString());
    List<Word> words = [];
    words.add(Word.fromMap(maps[0]));
    return words[0];
  }


}