import 'package:BlueRa/data/Channel.dart';
import 'package:BlueRa/data/Message.dart';
import 'package:flutter/material.dart';

String localUser = "Distributed Systems";
String other = "Verpeilte Systeme";
String third = "Anon";

List<Message> announceMessages = <Message>[
  Message(third, "Super", "Announcements", "1574689628", false),
  Message(localUser, "Unterwegs", "Announcements", "1574689728", true),
  Message(third, "Treffpunkt: Hof", "Announcements", "1574689828", false),
  Message(other, "Achtung Feuer", "Announcements", "1574689928", false),
];

List<Message> publicMessages = <Message>[
  Message(third, "toll", "Public Chat", "1574689628", false),
  Message(localUser, "Und ich erst.", "Public Chat", "1574689728", true),
  Message(third, "Finde ich auch.", "Public Chat", "1574689828", false),
  Message(other, "Ganz tolle Nachricht.", "Public Chat", "1574689928", false),
];

ValueNotifier<Channel> announcements = ValueNotifier(Channel("Announcements", announceMessages));
ValueNotifier<Channel> publics = ValueNotifier(Channel("Public Chat", publicMessages));

Channel notPart1 = Channel("Random", new List<Message>());
Channel notPart2 = Channel("Help", new List<Message>());
Channel notPart3 = Channel("Cool Stuff", new List<Message>());

List<ValueNotifier<Channel>> channels = <ValueNotifier<Channel>>[
  announcements,
  publics
];

List<Channel> notPartChannels = <Channel>[
  notPart1,
  notPart2,
  notPart3
];

ValueNotifier<Channel> getChannel(String name) {
  for (final chan in channels) {
    if (chan.value.name == name) {
      return chan;
    }
  }

  return null;
}

Channel getChannelFrom(String name, List<Channel> channelList) {
  for (final chan in channelList) {
    if (chan.name == name) {
      return chan;
    }
  }

  return null;
}
