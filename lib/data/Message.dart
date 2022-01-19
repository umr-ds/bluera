import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:cbor/cbor.dart';

class Message {
  final String channel;
  final String user;
  final LocationData location;
  final String text;

  final String timestamp;
  final bool isLocalUser;

  double rssi;
  double snr;

  Message(this.channel, this.user, this.location, this.text, this.timestamp, this.isLocalUser);

  static Message fromCbor(List<int> cborMessage, bool isLocalUser) {
    // decode cbor
    final cborInst = Cbor();
    cborInst.decodeFromList(cborMessage);
    var data = cborInst.getDecodedData();

    // return message
    return Message(
      data[0],
      data[1],
      LocationData.fromMap({
        "latitude": data[2],
        "longitude": data[3],
      }),
      data[4],
      DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
      isLocalUser,
    );
  }

  List<int> toCbor() {
    final cborInst = Cbor();
    final encoder = cborInst.encoder;

    encoder.writeString(channel);
    encoder.writeString(user);
    encoder.writeFloat(location.latitude);
    encoder.writeFloat(location.longitude);
    encoder.writeString(text);

    return cborInst.output.getData().toList();
  }

  Map<String, dynamic> toJson() => {
        '"user"': '"' + user + '"',
        '"text"': '"' + text + '"',
        '"channel"': '"' + channel + '"',
        '"timestamp"': '"' + timestamp + '"',
        '"isLocalUser"': '"' + isLocalUser.toString() + '"',
        '"location"': '"' + location.latitude.toString() + "," + location.longitude.toString() + '"'
      };

  static Message fromJson(Map<String, dynamic> model) {
    List<String> lonLatStringList = model["location"].split(",");
    LocationData _location = LocationData.fromMap({
      "latitude": double.parse(lonLatStringList[0]),
      "longitude": double.parse(lonLatStringList[1]),
    });

    return new Message(
      model["channel"],
      model["user"],
      _location,
      model["text"],
      model["timestamp"],
      model["isLocalUser"].toLowerCase() == "true",
    );
  }

  String get timestampString => new DateFormat("HH:mm:ss (dd/MM/yyyy)")
      .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp)))
      .toString();
}

class MessageItem extends StatelessWidget {
  MessageItem({this.message, this.animationController});

  final Message message;
  final AnimationController animationController;

  List<Widget> buildMessageRow(BuildContext context) {
    if (message.isLocalUser) {
      return <Widget>[
        new Expanded(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              new Text(message.timestampString + " | " + message.user, style: Theme.of(context).textTheme.caption),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(message.text),
              ),
            ],
          ),
        ),
        new Container(
          margin: const EdgeInsets.only(left: 16.0),
          child: new CircleAvatar(child: new Text('${message.user[0]}')),
        ),
      ];
    } else {
      return <Widget>[
        new Container(
          margin: const EdgeInsets.only(right: 16.0),
          child: new CircleAvatar(child: new Text('${message.user[0]}')),
        ),
        new Expanded(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(message.user + " | " + message.timestampString, style: Theme.of(context).textTheme.caption),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(message.text),
              ),
            ],
          ),
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
        sizeFactor: new CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        axisAlignment: 0.0,
        child: new Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildMessageRow(context),
          ),
        ));
  }
}
