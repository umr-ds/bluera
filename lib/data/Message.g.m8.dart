// GENERATED CODE - DO NOT MODIFY BY HAND
// Emitted on: 2019-12-28 00:16:51.093036

// **************************************************************************
// Generator: OrmM8GeneratorForAnnotation
// **************************************************************************

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:BlueRa/data/Message.dart';

class MessageProxy extends Message {
  MessageProxy({channel, user, text, timestamp_ms, mine}) {
    this.channel = channel;
    this.user = user;
    this.text = text;
    this.timestamp_ms = timestamp_ms;
    this.mine = mine;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['channel'] = channel;
    map['user'] = user;
    map['lat'] = lat;
    map['lon'] = lon;
    map['text'] = text;
    map['timestamp'] = timestamp_ms;
    map['mine'] = mine ? 1 : 0;
    map['rssi'] = rssi;
    map['snr'] = snr;

    return map;
  }

  MessageProxy.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.channel = map['channel'];
    this.user = map['user'];
    this.lat = map['lat'];
    this.lon = map['lon'];
    this.text = map['text'];
    this.timestamp_ms = map['timestamp'];
    this.mine = map['mine'] == 1 ? true : false;
    this.rssi = map['rssi'];
    this.snr = map['snr'];
  }
}

mixin MessageDatabaseProvider {
  Future<Database> db;
  final theMessageColumns = [
    "id",
    "channel",
    "user",
    "lat",
    "lon",
    "text",
    "timestamp",
    "mine",
    "rssi",
    "snr"
  ];

  final String theMessageTableHandler = 'messages';
  Future createMessageTable(Database db) async {
    await db.execute('''CREATE TABLE $theMessageTableHandler (
    id INTEGER  PRIMARY KEY AUTOINCREMENT,
    channel TEXT  NOT NULL,
    user TEXT  NOT NULL,
    lat REAL ,
    lon REAL ,
    text TEXT  NOT NULL,
    timestamp INTEGER  NOT NULL,
    mine INTEGER  NOT NULL,
    rssi INTEGER ,
    snr INTEGER ,
    UNIQUE (id)
    )''');
  }

  Future<int> saveMessage(MessageProxy instanceMessage) async {
    var dbClient = await db;

    var result =
        await dbClient.insert(theMessageTableHandler, instanceMessage.toMap());
    return result;
  }

  Future<List<MessageProxy>> getMessageProxiesAll() async {
    var dbClient = await db;
    var result = await dbClient.query(theMessageTableHandler,
        columns: theMessageColumns, where: '1');

    return result.map((e) => MessageProxy.fromMap(e)).toList();
  }

  Future<int> getMessageProxiesCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient
        .rawQuery('SELECT COUNT(*) FROM $theMessageTableHandler  WHERE 1'));
  }

  Future<MessageProxy> getMessage(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(theMessageTableHandler,
        columns: theMessageColumns, where: '1 AND id = ?', whereArgs: [id]);

    if (result.length > 0) {
      return MessageProxy.fromMap(result.first);
    }

    return null;
  }

  Future<int> deleteMessage(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(theMessageTableHandler, where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> deleteMessageProxiesAll() async {
    var dbClient = await db;
    await dbClient.delete(theMessageTableHandler);
    return true;
  }

  Future<int> updateMessage(MessageProxy instanceMessage) async {
    var dbClient = await db;

    return await dbClient.update(
        theMessageTableHandler, instanceMessage.toMap(),
        where: "id = ?", whereArgs: [instanceMessage.id]);
  }
}
