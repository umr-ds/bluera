import 'package:flutter/material.dart';
import 'package:BlueRa/data/Globals.dart';
import 'package:BlueRa/data/Channel.dart';
import 'package:BlueRa/data/Message.dart';
import 'package:BlueRa/connectors/Database.dart';

class AddChannelDialog extends StatefulWidget {
  @override
  AddChannelDialogState createState() => new AddChannelDialogState();
}

class AddChannelDialogState extends State<AddChannelDialog> {
  TextEditingController _channelNameController = new TextEditingController();
  final DBConnector dbHelper = DBConnector.instance;

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
                child: ValueListenableBuilder(
                  valueListenable: channels,
                  builder: (BuildContext context, List<ValueNotifier<Channel>> channels, Widget child) {
                    var localChannels = channels.where((channel) => channel.value.attending == false).toList();
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                          return AddChannelOverviewItem(localChannels[index].value);
                      },
                      itemCount: localChannels.length,
                    );
                  },
                )
              ),
              new Divider(color: Color(0xFF000000)),
              new TextField(
                controller: _channelNameController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Create new channel'
                ),
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new RaisedButton(
                      onPressed: () {
                        Channel tmpChannel = Channel(_channelNameController.text, true, new List<Message>());
                        dbHelper.insert(tmpChannel.toMap());
                        ValueNotifier<Channel> _chn = ValueNotifier(tmpChannel);
                        channels.value.add(_chn);
                        channels.notifyListeners();
                        Navigator.pop(context);
                      },
                    child: new Text("Create"),
                  ))
                ],
              )
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
        ));
  }
}
