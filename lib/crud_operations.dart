import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;
import 'student.dart';
import 'package:path/path.dart';


//CLASE DE LA BASE DE DATOS
class DBHelper {
  static Database _db;
  //CAMPOS DE LA TABLA
  static const String Id = 'controlnum';
  static const String name = 'name';
  static const String lastname1 = 'lastname1';
  static const String lastname2 = 'lastname2';
  static const String email = 'email';
  static const String phone = 'phone';
  static const String matricula = 'matricula';
  //NOMBRE DE LA TABLA
  static const String TABLE = 'Students';
  //NOMBRE DE LA BASE DE DATOS
  static const String DB_NAME = 'students03.db';


  //CREACION DE LA BASE DE DATOS (VERIFICAR EXISTENCIA)
  Future<Database> get db async {
    //SI ES DIFERENTE DE NULL RETORNARÁ LA BASE DE DATOS
    if (_db != null) {
      return _db;
    } else {
      //SI NO VAMOS A CREAR EL METODO
      _db = await initDb();
      return _db;
    }
  }

  //DATABASE CREATION
  initDb() async {
    //VARIABLE PARA RUTA DE LOS ARCHIVOS DE LA APLICACION
    io.Directory appDirectory = await getApplicationDocumentsDirectory();
    print(appDirectory);
    String path = join(appDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute("CREATE TABLE $TABLE ($Id INTEGER PRIMARY KEY, $name TEXT, $lastname1 TEXT, $lastname2 TEXT, $email TEXT, $phone TEXT, $matricula TEXT)");
  }

  //EQUIVALENTE A SELECT
  Future<List<Student>> getStudents() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [Id, name, lastname1, lastname2, email, phone, matricula]);
    List<Student> studentss = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        studentss.add(Student.fromMap(maps[i]));
      }
    }
    return studentss;
  }

  //EQUIVALENTE A SAVE O INSERT
  Future<bool> validateInsert(Student student) async {
    var dbClient = await db;
    var code = student.matricula;
    List<Map> maps = await dbClient
        .rawQuery("select $Id from $TABLE where $matricula = $code");
    if (maps.length == 0) {
      return true;
    }else{
      return false;
    }
  }
  Future<Student> insert(Student student) async {
    var dbClient = await db;
    student.controlnum = await dbClient.insert(TABLE, student.toMap());
  }

  //EQUIVALENTE A DELETE
  Future<int> delete(int id) async{
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$Id = ?', whereArgs: [id]);
  }

  //EQUIVALENTE A UPDATE
  Future<int> update(Student student) async{
    var dbClient = await db;
    return await dbClient.update(TABLE, student.toMap(),
        where: '$Id = ?', whereArgs: [student.controlnum]);
  }

  //CLOSE DATABASE
  Future closedb()async{
    var dbClient = await db;
    dbClient.close();
  }
}


