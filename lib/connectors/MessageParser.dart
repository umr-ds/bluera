import 'package:BlueRa/data/Message.dart';
import 'package:BlueRa/data/Channel.dart';
import 'package:BlueRa/data/Globals.dart';
import 'package:BlueRa/connectors/Database.dart';
import 'package:flutter/material.dart';

  void handleRecvData(String completeMessage) {
    final DBConnector dbHelper = DBConnector.instance;
    List<String> messageParts = completeMessage.split("|");

    String channelString = messageParts[0];
    String user = messageParts[1];
    String msgString = messageParts.sublist(3).join("|");

    List<String> lonLatStringList = messageParts[2].split(",");
    UserLocation _location = UserLocation(
      longitude: double.parse(lonLatStringList[0]),
      latitude: double.parse(lonLatStringList[1])
    );

    String tsString = DateTime.now().toUtc().millisecondsSinceEpoch.toString();

    Message msg = Message(user, msgString, channelString, tsString, false, _location);
    ValueNotifier<Channel> channel = Channel.getChannel(channelString);

    if (channel == null) {
      channel = ValueNotifier(Channel(channelString, false, [msg]));
      channels.value.add(channel);
      dbHelper.insert(channel.value.toMap());
    } else {
      channel.value.messages.insert(0, msg);
      dbHelper.update(channel.value.toMap());
    }

    channel.notifyListeners();
  }
