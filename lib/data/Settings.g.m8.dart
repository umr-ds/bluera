// GENERATED CODE - DO NOT MODIFY BY HAND
// Emitted on: 2019-12-28 00:24:53.760928

// **************************************************************************
// Generator: OrmM8GeneratorForAnnotation
// **************************************************************************

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:BlueRa/data/Settings.dart';

class SettingsProxy extends Settings {
  SettingsProxy({user}) {
    this.user = user;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['user'] = user;

    return map;
  }

  SettingsProxy.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.user = map['user'];
  }
}

mixin SettingsDatabaseProvider {
  Future<Database> db;
  final theSettingsColumns = ["id", "user"];

  final String theSettingsTableHandler = 'settings';
  Future createSettingsTable(Database db) async {
    await db.execute('''CREATE TABLE $theSettingsTableHandler (
    id INTEGER  PRIMARY KEY AUTOINCREMENT,
    user TEXT  NOT NULL,
    UNIQUE (id)
    )''');
  }

  Future<int> saveSettings(SettingsProxy instanceSettings) async {
    var dbClient = await db;

    var result = await dbClient.insert(
        theSettingsTableHandler, instanceSettings.toMap());
    return result;
  }

  Future<List<SettingsProxy>> getSettingsProxiesAll() async {
    var dbClient = await db;
    var result = await dbClient.query(theSettingsTableHandler,
        columns: theSettingsColumns, where: '1');

    return result.map((e) => SettingsProxy.fromMap(e)).toList();
  }

  Future<int> getSettingsProxiesCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient
        .rawQuery('SELECT COUNT(*) FROM $theSettingsTableHandler  WHERE 1'));
  }

  Future<SettingsProxy> getSettings(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(theSettingsTableHandler,
        columns: theSettingsColumns, where: '1 AND id = ?', whereArgs: [id]);

    if (result.length > 0) {
      return SettingsProxy.fromMap(result.first);
    }

    return null;
  }

  Future<int> deleteSettings(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(theSettingsTableHandler, where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> deleteSettingsProxiesAll() async {
    var dbClient = await db;
    await dbClient.delete(theSettingsTableHandler);
    return true;
  }

  Future<int> updateSettings(SettingsProxy instanceSettings) async {
    var dbClient = await db;

    return await dbClient.update(
        theSettingsTableHandler, instanceSettings.toMap(),
        where: "id = ?", whereArgs: [instanceSettings.id]);
  }
}
