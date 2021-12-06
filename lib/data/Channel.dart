import 'package:flutter/material.dart';
import 'package:bluera/screens/Chat.dart';
import 'package:bluera/data/Message.dart';
import 'package:bluera/data/Globals.dart';
import 'package:bluera/connectors/Database.dart';

class Channel {
  Channel(this.name, this.attending, this.messages);

  String name;
  bool attending;
  List<Message> messages;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'attending': attending.toString(),
      'messages': encondeToJson(messages),
    };
  }

  static String encondeToJson(List<Message> messages) {
    List<Map<String, dynamic>> jsonList = [];
    messages.map((item) => jsonList.add(item.toJson())).toList();
    return jsonList.toString();
  }

  static ValueNotifier<Channel> getChannel(String name) {
    for (final chan in channels.value) {
      if (chan.value.name == name) {
        return chan;
      }
    }

    return null;
  }
}

class ChannelOverviewItem extends StatelessWidget {
  const ChannelOverviewItem(this.chan, this.context);

  final Channel chan;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: PageStorageKey<Channel>(chan),
      title: Text(chan.name),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        ValueNotifier<Channel> channel = Channel.getChannel(chan.name);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(channel),
          ),
        );
      },
    );
  }
}

class AddChannelOverviewItem extends StatelessWidget {
  AddChannelOverviewItem(this.chan);

  final Channel chan;

  final DBConnector dbHelper = DBConnector.instance;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: PageStorageKey<Channel>(chan),
      title: Text(chan.name),
      trailing: Icon(Icons.person_add),
      onTap: () {
        ValueNotifier<Channel> channel = Channel.getChannel(chan.name);
        channel.value.attending = true;
        dbHelper.update(channel.value.toMap());
        //channels.notifyListeners();
        Navigator.pop(context);
      },
    );
  }
}
