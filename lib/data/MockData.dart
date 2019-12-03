import 'package:BlueRa/data/Channel.dart';
import 'package:BlueRa/data/Message.dart';
import 'package:flutter/material.dart';

String localUser = "Distributed Systems";
String other = "Verpeilte Systeme";
String third = "Anon";

List<Message> announceMessages = <Message>[
  Message(third, "Super", "Announcements", "1575282534640", false),
  Message(localUser, "Unterwegs", "Announcements", "1575282554640", true),
  Message(third, "Treffpunkt: Hof", "Announcements", "1575282564640", false),
  Message(other, "Achtung Feuer", "Announcements", "1575282584640", false),
];

List<Message> publicMessages = <Message>[
  Message(third, "toll", "Public Chat", "1575282534640", false),
  Message(localUser, "Und ich erst.", "Public Chat", "1575282554640", true),
  Message(third, "Finde ich auch.", "Public Chat", "1575282564640", false),
  Message(other, "Ganz tolle Nachricht.", "Public Chat", "1575282584640", false),
];

ValueNotifier<Channel> announcements = ValueNotifier(Channel("Announcements", announceMessages));
ValueNotifier<Channel> publics = ValueNotifier(Channel("Public Chat", publicMessages));

ValueNotifier<Channel> notPart1 = ValueNotifier(Channel("Random", new List<Message>()));
ValueNotifier<Channel> notPart2 = ValueNotifier(Channel("Help", new List<Message>()));
ValueNotifier<Channel> notPart3 = ValueNotifier(Channel("Cool Stuff", new List<Message>()));

ValueNotifier<List<ValueNotifier<Channel>>> channels = new ValueNotifier<List<ValueNotifier<Channel>>>(
  <ValueNotifier<Channel>>[
    announcements,
    publics
  ]
);

ValueNotifier<List<ValueNotifier<Channel>>> notPartChannels = new ValueNotifier<List<ValueNotifier<Channel>>>(
  <ValueNotifier<Channel>>[
    notPart1,
    notPart2,
    notPart3
  ]
);

ValueNotifier<Channel> getChannel(String name) {
  for (final chan in channels.value) {
    if (chan.value.name == name) {
      return chan;
    }
  }

  return null;
}

ValueNotifier<Channel> getChannelFrom(String name, ValueNotifier<List<ValueNotifier<Channel>>> channelList) {
  for (final chan in channelList.value) {
    if (chan.value.name == name) {
      return chan;
    }
  }

  return null;
}
