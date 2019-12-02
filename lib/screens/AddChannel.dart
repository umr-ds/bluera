import 'package:flutter/material.dart';
import 'package:BlueRa/data/MockData.dart';
import 'package:BlueRa/data/Channel.dart';
import 'package:BlueRa/data/Message.dart';

class AddChannelDialog extends StatefulWidget {
  String _channelNameField = "";

  @override
  AddChannelDialogState createState() => new AddChannelDialogState();
}

class AddChannelDialogState extends State<AddChannelDialog> {
  TextEditingController _channelNameController = new TextEditingController();

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
                child: new ListView.separated(
                  separatorBuilder: (BuildContext context, int index) => Divider(),
                  itemBuilder: (BuildContext context, int index) =>
                      AddChannelOverviewItem(notPartChannels[index]),
                  itemCount: notPartChannels.length,
                ),
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
                        widget._channelNameField = _channelNameController.text;
                        Channel _chn = new Channel(widget._channelNameField, new List<Message>());
                        channels.add(ValueNotifier(_chn));
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
