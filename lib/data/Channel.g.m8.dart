// GENERATED CODE - DO NOT MODIFY BY HAND
// Emitted on: 2019-12-28 00:16:51.093036

// **************************************************************************
// Generator: OrmM8GeneratorForAnnotation
// **************************************************************************

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:BlueRa/data/Channel.dart';

class ChannelProxy extends Channel {
  ChannelProxy({name, attending}) {
    this.name = name;
    this.attending = attending;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    map['attending'] = attending ? 1 : 0;

    return map;
  }

  ChannelProxy.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.attending = map['attending'] == 1 ? true : false;
  }
}

mixin ChannelDatabaseProvider {
  Future<Database> db;
  final theChannelColumns = ["id", "name", "attending"];

  final String theChannelTableHandler = 'channels';
  Future createChannelTable(Database db) async {
    await db.execute('''CREATE TABLE $theChannelTableHandler (
    id INTEGER  PRIMARY KEY AUTOINCREMENT,
    name TEXT  NOT NULL,
    attending INTEGER  NOT NULL,
    UNIQUE (id)
    )''');
  }

  Future<int> saveChannel(ChannelProxy instanceChannel) async {
    var dbClient = await db;

    var result =
        await dbClient.insert(theChannelTableHandler, instanceChannel.toMap());
    return result;
  }

  Future<List<ChannelProxy>> getChannelProxiesAll() async {
    var dbClient = await db;
    var result = await dbClient.query(theChannelTableHandler,
        columns: theChannelColumns, where: '1');

    return result.map((e) => ChannelProxy.fromMap(e)).toList();
  }

  Future<int> getChannelProxiesCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient
        .rawQuery('SELECT COUNT(*) FROM $theChannelTableHandler  WHERE 1'));
  }

  Future<ChannelProxy> getChannel(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(theChannelTableHandler,
        columns: theChannelColumns, where: '1 AND id = ?', whereArgs: [id]);

    if (result.length > 0) {
      return ChannelProxy.fromMap(result.first);
    }

    return null;
  }

  Future<int> deleteChannel(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(theChannelTableHandler, where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> deleteChannelProxiesAll() async {
    var dbClient = await db;
    await dbClient.delete(theChannelTableHandler);
    return true;
  }

  Future<int> updateChannel(ChannelProxy instanceChannel) async {
    var dbClient = await db;

    return await dbClient.update(
        theChannelTableHandler, instanceChannel.toMap(),
        where: "id = ?", whereArgs: [instanceChannel.id]);
  }
}
