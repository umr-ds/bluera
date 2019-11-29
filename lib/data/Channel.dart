import 'package:flutter/material.dart';
import 'package:BlueRa/screens/Chat.dart';
import 'package:BlueRa/data/Message.dart';
import 'package:BlueRa/data/MockData.dart';

class Channel {
  Channel(this.name, this.messages);

  final String name;
  final List<Message> messages;
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
        Channel channel = getChannel(chan.name);
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
  const AddChannelOverviewItem(this.chan);

  final Channel chan;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: PageStorageKey<Channel>(chan),
      title: Text(chan.name),
      trailing: Icon(Icons.person_add),
      onTap: () {
        Channel channel = getChannelFrom(chan.name, notPartChannels);
        notPartChannels.remove(channel);
        channels.add(channel);
        Navigator.pop(context);
      },
    );
  }
}
