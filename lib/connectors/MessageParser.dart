import 'package:BlueRa/data/Message.dart';
import 'package:BlueRa/data/Channel.dart';
import 'package:BlueRa/data/Globals.dart';
import 'package:BlueRa/connectors/Database.dart';
import 'package:flutter/material.dart';

  void handleRecvData(String completeMessage) {
    final DBConnector dbHelper = DBConnector.instance;
    List<String> messageParts = completeMessage.split("|");

    String user = messageParts[0];
    String channelString = messageParts[1];
    String tsString = messageParts[2];
    String msgString = messageParts[3];

    Message msg = Message(user, msgString, channelString, tsString, false);
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
