import 'package:flutter/material.dart';

import 'package:BlueRa/data/Globals.dart';
import 'package:BlueRa/data/Channel.dart';
import 'package:BlueRa/data/Channel.g.m8.dart';

class AddChannelDialog extends StatefulWidget {
  @override
  AddChannelDialogState createState() => new AddChannelDialogState();
}

class AddChannelDialogState extends State<AddChannelDialog> {
  TextEditingController _channelNameController = new TextEditingController();
  bool _valid = false;

  Future<void> _refresh() async {
    setState(() {});
    return;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Join channel"),
        backgroundColor: Color(0xFF0A3D91),
      ),
      body: new Padding(
        child: new Column(
          children: <Widget>[
            new Flexible(
              child: FutureBuilder<List<ChannelProxy>>(
                future: databaseProvider.getChannelProxiesAll(),
                builder: (context, snapshot) => RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                    itemCount: snapshot.hasData
                        ? snapshot.data
                            .where((channel) => !channel.attending)
                            .length
                        : 0,
                    itemBuilder: (BuildContext context, int index) {
                      return AddChannelOverviewItem(
                        snapshot.data
                            .where((channel) => !channel.attending)
                            .toList()[index],
                      );
                    },
                  ),
                ),
              ),
            ),
            new Divider(color: Color(0xFF000000)),
            new TextField(
              controller: _channelNameController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Create new channel',
                errorText: _valid
                    ? "Channel name must not be empty and must not contain '|'"
                    : null,
              ),
            ),
            new Row(
              children: <Widget>[
                new Expanded(
                    child: new RaisedButton(
                  onPressed: () {
                    setState(() {
                      bool notEmpty = _channelNameController.text.isNotEmpty;
                      bool validChars =
                          !(_channelNameController.text.contains("|"));
                      (notEmpty && validChars) ? _valid = true : _valid = false;
                    });
                    if (_valid) {
                      ChannelProxy newChannel = ChannelProxy(
                        name: _channelNameController.text,
                        attending: true,
                      );
                      databaseProvider.saveChannel(newChannel);
                      Navigator.pop(context);
                    }
                  },
                  child: new Text("Create"),
                ))
              ],
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
      ),
    );
  }
}

class AddChannelOverviewItem extends StatelessWidget {
  AddChannelOverviewItem(this.channel);
  final ChannelProxy channel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: PageStorageKey<Channel>(channel),
      title: Text(channel.name),
      trailing: Icon(Icons.person_add),
      onTap: () async {
        channel.attending = true;
        databaseProvider.updateChannel(channel);
        Navigator.pop(context);
      },
    );
  }
}
