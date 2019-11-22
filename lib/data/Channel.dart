import 'package:flutter/material.dart';
import 'package:Bluera/screens/Chat.dart';
import 'package:Bluera/data/Message.dart';
import 'package:Bluera/data/MockData.dart';

class Channel {
  Channel(this.name, this.messages);

  final String name;
  final List<Message> messages;
}

class ChannelOverview {
  ChannelOverview(this.name, this.lastMessage);

  final String name;
  final String lastMessage;
}

class ChannelOverviewItem extends StatelessWidget {
  const ChannelOverviewItem(this.chan, this.context);

  final ChannelOverview chan;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: PageStorageKey<ChannelOverview>(chan),
      title: Text(chan.name),
      subtitle: Text(chan.lastMessage),
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

  final ChannelOverview chan;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: PageStorageKey<ChannelOverview>(chan),
      title: Text(chan.name),
      trailing: Icon(Icons.person_add),
      onTap: () {
        notPartChannelOverviews.remove(chan);
        channelOverviews.add(chan);
        Channel channel = getChannelFrom(chan.name, notPartChannels);
        notPartChannels.remove(channel);
        channels.add(channel);
        Navigator.pop(context);
      },
    );
  }
}
