import 'dart:convert';
import 'package:f_orm_m8/f_orm_m8.dart';
import 'package:convert/convert.dart';

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

  String toHex() {
    String location = "";
    if ((this.lat != null) && (this.lon != null)) {
      location = this.lat.toString() + "," + this.lon.toString();
    }

    final String completeMessage =
        this.channel + "|" + this.user + "|" + location + "|" + this.text;
    return hex.encode(utf8.encode(completeMessage)) + "\n";
  }
}

mixin MessageProxyConstructor on MessageProxy {
  static MessageProxy fromHex(String hexBuffer, int rssi, int snr) {
    List<int> decodedHex = hex.decode(hexBuffer);
    String completeMessage = new String.fromCharCodes(decodedHex);
    List<String> messageParts = completeMessage.split("|");

    MessageProxy msg = new MessageProxy(
      channel: messageParts[0],
      user: messageParts[1],
      text: messageParts.sublist(3).join("|"),
      timestamp_ms: DateTime.now().toUtc().millisecondsSinceEpoch,
      mine: false,
    );

    if (messageParts.length == 0) {
      List<String> lonLatStringList = messageParts[2].split(",");
      msg.lat = double.parse(lonLatStringList[1]);
      msg.lon = double.parse(lonLatStringList[0]);
    }

    msg.rssi = rssi;
    msg.snr = snr;

    return msg;
  }
}
