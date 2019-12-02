import 'package:BlueRa/data/Message.dart';
import 'package:BlueRa/data/Channel.dart';
import 'package:BlueRa/data/MockData.dart';
import 'package:flutter/material.dart';

  void handleRecvData(String completeMessage) {
    List<String> messageParts = completeMessage.split("|");

    String user = messageParts[0];
    String channelString = messageParts[1];
    String tsString = messageParts[2];
    String msgString = messageParts[3];

    Message msg = Message(user, msgString, channelString, tsString, false);
    ValueNotifier<Channel> channel = getChannel(channelString);

    if (channel == null) {
      channel = ValueNotifier(Channel(channelString, []));
    }

    channel.value.messages.insert(0, msg);
    channel.notifyListeners();
  }
