import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

import 'userInfo.dart';

class DBHelper {
  static Database? db;
  static int version = 6;
  static String tableName = "users";

  static Future<void> initDb() async {
    if (db != null) {
      print("Not null DataBase");
      return;
    } else {
      try {
        String path = await getDatabasesPath() + 'task.db';
        db = await openDatabase(path, version: version,
            onCreate: (Database db, int version) async {
              // When creating the db, create the table
              await db.execute(
                  'CREATE TABLE $tableName ('
                      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
                      'name STRING , phone STRING , email STRING, password STRING'
              ')'
              );
            });
      } catch (e) {
        print(e);
      }
    }
  }

  static  Future<int> insert(User? user)async{ // تعيد id
    print("insert someThing");
    return await db!.insert(tableName, user!.toJson());    //بضيف البيانات ك ماب
  }


  static  Future<int> delete(int id)async{
    print("delete someThing");
    return await db!.delete(tableName,where: 'id=?',whereArgs: [id]);
  }


  static  Future<int> deleteAll()async{
    print("delete someThing");
    return await db!.delete(tableName);
  }


  static  Future<int> updateName(int id , String name)async{
    print("update someThing");
    return await db!.rawUpdate(''' 
    UPDATE users 
    SET name = ?
    WHERE id = ?
    ''',[name,id]);     // كل برمتر بينزل محل اشارة استفهام
  }



  static  Future<int> updatePhone(int id , String phone)async{
    print("update someThing");
    return await db!.rawUpdate(''' 
    UPDATE users 
    SET phone = ?
    WHERE id = ?
    ''',[phone,id]);     // كل برمتر بينزل محل اشارة استفهام
  }

  static  Future<int> updateEmail(int id , String email)async{
    print("update email");
    return await db!.rawUpdate(''' 
    UPDATE users 
    SET email = ?
    WHERE id = ?
    ''',[email,id]);     // كل برمتر بينزل محل اشارة استفهام
  }

  static  Future<int> updatePassword(int id , String pasword)async{
    print("update email");
    return await db!.rawUpdate(''' 
    UPDATE users 
    SET password = ?
    WHERE id = ?
    ''',[pasword,id]);     // كل برمتر بينزل محل اشارة استفهام
  }


  static  Future<List<Map<String, dynamic>>> query()async{
    print("query something");
    return await db!.query(tableName);
  }





}
