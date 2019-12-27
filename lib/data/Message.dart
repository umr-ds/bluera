import 'package:f_orm_m8/f_orm_m8.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'package:BlueRa/data/Message.g.m8.dart';

@DataTable("messages")
class Message implements DbEntity {
  @DataColumn("id",
      metadataLevel: ColumnMetadata.primaryKey |
          ColumnMetadata.unique |
          ColumnMetadata.autoIncrement)
  int id;

  // on-air message parts
  @DataColumn("channel", metadataLevel: ColumnMetadata.notNull)
  String channel;
  @DataColumn("user", metadataLevel: ColumnMetadata.notNull)
  String user;
  @DataColumn("lat")
  double lat;
  @DataColumn("lon")
  double lon;
  @DataColumn("text", metadataLevel: ColumnMetadata.notNull)
  String text;

  // meta data
  @DataColumn("timestamp", metadataLevel: ColumnMetadata.notNull)
  int timestamp_ms;
  @DataColumn("mine", metadataLevel: ColumnMetadata.notNull)
  bool mine;
  @DataColumn("rssi")
  int rssi;
  @DataColumn("snr")
  int snr;

  Message();

  Message.parse(String completeMessage, int rssi, int snr) {
    List<String> messageParts = completeMessage.split("|");

    this.channel = messageParts[0];
    this.user = messageParts[1];

    if (messageParts.length == 0) {
      List<String> lonLatStringList = messageParts[2].split(",");
      this.lat = double.parse(lonLatStringList[1]);
      this.lon = double.parse(lonLatStringList[0]);
    }

    this.text = messageParts.sublist(3).join("|");
    this.timestamp_ms = DateTime.now().toUtc().millisecondsSinceEpoch;
    this.mine = false;
    this.rssi = rssi;
    this.snr = snr;
  }
}

mixin MessageDatabaseQuery on MessageDatabaseProvider {
  Future<List<MessageProxy>> getMessageProxiesWhere(String where) async {
    var dbClient = await db;
    var result = await dbClient.query(theMessageTableHandler,
        columns: theMessageColumns, where: where);

    return result.map((e) => MessageProxy.fromMap(e)).toList();
  }
}
