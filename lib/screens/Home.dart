import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:Bluera/screens/Chat.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Bluera"),
        backgroundColor: Color(0xFF0A3D91),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.add),
            onPressed: (){},
          ),
          new IconButton(icon: new Icon(Icons.settings),
            onPressed: (){},
          ),
        ],
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (BuildContext context, int index) =>
            ChannelItem(_channels[index], context),
        itemCount: _channels.length,
      ),
    );
  }
}

class Channel {
  Channel(this.name, this.lastMessage);

  final String name;
  final String lastMessage;
}

final List<Channel> _channels = <Channel>[
  Channel("Announcements", "Keep Calm"),
  Channel("Public Chat", "and use Bluera")
];

class ChannelItem extends StatelessWidget {
  const ChannelItem(this.entry, this.context);

  final Channel entry;
  final BuildContext context;

  Widget _buildTiles(Channel chan) {
    return ListTile(
      key: PageStorageKey<Channel>(chan),
      title: Text(chan.name),
      subtitle: Text(chan.lastMessage),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
