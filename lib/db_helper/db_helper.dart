import 'package:notes_apps_sqtlite/model/notes_app_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';


class DBHelper{

  static Database? _db;

  Future<Database?> get db async{
    if(_db!= null){
      return _db;
    }
    _db = await initDatabase();
    return _db;

  }

  initDatabase()async{
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path =  join(documentDirectory.path, 'notes.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;

  }

  _onCreate(Database db, version)async{
await db.execute("CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, description TEXT NOT NULL)");
  }

  Future<NotesAppModel> insert(NotesAppModel notesAppModel)async{
    var dbClient = await db;

    await dbClient!.insert('notes', notesAppModel.toMap());
    return notesAppModel;
  }

  Future<List<NotesAppModel>>getNotesList()async{
    var dbClient = await db;
    final List<Map<String , Object?>> queryResult = await dbClient!.query('notes');
    return queryResult.map((e) => NotesAppModel.fromMap(e)).toList();

  }

  Future<int> deleteNotes(int id)async{
    var dbClient = await db;
    return await dbClient!.delete(
        'notes',
        where: 'id = ?',
        whereArgs: [id]
    );
  }


  Future<int> updatesNotes(NotesAppModel notesAppModel)async{
    var dbClient = await db;
    return await dbClient!.update(
        'notes',
        notesAppModel.toMap(),
        where: 'id = ?',
        whereArgs: [notesAppModel.id]
    );
  }



}