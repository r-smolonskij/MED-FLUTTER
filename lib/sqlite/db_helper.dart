//import 'dart:async';
//import 'dart:io' as io;
//import 'package:path/path.dart';
//import 'package:sqflite/sqflite.dart';
//import 'package:path_provider/path_provider.dart';
//import 'field.dart';
//import 'word.dart';
//
//class DBHelper  {
//  static Database _db;
//  //static const String ID = 'id';
//  //static const String NAME = 'name';
//  //static const String fieldsTABLE = 'fields';
//  static const String DB_NAME = 'database.db';
//
//  Future<Database> get db async {
//    if (_db != null) {
//      return _db;
//    }
//    _db = await initDb();
//    return _db;
//
//  }
//
//  initDb() async {
//    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
//    String path = join(documentsDirectory.path, DB_NAME);
//    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
//
//    return db;
//  }
//
//  _onCreate(Database db, int version) async {
//    await db
//        .execute("CREATE TABLE fields ( id INTEGER , titleLV TEXT, titleENG TEXT)");
//    await db
//        .execute("CREATE TABLE words ( id INTEGER PRIMARY KEY, wordLV TEXT, wordENG TEXT, typeID INTEGER)");
//    await db
//        .execute("CREATE TABLE words_field_relationship ( relationshipID INTEGER PRIMARY KEY, wordsID INTEGER, fieldsID INTEGER)");
//  }
//
//  /*Fields table functions*/
//  Future<Field> saveField(Field field) async {
//    var dbClient = await db;
//    await dbClient.transaction((txn) async {
//      var query = "INSERT INTO fields (id, titleLV, titleENG) VALUES (" + field.id.toString() + ", '" + field.titleLV + "', '" + field.titleENG + "')";
//      return await txn.rawInsert(query);
//    });
//  }
//
//  Future<List<Field>> getFields() async {
//    var dbClient = await db;
//    List<Map> maps = await dbClient.rawQuery("SELECT * FROM fields");
//    List<Field> fields = [];
//    if (maps.length > 0) {
//      for (int i = 0; i < maps.length; i++) {
//        fields.add(Field.fromMap(maps[i]));
//      }
//    }
//    print(fields.length.toString() +' = fields count');
//    return fields;
//  }
//
//  Future<int> getFieldsCount() async {
//    var dbClient = await db;
//    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM fields'));
//  }
//
//
//  Future<Field> getFieldByID(int ID) async {
//    var dbClient = await db;
//    List<Map> maps = await dbClient.rawQuery("SELECT * FROM fields WHERE id = "+ ID.toString());
//    List<Field> fields = [];
//    fields.add(Field.fromMap(maps[0]));
//    return fields[0];
//  }
//
//  /*Words table functions*/
//
//  Future<Word> saveWord(Word word) async {
//    var dbClient = await db;
//    await dbClient.transaction((txn) async {
//      var query = "INSERT INTO words (id, wordLV, wordENG, typeID) VALUES (" + word.id.toString() + ", '" + word.wordLV + "', '" + word.wordENG + "', '" + word.typeID.toString() + "')";
//      return await txn.rawInsert(query);
//    });
//  }
//
//  Future<Word> getWordByID(int ID) async {
//    var dbClient = await db;
//    List<Map> maps = await dbClient.rawQuery("SELECT * FROM words WHERE id = "+ ID.toString());
//    List<Word> words = [];
//    words.add(Word.fromMap(maps[0]));
//    return words[0];
//  }
//
//   Future<List<Word>> getWords() async {
//    var dbClient = await db;
//    List<Map> maps = await dbClient.rawQuery("SELECT * FROM words");
//    List<Word> words = [];
//    if (maps.length > 0) {
//      for (int i = 0; i < maps.length; i++) {
//        words.add(Word.fromMap(maps[i]));
//      }
//    }
//    return words;
//  }
//
//  Future<int> getWordsCount() async {
//    var dbClient = await db;
//    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM words'));
//  }
//
//  /*Words-Fields Relationship table functions*/
//
//  Future<Field> saveWordFieldsRelationship(int relationshipID, int wordID, int fieldID) async {
//    var dbClient = await db;
//    await dbClient.transaction((txn) async {
//      var query = "INSERT INTO words_field_relationship (relationshipID, wordsID, fieldsID) VALUES (" + relationshipID.toString() + ", " + wordID.toString() + ", " + fieldID.toString() + ")";
//      return await txn.rawInsert(query);
//    });
//  }
//
//  Future<List<Word>> getWordsByFieldID(int fieldID) async {
//    var dbClient = await db;
//    List<Map> maps = await dbClient.rawQuery("SELECT *  FROM words INNER JOIN words_field_relationship ON words_field_relationship.wordsID = words.id WHERE words_field_relationship.fieldsID = " + fieldID.toString() +" ORDER BY words.typeID");
//    List<Word> words = [];
//    if (maps.length > 0) {
//      for (int i = 0; i < maps.length; i++) {
//        words.add(Word.fromMap(maps[i]));
//      }
//    }
//    return words;
//  }
//
//  Future<List<Field>> getFieldsByWordID(int wordID) async {
//    var dbClient = await db;
//    List<Map> maps = await dbClient.rawQuery("SELECT *  FROM fields INNER JOIN words_field_relationship ON words_field_relationship.fieldsID = fields.id WHERE words_field_relationship.wordsID = " + wordID.toString());
//    List<Field> fields = [];
//    if (maps.length > 0) {
//      for (int i = 0; i < maps.length; i++) {
//        fields.add(Field.fromMap(maps[i]));
//      }
//    }
//    print(fields.length);
//    return fields;
//  }
//
//  Future close() async {
//    var dbClient = await db;
//    dbClient.close();
//  }
//
//
//}
